//
//  URLRequest.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/23/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation

typealias Parameters = [String : String]

extension URLRequest {
    func query (with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        var encodedURLRequest = self
        if let url = self.url , let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var newURLComponents = urlComponents
            let queryParameters = parameters.map {
                key, value in
                URLQueryItem(name: key, value: value)
            }
            newURLComponents.queryItems = queryParameters
            encodedURLRequest.url = newURLComponents.url
            return encodedURLRequest
        } else {
            return self
        }
    }
}
