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
    
    
    func getUserData(apiUrl:String, completion: @escaping (JSONDictionary) -> ()) {
        dataTask?.cancel()
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
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
                        let userDataDict = json as! JSONDictionary
                        UserDataSource.instance.setUserData(usrName: userDataDict["name"] as! String, url: userDataDict["avatar_url"] as! String, repos_count: userDataDict["public_repos"] as! Int, repos: [])
                        completion(userDataDict)
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }

            }
        }
        dataTask?.resume()

    }
    
    
    func getUserRepos(apiUrl:String,page: Int, completion: @escaping (HTTPURLResponse) -> ()) {
        dataTask?.cancel()
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("desc", forHTTPHeaderField: "direction")
        let parameters = ["?page" : "\(page)"]
        let encodedURLRequest = request.query(with: parameters)
        
        dataTask = defaultSession.dataTask(with: encodedURLRequest){ [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
    
            if let error = error {
                self!.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data , let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("insideGetRepos")
                do {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    var reposDict = json as! [JSONDictionary]
                    
                    for i in 0...(reposDict.count - 1) {
                        let name = reposDict[i]["name"]!
                        let desc = reposDict[i]["description"] as? String ?? ""
                        let forks = reposDict[i]["forks"]!
                        let lang = reposDict[i]["language"] as? String ?? ""
                        let date = reposDict[i]["created_at"]!
                        let url = reposDict[i]["html_url"]!
                        
                        let userRepo = Repo(title: name as! String, description: desc , forks: forks as! Int, writtenIn: lang as! String , created: date as! String, repoUrl: url as! String)
                        UserDataSource.instance.Repos.append(userRepo)
                    }
                    completion(response)

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
        self.getUserRepos(apiUrl: request.path, page: currentPage){ result in
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
}
