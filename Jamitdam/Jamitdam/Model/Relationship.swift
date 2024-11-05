import SwiftUI

struct Relationship {
    var nickname: String
    var hashtags: [String]
    var icon: String
    let startDate: Date
    let userId: Int
}

// 유수현 인연을 기준으로 더미데이터 작성
// 유수현의 userId는 1이라고 가정

// 호랭이
var tiger = Relationship(nickname: "호랭이", hashtags: ["전남친", "동아리선배"], icon: "🐯", startDate: Date() - 86400 * 30 * 12, userId: 1)

// 포동이
var podong = Relationship(nickname: "포동이", hashtags: ["전썸남", "미팅"], icon: "🐻‍❄️", startDate: Date() - 86400 * 30 * 3, userId: 1)

// 게임중독자
var gamer = Relationship(nickname: "게임중독자", hashtags: ["전썸남"], icon: "🧑🏻‍💻", startDate: Date() - 86400 * 30 * 5, userId: 1)

// 능이백숙
var baeksook = Relationship(nickname: "능이백숙", hashtags: ["치근덕"], icon: "🕶️", startDate: Date() - 86400 * 30, userId: 1)

// SON
var son = Relationship(nickname: "SON", hashtags: ["전남친", "과CC"], icon: "⚽️", startDate: Date() - 86400 * 30 * 24, userId: 1)

// 에어팟
var airpod = Relationship(nickname: "에어팟", hashtags: ["썸남"], icon: "🎧", startDate: Date() - 86400, userId: 1)
