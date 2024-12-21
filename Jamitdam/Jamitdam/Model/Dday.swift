
import Foundation
import SwiftUI

// navigation에서 입력 값 넣어줄 때
// 두 개 이상의 데이터 한번에 넣어주기 위해서 구조체로 작성
struct DdayData: Hashable {
    var relationship: Relationship
    var date: Date
    let id: UUID = UUID()
    let userID: UUID
    
    // 얼마나 지났는지 날짜 계산
    var daysSinceStart: Int {
         let calendar = Calendar.current
         // 시간제거
         let startOfStartDate = calendar.startOfDay(for: date)
         let startOfToday = calendar.startOfDay(for: Date())
         return max(-1, Calendar.current.dateComponents([.day], from: startOfStartDate, to: startOfToday).day ?? 0)
     }
     
    
    
}

var dday1 = DdayData(relationship: tiger, date: Date() - 86400 * 100, userID: user1.id)
var dday2 = DdayData(relationship: podong, date: Date() - 86400 * 50, userID: user2.id)
var dday3 = DdayData(relationship: gamer, date: Date() - 86400 * 200, userID: user3.id)
var dday4 = DdayData(relationship: baeksook, date: Date() - 86400 * 30, userID: user4.id)
var dday5 = DdayData(relationship: son , date: Date() - 86400*365, userID: user5.id)

var selectedDataList: [DdayData] = [dday1, dday2, dday3, dday4, dday5]

class DdayDataStore: ObservableObject {
    @Published var DdayDataList: [DdayData] = []
    
    init() {
        self.DdayDataList = [dday1, dday2, dday3, dday4, dday5]
        
        
    }
    func addDdayData(_ DdayData : DdayData) {
        DdayDataList.append(DdayData)
        
    }
    func deleteDdayDate(_ DdayData: DdayData) {
        DdayDataList.removeAll { $0.id == DdayData.id}
    }
    
    func updateDdayData(id: UUID, newRelationship: Relationship, newDate: Date) {
        if let index = DdayDataList.firstIndex(where: {$0.id == id}) {
            DdayDataList[index].relationship = newRelationship
            DdayDataList[index].date = newDate
            
        }
        
    }
}

