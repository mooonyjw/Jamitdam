import SwiftUI
import Foundation

struct Post {
    let id: UUID = UUID()
    // 추후 댓글 db 구현 후 작성
    // var comments: [Comment]
    var content: String
    let timestamp: Date
    
    // 작성자
    let author: User
    
    let title: String
    var likesCount: Int
    
    // 글 해시태그 (최대 2개)
    var hashTags: [String]
    
    let relationships: [Relationship]
    
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
    Post(content: "밥 뭐먹지", timestamp: Date() - 60 * 60, author: user1, title: "점메추", likesCount: 5, hashTags: ["#친구"], relationships: [relationship1]),
    Post(content: "밥 먹자고 안하네", timestamp: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3)) ?? Date(), author: user1, title: "답답해", likesCount: 8, hashTags: ["#썸남", "#답답"], relationships: [relationship2]),

    //user2 포스트 추가
    Post(content: "user2", timestamp: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 10)) ?? Date(), author: user2, title: "테스트", likesCount: 5, hashTags: ["#친구"], relationships: [relationship1]),
    Post(content: "user2", timestamp: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5)) ?? Date(), author: user2, title: "test", likesCount: 8, hashTags: ["#썸남", "#답답"], relationships: [relationship2]),
    
]


func getPosts(for user: User, from allPosts: [Post]) -> [Post] {
    return allPosts.filter {$0.author.id == user.id}
}

func addPost(post: Post) {
    dummyPosts.append(post)
}

func deletePost(post: Post) {
    dummyPosts.removeAll { $0.id == post.id }
}

