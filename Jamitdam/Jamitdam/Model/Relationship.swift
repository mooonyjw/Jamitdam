import SwiftUI

struct Relationship {
    var nickname: String
    var hashtags: [String]
    var icon: String
    let startDate: Date
    let userId: UUID
}

// 유수현 인연을 기준으로 더미데이터 작성
// 유수현의 id
let id = UUID()

var tiger = Relationship(nickname: "호랭이", hashtags: ["전남친", "동아리선배"], icon: "🐯", startDate: Date() - 86400 * 30 * 12, userId: id)
var podong = Relationship(nickname: "포동이", hashtags: ["전썸남", "미팅"], icon: "🐻‍❄️", startDate: Date() - 86400 * 30 * 3, userId: id)
var gamer = Relationship(nickname: "게임중독자", hashtags: ["전썸남"], icon: "🧑🏻‍💻", startDate: Date() - 86400 * 30 * 5, userId: id)
var baeksook = Relationship(nickname: "능이백숙", hashtags: ["치근덕"], icon: "🕶️", startDate: Date() - 86400 * 30, userId: id)
var son = Relationship(nickname: "SON", hashtags: ["전남친", "과CC"], icon: "⚽️", startDate: Date() - 86400 * 30 * 24, userId: id)
var airpod = Relationship(nickname: "에어팟", hashtags: ["썸남"], icon: "🎧", startDate: Date() - 86400, userId: id)

var relationships: Relationship[] = [tiger, podong, gamer, baeksook, son]

func getRelationships = () -> Relationship[] {
    return relationships
}

func addRelationship = (relationship: Relationship) {
    relationships.append(relationship)
}
