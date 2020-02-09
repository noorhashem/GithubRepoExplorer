//
//  API_Request.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/23/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation

struct ApiRequest {
    
    var pageNumber = 0
    var repoPath : String {
        return reposURL
    }
    
    var usrPath : String {
        return baseURL + user
    }
    
    
    var infoRequest: URLRequest {
        var request = URLRequest(url: URL(string: usrPath)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    var repoRequest: URLRequest {
        var request = URLRequest(url: URL(string: repoPath)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("desc", forHTTPHeaderField: "direction")
        let parameters = ["?page" : "\(getPage())"]
        let encodedURLRequest = request.query(with: parameters)
        return encodedURLRequest
    }
    
    func getPage() -> Int {
        return pageNumber
    }
    
    mutating func setPage(number : Int) {
        self.pageNumber = number
    }
    

    
    
    
}
