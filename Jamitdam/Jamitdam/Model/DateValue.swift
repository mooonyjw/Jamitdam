import Foundation
import SwiftUI

// Date Value Model
struct DateValue: Identifiable{
    var id = UUID()
    var day: Int
    var date: Date
}

// Calendar Model
struct CalendarData {
    // 사용자 ID만 저장
    let userID: UUID
    // 현재 날짜
    var currentDate: Date
    // 전월, 명월 표시하기 위한 오프셋
    var currentMonthOffset: Int = 0
    // 캘린더 객체
    var calendar: Calendar = Calendar.current
    // 날짜별 포스트 딕셔너리
    private(set) var posts: [Date: [Post]]
    
    init(UserID: UUID, currentDate: Date, posts: [Post]) {
        self.userID = UserID
        self.currentDate = currentDate
        self.posts = Dictionary(grouping: posts, by: { post in
            Calendar.current.startOfDay(for: post.timestamp)
        })
    }
    // 현재 월의 첫 번째 날짜 가져오기
    func getCurrentMonth() -> Date {
        return calendar.date(byAdding: .month, value: currentMonthOffset, to: currentDate) ?? currentDate
    }
    
    // getAllDates() 결과 앞에 필요한 빈 칸을 포함한 날짜 배열 반환
    func extractDate() -> [DateValue] {
        
        // 현재 month
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap{date -> DateValue in
            // getting day
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get extra week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
   
    
}



// 현재 달의 모든 날짜 가져오기
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day-1, to: startDate)!
        }
    }
}


extension CalendarData {
    // 날짜 관련 함수
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func formattedDate(from date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    // 년, 월, 일 추출
    func extractYearMonthDaty(from date: Date) -> (year: String, month: String, date:String) {
        let year = formattedDate(from: date, format: "yyyy년")
        let month = formattedDate(from: date, format: "MM월")
        let day = formattedDate(from: date, format: "dd일")
        return (year, month, day)
    }
}


extension CalendarData {
    // 포스트 관련 함수
    func hasPost(for date: Date, from posts: [Post]) -> Bool{
        posts.contains { post in
            isSameDay(date1: post.timestamp, date2: date) && post.author.id == userID
        }
    }

}
var dummyCalendars: [CalendarData] = [
    CalendarData(UserID: user1.id, currentDate: Date(), posts: getPosts(for: user1, from: dummyPosts)),
    CalendarData(UserID: user2.id, currentDate: Date(), posts: getPosts(for: user2, from: dummyPosts)),

]

func getCalendar(for user: User, from calendars: [CalendarData]) -> CalendarData {
   
    return calendars.first {$0.userID == user.id} ?? CalendarData(UserID: user.id, currentDate: Date(), posts: getPosts(for: user, from: dummyPosts))
}
func addCalendar(calendar: CalendarData) {
    dummyCalendars.append(calendar)
}

//func deleteCalendar(calendar: CalendarData) {
//    dummyCalendars.removeAll { $0.userID == user.id }
//}

