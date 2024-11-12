import SwiftUI

struct Login: View {
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
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
                //.padding(.bottom, geometry.size.height * 0.02)
                
                // Text Fields
                VStack(spacing: geometry.size.height * 0.015) {
                    TextField("아이디", text: $username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal, geometry.size.width * 0.05)
                    
                    SecureField("비밀번호", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal, geometry.size.width * 0.05)
                }
                
                // Links
                HStack {
                    Text("회원가입")
                    Text("아이디 찾기")
                    Text("비밀번호 찾기")
                }
                .font(.system(size: geometry.size.width * 0.035))
                .foregroundColor(.gray)
                .padding(.top, geometry.size.height * 0.01)
                
                Spacer()
                
                // Login Button
                Button(action: {
                    // Action for login
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .font(.system(size: geometry.size.width * 0.045, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                        .padding(.horizontal, geometry.size.width * 0.05)
                }
                .padding(.bottom, geometry.size.height * 0.05)
                
                Spacer()
            }
            .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Login()
}
