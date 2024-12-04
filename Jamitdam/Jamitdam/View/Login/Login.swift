import SwiftUI

struct Login: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isEnabled: Bool = true
    @StateObject private var navigationState = NavigationState()

    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let heightRatio = geometry.size.height / screenHeight

                ZStack {
                    Color("Whitebackground")
                    
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
                                //.padding(.top, 60)
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
                                    NavigationLink(destination: Register()) {
                                        Text("회원가입")
                                            .font(.body)
                                            .foregroundColor(Color.black)
                                    }

                                    
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 3)
                                    
//                                    Button("아이디 찾기") {
//                                        navigationState.navigateToSearchID = true
//                                    }
//                                    .font(.body)
//                                    .foregroundColor(.black)
//                                    
                                    NavigationLink(destination: SearchID()) {
                                        Text("아이디 찾기")
                                            .font(.body)
                                            .foregroundColor(Color.black)

                                    }
                                    
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 3)
                                    
//                                    Button("비밀번호 찾기") {
//                                        navigationState.navigateToSearchPW = true
//                                    }
//                                    .font(.body)
//                                    .foregroundColor(.black)
                                    
                                    NavigationLink(destination: SearchPW()) {
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
                            navigationState.navigateToHome = true
                        }
                        
//                        NavigationLink(destination: Register()) {
//                            Text("회원가입")
//                                .font(.body)
//                                .foregroundColor(Color.black)
//                        }
                        .padding(.bottom, 70 * heightRatio)
                    }
                }
            }
            .navigationDestination(isPresented: $navigationState.navigateToHome) {
                HomeView()
            }
            .toolbar {
                // Hide the back button
                ToolbarItem(placement: .navigationBarLeading) {
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden(true) // Remove the default back button
        }
    }
}

struct LoginList<Destination: View>: View {
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var title: String
    var titleColor: Color = Color.black
    var titleButton: Bool = false
    
    // 오른쪽 버튼
    var button: String?
    var destination: Destination
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 26 * widthRatio)
            
            // 튜토리얼 보기, 로그아웃, 탈퇴하기는 글자 자체가 버튼임
            if titleButton {
                Button(action: {
                    print("버튼 클릭")
                }) {
                    Text(title)
                        .font(.system(size: 18 * widthRatio))
                        .foregroundColor(titleColor)
                }
            } else {
                Text(title)
                    .font(.system(size: 18 * widthRatio))
                    .foregroundColor(titleColor)
            }
            
            Spacer()
            
            if let button = button {
                NavigationLink(destination: destination) {
                    Image(systemName: button)
                        .font(.system(size: 21 * widthRatio))
                        .foregroundColor(Color("Graybasic"))
                }
            }
            
            Spacer()
                .frame(width: 19 * widthRatio)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 57 * heightRatio)
    }
}
#Preview {
    Login()
}
