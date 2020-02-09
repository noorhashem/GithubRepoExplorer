//
//  DataService.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation
import SwiftyJSON

class Dataservice {
    
    //Variables and Constants
    static let  instance = Dataservice()
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    var errorMessage = ""
    let request = ApiRequest()
    private var currentPage = 1
    private var total = 0
    private var GetRepoDataInProgress = false
    var delegate: DataServiceDelegate?
  
    //Type Alias
    typealias JSONDictionary = [String:Any]
    typealias repoResponse = Array<Dictionary<String, Any>>
    
    //MARK: problem with matching completion handlers
    func getUserData(apiUrl:String, page : Int, requestType:String, completion: @escaping (HTTPURLResponse) -> ()) {
        dataTask?.cancel()
        
        switch (requestType) {
        case "user" :
            var request = ApiRequest().infoRequest
            break
        case "repo" :
            var request = ApiRequest().repoRequest
            break
        default:
            print("error with setting up request")
        }
        
        dataTask = defaultSession.dataTask(with: URL(string: apiUrl)!){ [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data , let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("insideGetUserData")
                do {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    switch (requestType) {
                    case "user" :
                //MARK: DUN UNDERSTAND WHY I HAVE TO USE OPTIONAL HERE
                        let Dict = json as! JSONDictionary
                        self?.parseUserData(data: Dict)
                        completion(response)
                        break
                    case "repo" :
                         let Dict = json as! [JSONDictionary]
                        self?.parseRepoData(data: Dict)
                        completion(response)
                        break
                    default:
                        print("error with setting up request")
                    }
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
            }
        }
        dataTask?.resume()
        
    }
    

    func userRepos(completion: @escaping ()->()) {
        guard !GetRepoDataInProgress else {
            return
        }
        GetRepoDataInProgress = true
        self.getUserData(apiUrl: request.repoPath, page: request.getPage(), requestType: "repo") { result in
            switch result.statusCode {
                
            case 200 :
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.GetRepoDataInProgress = false
                    
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: UserDataSource.instance.Repos)
                        self.delegate?.onGetDataCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onGetDataCompleted(with: .none)
                    }
                    
                    completion()
                }
                
            default:
                print("error with requesting from API")
            }
            
        }
    }
    
    private func calculateIndexPathsToReload(from newRepos: [Repo]) -> [IndexPath] {
        let startIndex = UserDataSource.instance.Repos.count - newRepos.count
        let endIndex = startIndex + newRepos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    func parseRepoData(data : [JSONDictionary]){
        
        for i in 0...(data.count - 1) {
            
            let name = data[i]["name"]!
            let desc = data[i]["description"] as? String ?? ""
            let forks = data[i]["forks"]!
            let lang = data[i]["language"] as? String ?? ""
            let date = data[i]["created_at"]!
            let url = data[i]["html_url"]!
            
            let userRepo = Repo(title: name as! String, description: desc , forks: forks as! Int, writtenIn: lang as! String , created: date as! String, repoUrl: url as! String)
            UserDataSource.instance.Repos.append(userRepo)
        }
      
    }
    
    func parseUserData(data:JSONDictionary){
        UserDataSource.instance.setUserData(usrName: data["name"] as! String, url: data["avatar_url"] as! String, repos_count: data["public_repos"] as! Int, repos: [])
    }
}
