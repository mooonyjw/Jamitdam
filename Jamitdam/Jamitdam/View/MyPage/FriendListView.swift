import SwiftUI
import Foundation

struct FriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 친구 목록
    @State private var friends: [User] = user1.friends
    @State private var selectedFriend: User = User(name: "", profile: "", userID: "", password: "", email: "")
    // 친구 프로필로 이동
    @State private var navigateToProfile: Bool = false
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "친구",
                    backButtonFunc: { print("뒤로 가기 클릭") }
                )
                
                Spacer().frame(height: 9 * heightRatio)
                
                ForEach(friends) { friend in
                    FriendRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio)
                    // 친구 행 클릭 시 친구 프로필로 이동
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 추후 친구 프로필로 이동 기능 구현
                        selectedFriend = friend
                        navigateToProfile = true
                        print("\(selectedFriend.name) 프로필 페이지로 이동")
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct FriendRow: View {
    var friend: User
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var body: some View {
        HStack {
            
            Spacer().frame(width: 18 * widthRatio)
            
            Image(friend.profile)
                .resizable()
                .frame(width: 47 * widthRatio, height: 47 * widthRatio)
                .clipShape(Circle())
            
            Spacer().frame(width: 21 * widthRatio)
            
            Text(friend.name)
                .font(.system(size: 20 * widthRatio))
                .foregroundColor(Color.black)
            
            Spacer()
            
        }
        .padding(.vertical, 19 * heightRatio)
    }
}

#Preview {
    FriendListView()
}
