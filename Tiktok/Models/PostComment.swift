//
//  PostComment.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/4/22.
//

import Foundation


struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "kanyewest", profilePictureURL: nil, identifier: UUID().uuidString)
        var comments = [PostComment]()
        
        
        let text = ["This is cool", "This is rad", "Im learning so much!"]
        
        for comment in text {
            comments.append(PostComment(text: comment, user: user, date: Date()))
            
        }
        return comments
    }
}
