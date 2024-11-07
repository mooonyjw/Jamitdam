//
//  Posts.swift
//  Jamitdam
//
//  Created by sojeong on 11/5/24.
//

import SwiftUI
import Foundation

struct Post {
    let id: UUID = UUID()       // 글 id
    var comments: [Int]         // 댓글 (댓글을 문자열 배열로 처리)
    let body: String            // 본문
    let timestamp: Date         // 시각
    let author: String          // 작성자 아이디
    let title: String           // 제목
    var likesCount: Int         // 좋아요 수
    var hashTags: [String]      // 해시태그 배열
    let relationshipIDs: [UUID]  // 등장하는 인연 id
    
    // 글 해시태그 추가
    mutating func addHashTags(hastTags: [String]) {
        self.hashTags.append(contentsOf: hastTags)
    }
    
    // 글 좋아요수 증가
    mutating func increaseLikesCount() {
        self.likesCount += 1
    }
    
    // 댓글 추가 추후 구현
    // ...
}


// 유수현의 인연 추가
let relationship1 = Relationship(nickname: "철수", hashtags: ["#친구"], icon: "👤", startDate: Date(), userId: user1.userID)
let relationship2 = Relationship(nickname: "영희", hashtags: ["#썸남"], icon: "👩", startDate: Date(), userId: user1.userID)


// 더미데이터 생성
// 유수현의 포스트 (user1)
var dummyPosts: [Post] = [
    Post(comments: [], body: "밥 뭐먹지", timestamp: Date(), author: user1.userID, title: "점메추", likesCount: 5, hashTags: ["#친구"], relationshipIDs: [relationship1.id]),
    Post(comments: [], body: "밥 먹자고 안하네", timestamp: Date(), author: user1.userID, title: "답답해", likesCount: 8, hashTags: ["#썸남", "#답답"], relationshipIDs: [relationship2.id]),
]


func getPosts() -> [Post] {
    return dummyPosts
}

func addPost(post: Post) {
    dummyPosts.append(post)
}

func deletePost(post: Post) {
    dummyPosts.removeAll { $0.id == post.id }
}

