//
//  ViewController.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import UIKit
import SafariServices

class GitProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate, UITableViewDataSourcePrefetching{
    
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var numRepos: UILabel!
    
    @IBOutlet weak var repoList: UITableView!
    
    //Variables and Constants
    let apiResults : [String : Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        repoList.prefetchDataSource = self
        repoList.dataSource = self
        repoList.delegate = self
        gettingUserInfo()
        Dataservice.instance.delegate = self as? DataServiceDelegate
       
    }
    
    func gettingUserInfo() {
        Dataservice.instance.getUserData(apiUrl: baseURL + user) { apiResults in
            DispatchQueue.main.async {
                self.profileImage.load(url: URL(string: apiResults["avatar_url"] as! String)!)
                self.profileUsername.text = apiResults["name"] as? String
                self.numRepos.text = "\(apiResults["public_repos"] as? Int ?? 0) Repositories"
                 self.gettingUserRepos()
            }
        }
    }
    
    func gettingUserRepos(){
        Dataservice.instance.userRepos {
            DispatchQueue.main.async {
                self.repoList.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserDataSource.instance.userReposNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        cell.UpdateCellData(cellNum: indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let svc = SFSafariViewController(url: URL(string: UserDataSource.instance.Repos[indexPath.item].repoUrl)!)
        present(svc, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            Dataservice.instance.userRepos{
                DispatchQueue.main.async {
                    self.repoList.reloadData()
                }
            }
    }
}
    
}

private extension GitProfileVC {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= UserDataSource.instance.Repos.count
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = repoList.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}



extension UIImageView {
    func load (url : URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

