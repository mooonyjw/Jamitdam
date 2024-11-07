//
//  User.swift
//  Jamitdam
//
//  Created by Jueun Son on 11/5/24.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    
    var id: String { userID } // 구조체를 Idenfiable하기 위한 장치 추가
    var name: String     // 닉네임
    var profile: String
    var userID: String   // 사용자 입력 아이디
    var password: String
    var email: String
    
    var blockedFriends: [User] = [] // 차단된 친구 목록 추가
    
}

var user1 = User(name: "유수현", profile: "UserProfile1", userID: "suhyeonU", password: "suhyeonU11", email: "Shu11@hanyang.ac.kr", blockedFriends: [user2, user3])
var user2 = User(name: "진서기", profile: "UserProfile2", userID: "jinseoki", password: "jinseoki22", email: "Ljs22@hanyang.ac.kr")
var user3 = User(name: "이모리", profile: "UserProfile3", userID: "limory", password: "limory33", email: "Lmr33@hanyang.ac.kr")
var user4 = User(name: "메모리", profile: "UserProfile4", userID: "memory", password: "memory44", email: "Mmr44@hanyang.ac.kr")
var user5 = User(name: "이혜민", profile: "UserProfile5", userID: "hyemin", password: "hyemin55", email: "Lhm55@hanyang.ac.kr")


