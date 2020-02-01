//
//  RepoCell.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var repoDesc: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var forkCount: UILabel!
    @IBOutlet weak var repoDate: UILabel!
    
    @IBOutlet weak var cardBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupView()
    }
    
    func UpdateCellData(cellNum : Int) {
        self.repoTitle.text = UserDataSource.instance.Repos[cellNum].repoTitle
        self.repoDesc.text = UserDataSource.instance.Repos[cellNum].repoDescription
        self.repoLanguage.text = "Language : " + UserDataSource.instance.Repos[cellNum].language
        self.forkCount.text = "Forks : \(UserDataSource.instance.Repos[cellNum].forksCount)"
        self.repoDate.text = "\(UserDataSource.instance.Repos[cellNum].formatDateTime(passedDate: UserDataSource.instance.Repos[cellNum].dateCreated))"
        self.userAvatar.load(url: URL(string: UserDataSource.instance.userImageUrl)!)
    }
    
    
    func setupView() {
        self.cardBackgroundView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.backgroundColor = UIColor( red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
        cardBackgroundView.layer.cornerRadius = 3.0
        cardBackgroundView.layer.masksToBounds = false
        cardBackgroundView.layer.shadowColor = #colorLiteral(red: 0.6470296637, green: 0.6470296637, blue: 0.6470296637, alpha: 1)
        cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardBackgroundView.layer.shadowOpacity = 0.8
    }
    
    
    
}
