import SwiftUI

struct AddFriendProfileView: View {
    
    // 뒤로 가기 기능
    @Environment(\.dismiss) private var dismiss
    // 유수현의 계정
    @State private var user = user1
    // 추가할 친구: 진서기
    @State private var friend = user2
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    // 버튼과 알림 상태를 관리하는 상태 변수
    @State private var showAlert = false
    @State private var isRequestSent = false
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack {
                AddFriendCustomBar(backButtonFunc: {
                    dismiss()
                    print("뒤로 가기 버튼 클릭")
                }, widthRatio: widthRatio, heightRatio: heightRatio)
                
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
                
                // 친구 요청 버튼
                RedButton(
                    title: isRequestSent ? "요청 완료" : "친구 요청",
                    isEnabled: .constant(!isRequestSent),
                    height: 60 * heightRatio,
                    action: {
                        showAlert = true
                    }
                )
                // 요청 후 비활성화
                .disabled(isRequestSent)
                
                Spacer()
                    .frame(height: 30 * heightRatio)
                
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("친구 요청"),
                    message: Text(friend.name+"님에게 친구 요청을 하시겠습니까?"),
                    primaryButton: .default(Text("확인")) {
                        // 버튼 비활성화 및 문구 변경
                        isRequestSent = true
                        friend.addRequestedFriend(friend: user)
                        print("친구 요청 버튼 클릭")
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
            .navigationBarBackButtonHidden(true) 
        }
    }
}

#Preview {
    AddFriendProfileView()
}
