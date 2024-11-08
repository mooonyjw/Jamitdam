import SwiftUI
import Foundation

struct Post {
    let id: UUID = UUID()       
    var comments: [Int]
    let body: String
    let timestamp: Date
    
    // 작성자 id
    let authorId: UUID
    
    let title: String
    var likesCount: Int
    var hashTags: [String]
    let relationshipIds: [UUID]
    
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


// 유수현의 인연
let relationship1 = getRelationships()[0]
let relationship2 = getRelationships()[1]


// 더미데이터 생성
// 유수현의 포스트 (user1)
var dummyPosts: [Post] = [
    Post(comments: [], body: "밥 뭐먹지", timestamp: Date(), authorId: user1.id, title: "점메추", likesCount: 5, hashTags: ["#친구"], relationshipIds: [relationship1.id]),
    Post(comments: [], body: "밥 먹자고 안하네", timestamp: Date(), authorId: user1.id, title: "답답해", likesCount: 8, hashTags: ["#썸남", "#답답"], relationshipIds: [relationship2.id]),
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

