//
//  ViewController.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import UIKit
import SafariServices

class GitProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileUsername: UILabel!
    
    @IBOutlet weak var numRepos: UILabel!
    
    @IBOutlet weak var repoList: UITableView!
    
    //Variables and Constants
    let apiResults : [String : Any] = [:]
    //MARK:let userRepo : [Repo] = [] //why lazem intializers?? //fe tare2a tanya abasy beeha el repos?
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingUserData()
        repoList.dataSource = self
        repoList.delegate = self
       
    }
    
    func gettingUserData() {
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
        Dataservice.instance.getUserRepos(apiUrl: reposURL){
            DispatchQueue.main.async {
                self.repoList.reloadData()
                
            }
         
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserDataSource.instance.Repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoCell
        cell.repoTitle.text = UserDataSource.instance.Repos[indexPath.item].repoTitle
        cell.repoDesc.text = UserDataSource.instance.Repos[indexPath.item].repoDescription
        cell.repoLanguage.text = "Language : " + UserDataSource.instance.Repos[indexPath.item].language
        cell.forkCount.text = "Forks : \(UserDataSource.instance.Repos[indexPath.item].forksCount)"
        cell.repoDate.text = "\(UserDataSource.instance.Repos[indexPath.item].formatDateTime(passedDate: UserDataSource.instance.Repos[indexPath.item].dateCreated))"
        cell.userAvatar.load(url: URL(string: UserDataSource.instance.userImageUrl as! String)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let svc = SFSafariViewController(url: URL(string: UserDataSource.instance.Repos[indexPath.item].repoUrl)!)
        present(svc, animated: true, completion: nil)
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

