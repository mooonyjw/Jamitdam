import SwiftUI


struct RegisterNickname: View {
    
    @State private var nickname: String = ""
    
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 닉네임이 입력되면 true가 된다.
    @State private var isEnabled: Bool = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var navigationState = NavigationState()

    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844


    var body: some View {
        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            let widthRatio = geometry.size.width / screenWidth
            
            VStack {
                //TopBar(title: "")
                BackButton(widthRatio: widthRatio, heightRatio: heightRatio)
                    .frame(height: 57)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Text
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회원가입")
                                .font(.system(size: 25, weight: .bold))
                            Text("닉네임 *")
                                .font(.body)
                            Text("잼잇담에서 사용할 닉네임을 입력해 주세요.")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        
                        VStack(spacing: 20) {
                            ZStack {
                                // RoundedRectangle으로 박스 그리기
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("Grayunselected"), lineWidth: 1)
                                    .frame(height: 65)
                                
                                // TextField 배치
                                TextField("닉네임", text: $nickname)
                                    .onChange(of: nickname) { newValue in
                                        // 공백 제거 및 8자 제한
                                        let trimmedValue = newValue.filter { !$0.isWhitespace }
                                        if trimmedValue.count > 8 {
                                            nickname = String(trimmedValue.prefix(8))
                                        } else {
                                            nickname = trimmedValue
                                        }
                                        // 다음 버튼 활성화 여부 갱신
                                        isEnabled = !nickname.isEmpty
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 15)
                            }
                            // ZStack 내부 여백
                            .padding(.horizontal, 15)
                        }
                    }
                }
                
                Spacer()
                NavigationLink(
                    destination: RegisterNickname(),
                    isActive: $navigationState.navigateToNickname
                ) {
                    RedButton(title: "회원가입", isEnabled: .constant(isEnabled), height: 55) {
                        // Navigation 활성화
                        navigationState.navigateToLogin = true
                    }
                    .disabled(!isEnabled)
                }
                .padding(.bottom, 70 * heightRatio)
                
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    RegisterNickname()
}
