import SwiftUI

struct Poll {
    let id: UUID = UUID()
    var writer: User // 투표 작성자
    var options: [String] // 투표 옵션
    var votes: [Int] // 각 옵션에 대한 투표 수
    var voters: [UUID: Int] // [투표자 ID: 선택한 옵션 Index]
    
    // 투표 추가
    mutating func vote(by voter: User, for optionIndex: Int) {
        // 기존 투표자의 선택 변경 처리
        if let previousVote = voters[voter.id] {
            votes[previousVote] -= 1
        }
        // 새로운 투표 추가
        votes[optionIndex] += 1
        voters[voter.id] = optionIndex
    }
}

// 투표 작성자(진서기)
let pollAuthor = user2

// 투표 관련 더미 데이터
var dummyPolls: [Poll] = [
    Poll(
        writer: pollAuthor,
        options: ["성수신데렐라", "옛날감자탕"],
        votes: [5, 3],
        voters: [user1.id: 0] // user1이 첫 번째 옵션에 투표
    ),
    Poll(
        writer: pollAuthor,
        options: ["피자", "치킨", "햄버거"],
        votes: [2, 7, 4],
        voters: [:] // 아직 투표자가 없음
    )
]
