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
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    

    
   
    //Type Alias
    typealias JSONDictionary = [String:Any]
    typealias repoResponse = Array<Dictionary<String, Any>>
    
    
    func getUserData(apiUrl:String, completion: @escaping (JSONDictionary) -> ()) {
        dataTask?.cancel()
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
//        request.addValue("Bearer d344982e99f12b6672d49720b8e9adafe49f2aca", forHTTPHeaderField: "Authorization")
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
    
    
    func getUserRepos(apiUrl:String, completion: @escaping () -> ()) {
        dataTask?.cancel()
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "GET"
      //request.addValue("Bearer d344982e99f12b6672d49720b8e9adafe49f2aca", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("desc", forHTTPHeaderField: "direction")
        
        dataTask = defaultSession.dataTask(with: URL(string: apiUrl)!){ [weak self] data, response, error in
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
                    //var reposArray = [Repo]()
                    
                    for i in 0...(reposDict.count - 1) {
                        let name = reposDict[i]["name"]!
                        let desc = reposDict[i]["description"] as? String ?? ""
                        let forks = reposDict[i]["forks"]!
                        let lang = reposDict[i]["language"]!
                        let date = reposDict[i]["created_at"]!
                        let url = reposDict[i]["html_url"]!
                        
                        let userRepo = Repo(title: name as! String, description: desc , forks: forks as! Int, writtenIn: lang as! String, created: date as! String, repoUrl: url as! String)
                        UserDataSource.instance.Repos.append(userRepo)
                    }
                    completion()

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
            }
            
            
        }
        dataTask?.resume()
        
    }
    


    
    
    
    
    
    
    
    
    
}
