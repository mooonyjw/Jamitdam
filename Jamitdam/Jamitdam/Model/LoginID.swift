import Foundation
import SwiftUI

struct LoginID: Identifiable {
    
    // 사용자 고유 아이디
    var id: UUID = UUID()
    
    var name: String
    
    // 사용자 입력 아이디
    var userID: String
    
    var password: String
    var email: String
    
}

let dummyLoginID: [LoginID] = [
    LoginID(name: "진서기", userID: "jinseoki", password: "jinseoki22", email: "Ljs22@hanyang.ac.kr"),
    LoginID(name: "진서기", userID: "jinseoki", password: "jinseoki22", email: "Ljs22@hanyang.ac.kr"),
    LoginID(name: "홍길동", userID: "hong123", password: "hong12345", email: "hong@gmail.com"),
    LoginID(name: "김철수", userID: "kimcheol", password: "kim12345", email: "kim@gmail.com")
]
