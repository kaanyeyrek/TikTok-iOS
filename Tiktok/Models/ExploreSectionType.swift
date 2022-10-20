//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/6/22.
//

import Foundation


enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case users
    case trendingHashtags
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
            
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Videos"
        case .users:
            return "Popular Creators"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
     
        case .trendingHashtags:
            return "Trending Hashtags"
        }
    }
}
