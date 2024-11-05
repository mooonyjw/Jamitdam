//
//  Posts.swift
//  Jamitdam
//
//  Created by sojeong on 11/5/24.
//

import SwiftUI
import Foundation

struct Post {
    let id: Int                 // 글 id
    let comments: [String]      // 댓글 (댓글을 문자열 배열로 처리)
    let body: String            // 본문
    let timestamp: Date         // 시각
    let author: String          // 작성자
    let title: String           // 제목
    let likesCount: Int         // 좋아요 수
}

// 예시: 더미 데이터 생성
let dummyPosts: [Post] = [
    Post(id: 1, comments: ["첫 댓글!", "좋은 글 감사합니다."], body: "이것은 더미 데이터의 본문입니다.", timestamp: Date(), author: "작성자A", title: "더미 데이터 제목 1", likesCount: 5),
    Post(id: 2, comments: ["흥미로운 내용이네요."], body: "여기도 더미 데이터 본문이 들어갑니다.", timestamp: Date(), author: "작성자B", title: "더미 데이터 제목 2", likesCount: 8),
    Post(id: 3, comments: [], body: "댓글이 없는 게시글 더미 데이터.", timestamp: Date(), author: "작성자C", title: "더미 데이터 제목 3", likesCount: 2)
]
