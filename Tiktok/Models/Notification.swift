//
//  Notification.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/12/22.
//

import Foundation


enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
            
        case .postLike:
            return "postLike"
        case .userFollow:
            return "userFollow"
        case .postComment:
            return "postComment"
        }
    }
}


class Notification {
    var identifier = UUID().uuidString
    var isHidden = false
    let text: String
    let date: Date
    let type: NotificationType
    
    init(text: String, date: Date, type: NotificationType) {
        self.text = text
        self.date = date
        self.type = type
    }
    static func mockData() ->[Notification] {
        
        let first = Array(0...5).compactMap({Notification(text: "Something happened: \($0)", date: Date(),
                                                            type: .postComment(postName: "kaan"))
        })
    
        let second = Array(0...5).compactMap({Notification(text: "Something happened: \($0)", date: Date(),
                                                            type: .userFollow(username: "kanyewest") )
        })
       
        let third = Array(0...5).compactMap({Notification(text: "Something happened: \($0)", date: Date(),
                                                       type: .postLike(postName: "shakira"))
        })
        
      return first + second + third
    }
    
}
