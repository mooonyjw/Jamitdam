import SwiftUI

// 작성 시간 차이를 계산하여 문자열 반환하는 함수
/*
 
 작성 시간과 현재 시간 차이가
 1분 미만인 경우: 방금 전
 1시간 미만인 경우: @@분 전
 1시간 초과, 하루 미만인 경우: @@시간 전
 하루 초과인 경우: @@일 전
 
 */
private func timeAgoSinceDate(_ date: Date) -> String {
    let currentDate = Date()
    let difference = currentDate.timeIntervalSince(date)
    
    let secondsInMinute: Double = 60
    let secondsInHour: Double = 60 * 60
    let secondsInDay: Double = 60 * 60 * 24
    
    if difference < secondsInMinute {
        return "방금 전"
    }
    else if difference < secondsInHour {
        let  minutes = Int(difference / secondsInMinute)
        return "\(minutes)분 전"
    }
    else if difference < secondsInDay {
        let hours = Int(difference / secondsInHour)
        return "\(hours)시간 전"
    }
    else {
        let days = Int(difference / secondsInDay)
        return "\(days)일 전"
    }
}
