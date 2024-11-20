import SwiftUI

struct Like {
    // 좋아요 번호
    let id: UUID = UUID()
    // 유저 아이디
    let userId: UUID
    // 글 아이디
    let postId: UUID
}

// 유수현이 좋아요누른 글들
var posts: [Post] = getPosts(for: user2, from: dummyPosts)
var like1: Like = Like(userId: user1.id, postId: posts[0].id)
var like2: Like = Like(userId: user1.id, postId: posts[1].id)
