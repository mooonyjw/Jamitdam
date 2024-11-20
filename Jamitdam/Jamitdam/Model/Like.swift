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
var posts1: [Post] = getPosts(for: user2, from: dummyPosts)
// 자신의 글에도 좋아요 눌렀다고 가정
var posts2: [Post] = getPosts(for: user1, from: dummyPosts)

var like1: Like = Like(userId: user1.id, postId: posts1[0].id)
var like2: Like = Like(userId: user1.id, postId: posts1[1].id)
var like3: Like = Like(userId: user1.id, postId: posts2[0].id)

var likes: [Like] = [like1, like2, like3]
