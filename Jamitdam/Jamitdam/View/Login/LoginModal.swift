//import SwiftUI
//
//struct LoginModal: View {
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var isEnabled: Bool = true
//
//    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
//    let screenWidth: CGFloat = 390
//    let screenHeight: CGFloat = 844
//    @Binding var isLoggedIn: Bool
//
//    var body: some View {
//        GeometryReader { geometry in
//            let heightRatio = geometry.size.height / screenHeight
//
//            ZStack {
//                Color("Whitebackground")
//                
//                VStack {
//                    ScrollView {
//                        VStack(spacing: 20) {
//                            // Logo
//                            Image("Logo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 80, height: 56)
//                                .padding(.top, 30)
//
//                            // Welcome Text
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("안녕하세요 :)")
//                                    .font(.system(size: 25, weight: .bold))
//                                Text("잼잇담입니다.")
//                                    .font(.system(size: 25, weight: .bold))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//
//                            // Text Fields
//                            Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 22) {
//                                GridRow {
//                                    TextField("아이디", text: $username)
//                                        .padding()
//                                        .frame(height: 65)
//                                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
//                                        .gridColumnAlignment(.leading)
//                                }
//                                GridRow {
//                                    SecureField("비밀번호", text: $password)
//                                        .padding()
//                                        .frame(height: 65)
//                                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
//                                        .gridColumnAlignment(.leading)
//                                }
//                            }
//                            .padding(.horizontal)
//
//                            // Additional options
//                            HStack {
//                                Button(action: {
//                                    // 회원가입 액션
//                                }) {
//                                    Text("회원가입")
//                                        .font(.body)
//                                        .foregroundColor(Color.black)
//                                }
//
//                                Circle()
//                                    .fill(Color.gray)
//                                    .frame(width: 3)
//
//                                Button(action: {
//                                    // 아이디 찾기 액션
//                                }) {
//                                    Text("아이디 찾기")
//                                        .font(.body)
//                                        .foregroundColor(Color.black)
//                                }
//
//                                Circle()
//                                    .fill(Color.gray)
//                                    .frame(width: 3)
//
//                                Button(action: {
//                                    // 비밀번호 찾기 액션
//                                }) {
//                                    Text("비밀번호 찾기")
//                                        .font(.body)
//                                        .foregroundColor(Color.black)
//                                }
//                            }
//                            .padding(.bottom, 20)
//                        }
//                    }
//
//                    Spacer()
//
//                    // RedButton fixed at the bottom
//                    RedButton(title: "로그인", isEnabled: $isEnabled, height: 55) {
//                        // 로그인 성공 액션
//                        print("로그인 성공")
//                    }
//                    .padding(.bottom, 70 * heightRatio)
//                }
//            }
//        }
//    }
//}


import SwiftUI

struct LoginModal: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isEnabled: Bool = true
    @Binding var isLoggedIn: Bool

    @State private var navigateToRegister: Bool = false

    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let heightRatio = geometry.size.height / screenHeight

                ZStack {
                    Color("Whitebackground").ignoresSafeArea()

                    VStack {
                        ScrollView {
                            VStack(spacing: 20) {
                                // Logo
                                Image("Logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 56)
                                    .padding(.top, 30)

                                // Welcome Text
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("안녕하세요 :)")
                                        .font(.system(size: 25, weight: .bold))
                                    Text("잼잇담입니다.")
                                        .font(.system(size: 25, weight: .bold))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

                                // Text Fields
                                Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 22) {
                                    GridRow {
                                        TextField("아이디", text: $username)
                                            .padding()
                                            .frame(height: 65)
                                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                            .gridColumnAlignment(.leading)
                                    }
                                    GridRow {
                                        SecureField("비밀번호", text: $password)
                                            .padding()
                                            .frame(height: 65)
                                            .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                            .gridColumnAlignment(.leading)
                                    }
                                }
                                .padding(.horizontal)

                                // Additional options
                                HStack {
                                    Button(action: {
                                        navigateToRegister = true
                                    }) {
                                        Text("회원가입")
                                            .font(.body)
                                            .foregroundColor(Color.black)
                                    }

                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 3)

                                    Button(action: {
                                        // 아이디 찾기 액션
                                    }) {
                                        Text("아이디 찾기")
                                            .font(.body)
                                            .foregroundColor(Color.black)
                                    }

                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 3)

                                    Button(action: {
                                        // 비밀번호 찾기 액션
                                    }) {
                                        Text("비밀번호 찾기")
                                            .font(.body)
                                            .foregroundColor(Color.black)
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                        }

                        Spacer()

                        // RedButton fixed at the bottom
                        RedButton(title: "로그인", isEnabled: $isEnabled, height: 55) {
                            print("로그인 성공")
                            isLoggedIn = true // 로그인 상태 업데이트
                        }
                        .padding(.bottom, 70 * heightRatio)
                    }
                }
                .navigationDestination(isPresented: $navigateToRegister) {
                    Register()
                }
            }
        }
    }
}
