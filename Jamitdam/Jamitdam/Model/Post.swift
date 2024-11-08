//
//  Task.swift
//  Jamitdam
//
//  Created by Jueun Son on 11/7/24.
//

import Foundation
import SwiftUI

// Post Model and Sample Posts
// Array of Posts
struct Post: Identifiable{
    var id = UUID().uuidString
    var title: String
    var content: String
    var emoji: String
    var nickname: String
    var hashtag: String
    
}

// Total post Meta View
struct PostMetaData: Identifiable{
    var id = UUID().uuidString
    //var post: [Post]
    var post: Post
    var postDate: Date
    
}

// sample Data for Testing
func getSampleDate(offset: Int)->Date{
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}

//sample posts
var posts: [PostMetaData] = [
    PostMetaData(
        post: Post(title: "대체 왜지???",
        content: "🐻‍❄️가 먼저 만나자고 말을 안 하는데 어떡하지!!!",
        emoji: "🐻‍❄️",
        nickname: "포동이",
        hashtag: "#썸남"),
    postDate: getSampleDate(offset: -3)
    )
]
