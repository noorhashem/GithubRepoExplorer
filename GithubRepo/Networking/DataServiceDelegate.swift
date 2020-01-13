//
//  DataServiceDelegate.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/23/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation

protocol DataServiceDelegate: class {
    func onGetDataCompleted(with newIndexPathsToReload : [IndexPath]?)
    func onGetDataFailed (with error : String)
}
