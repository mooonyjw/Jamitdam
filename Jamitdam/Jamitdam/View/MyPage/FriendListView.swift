import SwiftUI
import Foundation

struct FriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 친구 목록
    @State var user: User = user1
    
    @State private var friends: [User]
    @State private var selectedFriend: User?
    // 친구 프로필로 이동
    @State private var navigateToProfile: Bool = false
    
    init(user: User) {
        self.user = user
        // 친구 목록을 불러올 때 사용자의 친구 목록을 불러옴
        friends = user.friends
    }
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        //NavigationStack {
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                
                VStack(spacing: 0) {
                    
                    TopBar(
                        title: "친구",
                        rightButtonDisabled: true
                    )
                    
                    ScrollView {
                        Spacer().frame(height: 9 * heightRatio)
                        
                        ForEach(friends) { friend in
                            FriendRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio)
                            // 친구 행 클릭 시 친구 프로필로 이동
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    // 추후 친구 프로필로 이동 기능 구현
                                    selectedFriend = friend
                                    navigateToProfile = true
                                    print("\(selectedFriend!.name) 프로필 페이지로 이동")
                                }
                        }
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
            }
            
            NavigationLink(
                destination: FriendProfileView(
                    user: selectedFriend ?? user.friends[0]
                ),
                isActive: $navigateToProfile
            ) {
                EmptyView()
            }
        //}

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
        .padding(.vertical, 14 * heightRatio)
    }
}

#Preview {
    FriendListView(user: user1)
}
