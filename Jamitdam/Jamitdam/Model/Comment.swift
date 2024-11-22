import SwiftUI

struct Comment {
    // 댓글 id
    let id: UUID = UUID()
    // 작성자 id
    let userId: UUID
    // 글 id
    let postId: UUID
    // 작성 시각
    let date: Date
    // 내용
    let content: String
    // nil이면 최상위 댓글, 값이 있으면 대댓글
    let parentId: UUID?
}

// 유수현 밥뭐먹지 글
var post: Post = dummyPosts[0]

var comment1: Comment = Comment(userId: user2.id, postId: post.id, date: Date() - 60 * 60, content: "굶어", parentId: nil)
var comment2: Comment = Comment(userId: user3.id, postId: post.id, date: Date() - 60 * 3, content: "설렁탕 어떤데", parentId: nil)
// comment2의 대댓글
var co_comment1: Comment = Comment(userId: user3.id, postId: post.id, date: Date() - 60 * 2, content: "마라탕", parentId: comment2.id)
