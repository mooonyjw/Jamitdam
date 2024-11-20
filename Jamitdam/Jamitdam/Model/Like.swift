import SwiftUI

struct Like {
    // 좋아요 번호
    let id: UUID = UUID()
    // 유저 아이디
    let userId: UUID
    // 글 아이디
    let postID: UUID
}

// 유수현
var user = user1
// 유수현이 좋아요누른 글
var dummylikes: [Like] =
