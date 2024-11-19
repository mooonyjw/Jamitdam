import SwiftUI
import Foundation

struct BlockedFriendListView: View {
    
    // 더미 데이터 - 유수현(user1)의 차단 친구 목록
    @State private var user = user1
    @State private var blockedFriends: [User] = []
    
    // 차단 해제 시 .alert 표시 여부
    @State private var showingAlert = false
    @State private var selectedFriend: User?
    
    // 친구 프로필로 이동 여부
    @State private var navigateToProfile: Bool = false
    
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "차단된 친구",
                    rightButtonDisabled: true
                )
                ScrollView {
          
                    Spacer().frame(height: 9 * heightRatio)
                    
                    // 차단된 친구 목록
                    ForEach(blockedFriends) { friend in
                        BlockedFriendRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio) {
                            // 차단 해제 버튼 클릭 시 .alert 표시
                            showingAlert = true
                            selectedFriend = friend
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // 추후 친구 프로필로 이동 기능 구현
                            selectedFriend = friend
                            navigateToProfile = true
                            print("\(selectedFriend!.name) 프로필 페이지로 이동")
                        }
                    }
//                    .alert(isPresented: $showingAlert) {
//                        Alert(
//                            title: Text("차단 해제하시겠습니까?"),
//                            message: Text("\(selectedFriend!.name)님을 차단 해제하시겠습니까?"),
//                            primaryButton: .destructive(Text("해제")) {
//                                user.unblockFriend(friend: selectedFriend!)
//                            },
//                            secondaryButton: .cancel(Text("취소"))
//                        )
//                    }
                    .actionSheet(isPresented: $showingAlert) {
                      ActionSheet(
                          title: Text("차단 해제 하시겠습니까?"),
                          buttons: [
                              .default(Text("차단 해제")) {
                                  print("차단 해제 선택됨")
                                  user.unblockFriend(friend: selectedFriend!)
                                  blockedFriends = user.blockedFriends
                              },
                              .default(Text("친구 추가")) {
                                  print("친구 추가 선택됨")
                                  user.unblockFriend(friend: selectedFriend!)
                                  user.addFriend(friend: selectedFriend!)
                                  blockedFriends = user.blockedFriends
                              },
                              .cancel(Text("취소"))
                          ]
                      )
                  }
                }
            }
            .onAppear {
                blockedFriends = user.blockedFriends
            }
        }        
    }
}




// 차단된 친구 목록의 각 행
struct BlockedFriendRow: View {
    
    var friend: User
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
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
            
            // 이미지와 텍스트 간 간격
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
            
            Spacer().frame(width: widthRatio * 18)
            
        }
        .padding(.vertical, heightRatio * 14)
    }
    
}



#Preview {
    BlockedFriendListView()
}
