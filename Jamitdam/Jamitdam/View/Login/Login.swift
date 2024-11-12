import SwiftUI

struct Login: View {
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 해당 화면에서는 항상 true로 유지된다.
    @State private var isEnabled: Bool = true
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @State private var navigateToHome = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @State private var navigateToRegister = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @State private var navigateToSearchID = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @State private var navigateToSearchPW = false
    @State private var path: [String] = []
    
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    var body: some View {
        NavigationStack(path: $path){
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                
                ZStack{
                    
                    Color("Whitebackground")
                    
                    VStack {
                        
                        // Logo
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80 * widthRatio, height: 56 * heightRatio)
                            .padding(.top, heightRatio * 30)
                        
                        // Welcome Text
                        VStack(alignment: .leading, spacing: 10 * heightRatio) {
                            Text("안녕하세요 :)")
                                .font(.system(size: 25 * widthRatio, weight: .bold))
                            Text("잼잇담입니다.")
                                .font(.system(size: 25 * widthRatio, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, widthRatio * 20)
                        .padding(.top, heightRatio * 60)
                        .padding(.bottom, heightRatio * 22)
                        
                        // Text Fields
                        VStack(spacing: heightRatio * 22) {
                            TextField("아이디", text: $username)
                                .padding()
                                .frame(height: heightRatio * 65)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                .padding(.horizontal, widthRatio * 20)
                            
                            SecureField("비밀번호", text: $password)
                                .padding()
                                .frame(height: heightRatio * 65)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                .padding(.horizontal, widthRatio * 20)
                        }
                        
                        // 로그인 부수 기능 추가
                        HStack {
                            Button(action: {
                                path.append("Register")
                                navigateToRegister = true
                            }, label: {
                                Text("회원가입")
                                    .font(.body)
                                    .foregroundColor(.black)
                            })
                            Circle()
                                .fill(Color.gray)
                                .frame(width: heightRatio * 3)
                            Button(action: {
                                path.append("SearchID")
                                navigateToSearchID = true
                            }, label: {
                                Text("아이디 찾기")
                                    .foregroundColor(.black)
                                    .font(.body)
                            })
                            Circle()
                                .fill(Color.gray)
                                .frame(width: heightRatio * 3)
                            Button(action: {
                                path.append("SearchPW")
                                navigateToSearchPW = true
                            }, label: {
                                Text("비밀번호 찾기")
                                    .foregroundColor(.black)
                                    .font(.body)
                            })
                        }
                        .padding(.top, heightRatio * 15)
                        
                        Spacer()
                        Spacer()
                        
                        // Login Button
                        RedButton(title: "로그인", isEnabled: $isEnabled, height: 55) {
                            navigateToHome = true
                            path.append("Home")
                        }
                        .padding(.bottom, 70 * heightRatio)
                    }
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
                    .navigationBarHidden(true)
                }
            }
            .navigationDestination(for: String.self) { value in
                // String 값에 따라 이동할 화면 설정
                switch value {
                    case "Register":
                        Register()
                    case "SearchID":
                        SearchID()
                    case "SearchPW":
                        SearchPW()
                    case "Home":
                        SearchPW()
                        //Home()
                    default:
                        EmptyView()
                }
                
                //            .navigationDestination(isPresented: $navigateToHome){
                //                //Home()
                //            }
                //            .navigationDestination(isPresented: $navigateToRegister){
                //                Register()
                //            }
                //            .navigationDestination(isPresented: $navigateToSearchID){
                //                SearchID()
                //            }
                //            .navigationDestination(isPresented: $navigateToSearchPW){
                //                SearchPW()
                //            }
            }
        }
    }
}

#Preview {
    Login()
}
