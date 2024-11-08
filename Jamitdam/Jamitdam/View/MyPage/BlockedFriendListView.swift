//
//  BlockedFriendListView.swift
//  Jamitdam
//
//  Created by sojeong on 11/7/24.
//

import SwiftUI
import Foundation

struct BlockedFriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 차단 친구 목록
    @State private var blockedFriends: [User] = user1.blockedFriends
    @State private var showingAlert = false
    @State private var selectedFriend: User = User(name: "", profile: "", userID: "", password: "", email: "")
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "차단된 친구",
                    backButtonFunc: { print("뒤로 가기 클릭") }
                )
                
                // 간격 9
                Spacer().frame(height: 9 * heightRatio)
                
                
                // 차단된 친구 목록
                ForEach(blockedFriends) { friend in
                    BlockedFriendRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio) {
                        // 차단 해제 버튼 클릭 시
                        showingAlert = true
                        selectedFriend = friend
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("삭제하시겠습니까?"),
                        message: Text("이 친구를 차단 해제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            removeFriendFromBlockedList(selectedFriend)
                        },
                        secondaryButton: .cancel(Text("취소"))
                        
                    )
                }
                
                Spacer()
            }
        }
    }
    
    // 인자로 받은 친구를 유저의 차단 목록에서 제거하는 함수
    private func removeFriendFromBlockedList(_ friend: User) {
        blockedFriends.removeAll { $0.id == friend.id }
    }
}

struct BlockedFriendRow: View {
    var friend: User
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    // 차단 해제 기능 추후 구현
    var unblockAction: () -> Void

    var body: some View {
        // hstack을 하나의 프레임에
        
        HStack {
            
            Spacer().frame(width: widthRatio * 18)
            
            // 차단 친구 프로필
            Image(friend.profile)
                .resizable()
                .frame(width: widthRatio * 47, height: heightRatio * 47)
                .clipShape(Circle())
            
            // 이미지와 텍스트 간 간격 21
            Spacer().frame(width: widthRatio * 21)
            
            Text(friend.name)
                .font(.system(size: widthRatio * 20))
                .foregroundColor(Color.black)
            
            Spacer()
            
            Button(action: unblockAction) {
                Text("차단 해제")
                    .font(.system(size: widthRatio * 16))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical, heightRatio * 6)
                    .padding(.horizontal, widthRatio * 12)
                    .background(Color("Redemphasis2"))
                    .cornerRadius(13)
            }
            
            Spacer().frame(width: widthRatio * 21)
            
        }
        .padding(.vertical, heightRatio * 19)
    }
    
}



#Preview {
    BlockedFriendListView()
}
