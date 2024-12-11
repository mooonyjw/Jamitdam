import SwiftUI
import Combine

// DayPlus Navigation에서 필요해서 수정
struct Relationship: Identifiable, Hashable, Equatable {
    let id: UUID = UUID()
    var nickname: String
    var hashtags: String
    var icon: String
    let startDate: Date
    let userId: UUID
}

// 유수현 인연을 기준으로 더미데이터 작성
var tiger = Relationship(nickname: "호랭이", hashtags: "동아리선배", icon: "🐯", startDate: Date() - 86400 * 30 * 12, userId: user1.id)
var podong = Relationship(nickname: "포동이", hashtags: "미팅", icon: "🐻‍❄️", startDate: Date() - 86400 * 30 * 3, userId: user1.id)
var gamer = Relationship(nickname: "게임중독자", hashtags: "전썸남", icon: "🧑🏻‍💻", startDate: Date() - 86400 * 30 * 5, userId: user1.id)
var baeksook = Relationship(nickname: "능이백숙", hashtags: "치근덕", icon: "🕶️", startDate: Date() - 86400 * 30, userId: user1.id)
var son = Relationship(nickname: "SON", hashtags: "과CC", icon: "⚽️", startDate: Date() - 86400 * 30 * 24, userId: user1.id)
var airpod = Relationship(nickname: "에어팟", hashtags: "썸남", icon: "🎧", startDate: Date() - 86400, userId: user1.id)

var relationships: [Relationship] = [tiger, podong, gamer, baeksook, son]

func getRelationships() -> [Relationship] {
    return relationships
}

func addRelationship(relationship: Relationship) {
    relationships.append(relationship)
}

class RelationshipStore: ObservableObject {
    @Published var relationships: [Relationship]
    init() {
        // 초기 더미 데이터로 relationships를 초기화
        self.relationships = [tiger, podong, gamer, baeksook, son]
    }
    
    func addRelationship(_ relationship: Relationship) {
        relationships.append(relationship)
    }
    
    func deleteRelationship(_ relationship: Relationship) {
        relationships.removeAll { $0.id == relationship.id }
    }
}


