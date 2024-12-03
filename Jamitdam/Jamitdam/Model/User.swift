import Foundation
import SwiftUI

struct User: Identifiable {
    
    // 사용자 고유 아이디
    var id: UUID = UUID()
    
    var name: String
    var profile: String
    
    // 사용자 입력 아이디
    var userID: String
    
    var password: String
    var email: String
    var blockedFriends: [User] = []
    var friends: [User] = []
    var requestedFriends: [User] = []

    // 친구 추가
    mutating func addFriend(friend: User) {
        friends.append(friend)
    }
    
    // 친구 삭제
    mutating func deleteFriend(friend: User) {
        friends.removeAll { $0.id == friend.id }
    }
    
    // 차단 친구 추가
    mutating func blockFriend(friend: User) {
        blockedFriends.append(friend)
    }
    
    // 차단 친구 해제
    mutating func unblockFriend(friend: User) {
        blockedFriends.removeAll { $0.id == friend.id }
    }
    
    // 요청 온 친구 추가
    mutating func addRequestedFriend(friend: User) {
        requestedFriends.append(friend)
    }
    
    // 요청 온 친구 삭제
    mutating func deleteRequestedFriend(friend: User) {
        requestedFriends.removeAll { $0.id == friend.id }
    }
}


var user2 = User(name: "진서기", profile: "UserProfile2", userID: "jinseoki", password: "jinseoki22", email: "Ljs22@hanyang.ac.kr")
var user3 = User(name: "이모리", profile: "UserProfile3", userID: "limory", password: "limory33", email: "Lmr33@hanyang.ac.kr")
var user4 = User(name: "메모리", profile: "UserProfile4", userID: "memory", password: "memory44", email: "Mmr44@hanyang.ac.kr")
var user5 = User(name: "이혜민이올시다!", profile: "UserProfile5", userID: "hyemin", password: "hyemin55", email: "Lhm55@hanyang.ac.kr")


var user1 = User(name: "유수현", profile: "UserProfile1", userID: "suhyeonU", password: "suhyeonU11", email: "Shu11@hanyang.ac.kr", blockedFriends: [user2, user3], friends: [user2, user5])

var users: [User] = [user1, user2, user3, user4, user5]
