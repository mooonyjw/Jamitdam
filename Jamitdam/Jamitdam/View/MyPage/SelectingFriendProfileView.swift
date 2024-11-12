import SwiftUI


struct SelectingFriendProfileView: View {
    
    // 더미데이터: 진서기
    let user = user2
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    var unapprovalFriend: (() -> Void) = {
        print("친구 거절 버튼 클릭")
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack {
                AddFriendCustomBar(backButtonFunc: {
                    // 전 페이지로 이동 추후 구현
                    print("뒤로 가기 버튼 클릭")
                })
                
                // 사용자 프로필
                Image(user2.profile)
                    .resizable()
                //.scaledToFit()
                    .frame(width: widthRatio * 110, height: heightRatio * 110)
                    .clipShape(Circle())
                    .padding(.top, 26 * heightRatio)
                
                // 사용자 이름
                Text(user2.name)
                    .font(.system(size: 25 * widthRatio))
                    .fontWeight(.semibold)
                    .padding(.top, 27 * heightRatio)
                
                Text(user2.name + "님과 친구를 맺어\n재미를 이어보세요!")
                    .font(.system(size: 20 * widthRatio))
                    .padding(.top, 27 * heightRatio)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Grayunselected"))
                
                Spacer()
                
                RedButton(title: "친구 추가", isEnabled: .constant(true), height: 60 * heightRatio, action: {
                    // 친구 추가 버튼 클릭 시
                    print("친구 추가 버튼 클릭")
                })
                
                Spacer()
                    .frame(height: 30 * heightRatio)
                
                Button(action: unapprovalFriend) {
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
                
                Spacer()
                    .frame(height: 30 * heightRatio)
                
            }
            
        }
    }
}

// 위에 상단바
struct AddFriendCustomBar: View {
    var showBackButton: Bool = true
    var backButtonFunc: (() -> Void)
    
    
    var body: some View {
        HStack {
            Button(action: backButtonFunc) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 21))
                    .padding()
                    .foregroundColor(Color("Graybasic"))
            }
            
            Spacer()
            
            // 오른쪽에 로고 배치
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 28.5)
            // 왼쪽으로부터 간격 27
                .padding(.trailing, 27)
        }
        .padding(.top, 0)
        .frame(height: 57.0)
        
    }
}


#Preview {
    SelectingFriendProfileView()
}
