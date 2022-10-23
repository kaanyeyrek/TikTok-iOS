//
//  TikTokTests.swift
//  TikTokTests
//
//  Created by Kaan Yeyrek on 10/23/22.
//

import XCTest
// Basic
@testable import TikTok

final class TikTokTests: XCTestCase {
    func testPostChilPath() {
        let id = UUID().uuidString
        let user = User(username: "billgates", profilePictureURL: nil, identifier: id)
        var post = PostModel(identifier: id, user: user)
       
        post.caption = "Hello"
        XCTAssertEqual(post.caption, "Hello")
        XCTAssertEqual(post.videoChildPath, "videos/billgates/")
        
    }

    
}
