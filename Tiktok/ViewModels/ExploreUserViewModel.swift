//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/6/22.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    
    let profilePictureURL: URL?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
    
}
