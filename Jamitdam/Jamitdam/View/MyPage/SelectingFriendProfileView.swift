import SwiftUI

struct SelectingFriendProfileView: View {
    
    // 뒤로가기 기능 함수
    @Environment(\.dismiss) private var dismiss
    
    // 유수현의 계정
    @State private var user = user1
    // 추가할 친구: 진서기
    
    var inputFriend: User
    
    init(friend: User) {
        self.inputFriend = friend
    }
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    @State private var friend: User = user2
    // Alert 상태 관리 변수
    @State private var showAddFriendAlert = false
    @State private var showUnapprovalAlert = false
    @State private var navigateToFriendProfile = false
    
    // 친구 거절 기능 함수
    func unapprovalFriend() {
        print("친구 거절 버튼 클릭")
        user.deleteRequestedFriend(friend: friend)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                
                VStack {
                    AddFriendCustomBar(widthRatio: widthRatio, heightRatio: heightRatio)
                    
                    // 사용자 프로필
                    Image(friend.profile)
                        .resizable()
                        .frame(width: widthRatio * 110, height: heightRatio * 110)
                        .clipShape(Circle())
                        .padding(.top, 26 * heightRatio)
                    
                    // 사용자 이름
                    Text(friend.name)
                        .font(.system(size: 25 * widthRatio))
                        .fontWeight(.semibold)
                        .padding(.top, 27 * heightRatio)
                    
                    Text(friend.name + "님과 친구를 맺어\n재미를 이어보세요!")
                        .font(.system(size: 20 * widthRatio))
                        .padding(.top, 27 * heightRatio)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Grayunselected"))
                    
                    Spacer()
                    
                    // 친구 추가 버튼
                    RedButton(
                        title: "친구 추가",
                        isEnabled: .constant(true),
                        height: 60 * heightRatio,
                        action: {
                            showAddFriendAlert = true
                            print("showAddFriendAlert 값: \(showAddFriendAlert)") // 값 확인
                        }
                    )
                    // 친구 추가 시 경고창
                    .alert(isPresented: $showAddFriendAlert) {
                        Alert(
                            title: Text("친구 추가"),
                            message: Text("친구 추가를 하시겠습니까?"),
                            primaryButton: .default(Text("확인")) {
                                user.deleteRequestedFriend(friend: friend)
                                user.addFriend(friend: friend)
                                friend.addFriend(friend: user)
                                navigateToFriendProfile = true // 친구 프로필로 이동
                                print("친구 추가 완료 및 프로필 페이지로 이동")
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    
                    
                    Spacer()
                        .frame(height: 30 * heightRatio)
                    
                    
                    // 친구 거절 버튼
                    Button(action: {
                        showUnapprovalAlert = true
                    }) {
                        Text("친구 거절")
                            .font(.system(.title3, weight: .semibold))
                            .padding(.leading)
                            .padding(.trailing)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60 * heightRatio)
                            .background(Color("Grayunselected"))
                            .foregroundColor(Color("Whitebackground"))
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
                    }
                    .padding(.horizontal)
                    // 친구 거절 시 경고창
                    .alert(isPresented: $showUnapprovalAlert) {
                        Alert(
                            title: Text("친구 거절"),
                            message: Text("정말로 친구 요청을 거절하시겠습니까?"),
                            primaryButton: .destructive(Text("확인")) {
                                unapprovalFriend()
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    
                    
                    Spacer()
                        .frame(height: 30 * heightRatio)
                    
                    // 친구 추가 시 친구 프로필로 이동
                    // 친구 프로필 페이지로 이동 추후 구현
//                    NavigationLink(
//                        destination: FriendProfileView(),
//                        isActive: $navigateToFriendProfile
//                    ) {
//                        EmptyView()
//                    }
                }
                .onAppear {
                    friend = inputFriend
                }
                .navigationBarBackButtonHidden(true)
             
            }
        }
    }
}







#Preview {
    SelectingFriendProfileView(friend: user3)
}
