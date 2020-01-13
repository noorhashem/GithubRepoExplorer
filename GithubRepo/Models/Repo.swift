//
//  Repo.swift
//  GithubRepo
//
//  Created by McNoor's  on 12/16/19.
//  Copyright © 2019 McNoor's . All rights reserved.
//

import Foundation

struct Repo {
    
    var repoTitle : String
    var repoDescription : String
    var forksCount = 0
    var language : String
    var dateCreated : String
    var repoUrl : String
    

    
    init(title : String, description : String, forks: Int, writtenIn lang: String, created: String, repoUrl : String) {
        self.repoTitle = title
        self.repoDescription = description
        self.forksCount = forks
        self.language = lang
        self.dateCreated = created
        self.repoUrl = repoUrl
    }
    

    func formatDateTime (passedDate : String) -> String {
        var finalDate : String = ""
        var finalTime : String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "d/MM/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ssZ"
        
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "h:mm a"
        
        let dateTimeComp = passedDate.components(separatedBy: "T")
        
        let splitDate = dateTimeComp[0]
        let splitTime = dateTimeComp[1]
        
        if let date = dateFormatter.date(from: splitDate) {
            print(passedDate)
            print(splitDate)
            finalDate = newDateFormatter.string(from: date)
        }
        
        if let time = timeFormatter.date(from: splitTime) {
            print(splitTime)
            finalTime = newTimeFormatter.string(from: time)
        }
        
        let dateTimeLabelValue = finalDate + "  " + finalTime
        
        return dateTimeLabelValue
    }
    
}
