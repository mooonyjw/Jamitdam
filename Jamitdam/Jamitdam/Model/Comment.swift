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
    var content: String
    // nil이면 최상위 댓글, 값이 있으면 대댓글
    let parentId: UUID?
    
    // 시간 경과 문자열 반환
    func timeElapsedString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


var dummyComments: [Comment] = [comment1, comment2, co_comment1, comment2_1, comment2_2, co_comment1_2]
var dummyPollComments: [Comment] = [poll_comment1, poll_comment2, poll_comment3]

// 유수현 밥뭐먹지 글
var post: Post = dummyPosts[0]
// 첫 번째 poll
var poll: Poll = dummyPolls[0]

var comment1: Comment = Comment(userId: user2.id, postId: post.id, date: Date() - 60 * 60, content: "굶어", parentId: nil)
var comment2: Comment = Comment(userId: user3.id, postId: post.id, date: Date() - 60 * 3, content: "설렁탕 어떤데", parentId: nil)
// comment2의 대댓글
var co_comment1: Comment = Comment(userId: user3.id, postId: post.id, date: Date() - 60 * 2, content: "마라탕", parentId: comment2.id)

// poll 댓글
var poll_comment1: Comment = Comment(userId: user5.id, postId: poll.id, date: Date() - 60 * 1, content: "감자탕 미친놈아", parentId: nil)
var poll_comment2: Comment = Comment(userId: user5.id, postId: poll.id, date: Date() - 60 * 1, content: "감자탕 미친놈아", parentId: nil)
var poll_comment3: Comment = Comment(userId: user5.id, postId: poll.id, date: Date() - 60 * 1, content: "감자탕 미친놈아", parentId: nil)



var post2: Post = dummyPosts[1]

var comment2_1: Comment = Comment(userId: user2.id, postId: post2.id, date: Date() - 60 * 60, content: "굶어", parentId: nil)
var comment2_2: Comment = Comment(userId: user3.id, postId: post2.id, date: Date() - 60 * 3, content: "설렁탕 어떤데", parentId: nil)
// comment2의 대댓글
var co_comment1_2: Comment = Comment(userId: user3.id, postId: post2.id, date: Date() - 60 * 2, content: "마라탕", parentId: comment2.id)

