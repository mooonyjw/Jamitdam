//
//  FriendListView.swift
//  Jamitdam
//
//  Created by sojeong on 11/8/24.
//

import SwiftUI
import Foundation

struct FriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 친구 목록
    @State private var friends: [User] = user1.friends
    
    var body: some View {
        VStack(spacing: 0) {
            
            TopBar(
                title: "친구",
                backButtonFunc: { print("뒤로 가기 클릭") }
            )
            
            // 간격 9
            Spacer().frame(height: UIScreen.main.bounds.height * 0.0109)
            
            
            // 친구 목록
            ForEach(friends) { friend in
                FriendRow(friend: friend)
            }
            
            Spacer()
        }
    }
}

struct FriendRow: View {
    var friend: User
    
    var body: some View {
     
        // NavigationLink(destination: FriendProfileView(friend: friend)) {
            HStack {
                
                Spacer().frame(width: UIScreen.main.bounds.height * 0.0213)
                
                // 차단 친구 프로필
                Image(friend.profile)
                    .resizable()
                    .frame(width: 47, height: 47)
                    .clipShape(Circle())
                
                // 이미지와 텍스트 간 간격 21
                Spacer().frame(width: 21)
                
                Text(friend.name)
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                
                Spacer()
                
                
                
                Spacer().frame(width: 21)
                
            }
            .padding(.vertical, 19)
        }
    // }
    
}



#Preview {
    FriendListView()
}
