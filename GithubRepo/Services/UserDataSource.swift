//
//  UserDataSource.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation


class UserDataSource {
    
    static let instance = UserDataSource()
    
    public private (set) var userName = ""
    public private (set) var userImageUrl = ""
    public private (set) var userReposNum = 0
    public var Repos = [Repo]()
    
    
    func setUserData(usrName : String, url : String,repos_count : Int, repos : [Repo]){
        self.userName = usrName
        self.userImageUrl = url
        self.userReposNum = repos_count
        self.Repos = repos
    }
    
    func getName() -> String {
        if userName != ""{
            return self.userName
        }
        else {
            print("username is empty")
            return ""
        }
        
    }
    
    func getRepos() -> Int {
        return userReposNum
    }
}
