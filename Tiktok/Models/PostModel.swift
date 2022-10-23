//
//  PostModel.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/30/22.
//

import Foundation

struct PostModel {
    var identifier: String
    var isLikedByCurrentUser = false
    let user: User
    var fileName: String = ""
    var caption: String = ""

    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0 ... 100 {
            let post = PostModel(identifier: UUID().uuidString, isLikedByCurrentUser: false, user: User(username: "Shakira", profilePictureURL: nil, identifier: UUID().uuidString))
            posts.append(post)
        }

        return posts
    }

    //  Represents database child path for this post in a given user node
    var videoChildPath: String {
        return "videos/\(user.username.lowercased())/\(fileName)"
    }

    
    
}
