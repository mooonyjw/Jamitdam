
// 하단의 다음 버튼을 활성화시키기 위한 boolean
// 닉네임이 입력되면 true가 된다.

import SwiftUI

struct RegisterNickname: View {
    @State private var nickname: String = ""
    @State private var isEnabled: Bool = false
    @State private var showAlert: Bool = false // Alert 표시 상태
    @Environment(\.dismiss) private var dismiss // 뷰 닫기 기능
    @StateObject private var navigationState = NavigationState()

    @State private var navigateToLogin: Bool = false // 로그인 화면 이동 상태

    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844

    var body: some View {
        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            let widthRatio = geometry.size.width / screenWidth

            VStack {
                // Back Button
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

                        // Nickname Input Field
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("Grayunselected"), lineWidth: 1)
                                    .frame(height: 65)

                                TextField("닉네임", text: $nickname)
                                    .onChange(of: nickname) { newValue in
                                        let trimmedValue = newValue.filter { !$0.isWhitespace }
                                        if trimmedValue.count > 8 {
                                            nickname = String(trimmedValue.prefix(8))
                                        } else {
                                            nickname = trimmedValue
                                        }
                                        isEnabled = !nickname.isEmpty
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 15)
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                }

                Spacer()

                // 회원가입 버튼
                NavigationLink(destination: Login()) {
                    RedButton(title: "회원가입", isEnabled: .constant(isEnabled), height: 55) {
                        // Alert 띄우고 로그인 페이지로 이동
                        showAlert = true
                    }
                    .disabled(!isEnabled)
                }
                .padding(.bottom, 70 * heightRatio)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("회원가입 완료"),
                        message: Text("회원가입이 완료되었습니다."),
                        dismissButton: .default(Text("확인")) {
                            dismiss()
                            dismiss()
                        }
                    )
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterNickname()
}
