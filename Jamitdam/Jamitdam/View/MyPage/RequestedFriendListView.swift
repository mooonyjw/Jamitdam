import SwiftUI
import Foundation

struct RequestedFriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 요청 온 친구 목록
    @State private var user = user1
    @State private var requestedFriends: [User] = []
    @State private var showingAlert = false
    @State private var selectedFriend: User?
    @State private var navigateToProfile: Bool = false
    
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    
    var body: some View {
        //NavigationStack {
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                
                VStack(spacing: 0) {
                    
                    TopBar(
                        title: "친구 요청",
                        rightButtonDisabled: true
                    )
                    
                    ScrollView {
                        // 간격 9
                        Spacer().frame(height: 9 * heightRatio)
                        
                        // 차단된 친구 목록
                        ForEach(requestedFriends) { friend in
                            RequestedFriendRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio) {
                                // 추가 버튼 클릭 시 .alert 표시
                                showingAlert = true
                                selectedFriend = friend
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // 추후 친구 수락/거절 페이지로 이동 기능 구현
                                selectedFriend = friend
                                navigateToProfile = true
                                print("\(selectedFriend!.name) 수락/거절 페이지로 이동")
                            }
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("친구 추가하시겠습니까?"),
                                message: Text("\(selectedFriend!.name)님을 친구 추가하시겠습니까?"),
                                primaryButton: .destructive(Text("추가")) {
                                    user.addFriend(friend: selectedFriend!)
                                    user.deleteRequestedFriend(friend: selectedFriend!)
                                    
                                    selectedFriend!.addFriend(friend: user)
                                    requestedFriends = user.requestedFriends
                                    
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }
                    
                }
                .onAppear {
                    requestedFriends = user.requestedFriends
                }
                .navigationBarBackButtonHidden(true) 
            }
            NavigationLink(
                destination: SelectingFriendProfileView(
                    friend: selectedFriend ?? user.friends[0]
                ),
                isActive: $navigateToProfile
            ) {
                EmptyView()
            }
        //}
    }
}




// 요청 온 친구 목록의 각 행
struct RequestedFriendRow: View {
    
    var friend: User
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var addAction: () -> Void

    var body: some View {
        
        HStack {
            
            Spacer().frame(width: widthRatio * 18)
            
            // 친구 프로필
            Image(friend.profile)
                .resizable()
                .frame(width: widthRatio * 47, height: heightRatio * 47)
                .clipShape(Circle())
            
            // 이미지와 텍스트 간 간격
            Spacer().frame(width: widthRatio * 21)
            
            Text(friend.name)
                .font(.system(size: widthRatio * 20))
                .foregroundColor(Color.black)
            
            Spacer()
            
            Button(action: addAction) {
                Text("추가")
                    .font(.system(size: widthRatio * 16))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.vertical, heightRatio * 6)
                    .padding(.horizontal, widthRatio * 12)
                    .background(Color("Redemphasis2"))
                    .cornerRadius(13)
            }
            
            Spacer().frame(width: widthRatio * 18)
            
        }
        .padding(.vertical, heightRatio * 14)
    }
    
}



#Preview {
    RequestedFriendListView()
}

