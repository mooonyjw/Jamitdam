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
    let comments: [Int]         // 댓글 (댓글을 문자열 배열로 처리)
    let body: String            // 본문
    let timestamp: Date         // 시각
    let author: UUID            // 작성자
    let title: String           // 제목
    let likesCount: Int         // 좋아요 수
    let hashTags: [String]      // 해시태그 배열
    let relationshipIDs: [UUID]  // 등장하는 인연 id
}

let relationship1 = Relationship(nickname: "철수", hashtags: ["#친구"], icon: "👤", startDate: Date(), userId: UUID())
let relationship2 = Relationship(nickname: "영희", hashtags: ["#썸남"], icon: "👩", startDate: Date(), userId: UUID())


// 더미데이터 생성

let dummyPosts: [Post] = [
    Post(comments: [1,2], body: "밥 뭐먹지", timestamp: Date(), author: relationship1.userId, title: "점메추", likesCount: 5, hashTags: ["#친구"], relationshipIDs: [relationship1.id]),
    Post(comments: [3], body: "밥 먹자고 안하네", timestamp: Date(), author: relationship2.userId, title: "답답해", likesCount: 8, hashTags: ["#썸남", "#답답"], relationshipIDs: [relationship2.id]),
]
