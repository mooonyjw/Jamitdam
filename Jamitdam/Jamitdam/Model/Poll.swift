import SwiftUI
import Foundation

struct Poll {
    let id: UUID = UUID()
    var writer: User // 투표 작성자
    var content: String? // 글 본문
    var options: [String] // 투표 옵션
    var votes: [Int] // 각 옵션에 대한 투표 수
    var voters: [UUID: Int] // [투표자 ID: 선택한 옵션 Index]
    var createdAt: Date // 투표 글 생성 시간
    
    // 투표 추가
    mutating func vote(by voter: User, for optionIndex: Int) {
        // 기존 투표자의 선택 변경 처리
        if let previousVote = voters[voter.id] {
            votes[previousVote] -= 1 // 이전 선택된 옵션에서 1 감소
        }

        // 새로운 투표 추가
        votes[optionIndex] += 1 // 선택된 옵션에서 1 증가
        voters[voter.id] = optionIndex // 투표자 ID에 새로운 선택 저장
    }
    
    
    // 시간 경과 문자열 반환
    func timeElapsedString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

// 투표 작성자
let pollAuthor = user1

// 투표 관련 더미 데이터
var dummyPolls: [Poll] = [
    Poll(
        writer: pollAuthor,
        content: "내일 뭐먹지\n\n🐯호랭이랑 첫 데이트인데 뭐 먹을지 골라줘\n얘들아.....ㅠㅠ",
        options: ["성수신데렐라", "옛날감자탕"],
        votes: [2, 1],
        voters: [:],
        createdAt: Date().addingTimeInterval(-180)// user1이 첫 번째 옵션에 투표
    ),
    Poll(
        writer: pollAuthor,
        content: "나는야\n\n🧑🏻‍💻게임중독자가 보고 싶다 흐하하 \n저메추ㅋ",
        options: ["피자", "치킨", "햄버거"],
        votes: [2, 7, 4],
        voters: [:],
        createdAt: Date().addingTimeInterval(-10)// 아직 투표자가 없음
    ),
    Poll(
        writer: user2,
        content: "나 대망의 첫 소개팅임. 컄ㅋ캬컄컄ㅋㅋ \n\n그런 의미에서 나 뭐입고 갈지 추천해줘 ㅎㅎ \n성공하면 밥살게 ㅎㅎ",
        options: ["치마+롱부츠", "원피스", "흰티+청바지"],
        votes: [1, 0, 5],
        voters: [:],
        createdAt: Date().addingTimeInterval(-900)
    )
]
