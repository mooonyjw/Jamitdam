import SwiftUI

struct Register: View {
    @State private var email: String = ""
    @State private var isEnabled: Bool = false
    @State private var verificationCode: String = ""
    @State private var isCodeSent = false
    @State private var isTimerActive = false
    @State private var limitTime: Int = 300
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isIDDuplicated = false



    @Environment(\.dismiss) private var dismiss
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var isEmailValid: Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: email)
    }

    // 아이디 유효성 검사 함수
    var isIDValid: Bool {
        // 4~12자 영문 대소문자 및 숫자
        let IDPattern = "^[a-zA-Z0-9]{4,12}$"
        
        return NSPredicate(format: "SELF MATCHES %@", IDPattern).evaluate(with: username)
    }

    var isCodeValid: Bool {
        let codePattern = "[0-9]{6}"
        return NSPredicate(format: "SELF MATCHES %@", codePattern).evaluate(with: verificationCode)
    }

    func convertSecToTime(sec: Int) -> String {
        let min = sec / 60
        let sec = sec % 60
        return String(format: "%02d:%02d", min, sec)
    }

    // 아이디 중복 확인 함수
    func checkUsernameDuplicate() {
        // 먼저 유효성 검사
        if isIDValid{
            isIDDuplicated = dummyLoginID.contains { $0.userID == username }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            let widthRatio = geometry.size.width / screenWidth

            VStack {
                // Custom Navigation Bar 사용
                AddFriendCustomBar(
                    backButtonFunc: {
                        dismiss() // 뒤로가기 액션
                    },
                    widthRatio: widthRatio,
                    heightRatio: heightRatio
                )
                .padding(.top)
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Text
                        VStack(alignment: .leading, spacing: 10) {
                            Text("회원가입")
                                .font(.system(size: 25, weight: .bold))
                            Text("이메일 주소 *")
                                .font(.body)
                            Text("인증을 위해 이메일 주소를 입력해주세요.")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                        
                        VStack(spacing: 20) {
                            ZStack {
                                TextField("이메일", text: $email)
                                    .padding()
                                    .frame(height: 65)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))

                                Button(action: {
                                    isCodeSent = true
                                    isTimerActive = true
                                    limitTime = 300
                                }) {
                                    Text(isCodeSent ? "재전송" : "인증번호 전송")
                                        .font(.callout.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(isEmailValid ? Color("Redemphasis2") : .gray)
                                        .cornerRadius(10)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                            }

                            if isCodeSent {
                                ZStack {
                                    TextField("인증번호 입력", text: $verificationCode)
                                        .padding()
                                        .frame(height: 65)
                                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))

                                    HStack(spacing: 8) {
                                        Text(convertSecToTime(sec: limitTime))
                                            .font(.callout.bold())
                                            .foregroundColor(.black)

                                        Button(action: {
                                            // 인증번호 확인 액션
                                        }) {
                                            Text("확인")
                                                .font(.callout.bold())
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(isCodeValid ? Color("Redemphasis2") : .gray)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 20)
                                }
                                .onReceive(timer) { _ in
                                    if isTimerActive && limitTime > 0 {
                                        limitTime -= 1
                                    } else if limitTime == 0 {
                                        isTimerActive = false
                                        showAlert = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // Alert for expired code
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("인증번호가 만료되었습니다."),
                                message: Text("다시 인증번호를 전송해주세요."),
                                dismissButton: .default(Text("확인"))
                            )
                        }

                        // Username and Password Fields
                        VStack(spacing: 15) {
                            
                            Text("아이디 *")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            
                            ZStack{
                                TextField("아이디", text: $username)
                                    .padding()
                                    .frame(height: 65)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                    .padding(.horizontal, 20)
                                
                                Button(action: {
                                    checkUsernameDuplicate()
                                }) {
                                    Text("중복확인")
                                        .font(.callout.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(isIDValid ? Color("Redemphasis2") : .gray)
                                        .cornerRadius(10)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 40)
                                
                                if isIDDuplicated{
                                    Text("중복된 아이디입니다.")
                                        
                                }

                            }
                            
                            Text("비밀번호 *")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)

                            SecureField("비밀번호", text: $password)
                                .padding()
                                .frame(height: 65)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 30)
                }

                Spacer()

                // Next Button
                RedButton(title: "다음", isEnabled: $isEnabled, height: 55) {
                    // 다음 화면 이동
                }
                .padding(.bottom, 70 * heightRatio)
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct AddFriendCustomBar: View {
    var backButtonFunc: (() -> Void)
    var widthRatio: CGFloat
    var heightRatio: CGFloat

    var body: some View {
        ZStack(alignment: .top) {
            // Back 버튼 (왼쪽 상단에 위치)
            Button(action: backButtonFunc) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 21 * widthRatio))
                    .foregroundColor(Color("Graybasic"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16) // 왼쪽 여백
            .alignmentGuide(.top) { _ in 0 } // 상단 정렬 기준 설정

            // 로고 (화살표 상단에 맞춰 내림)
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80 * widthRatio, height: 56 * heightRatio)
                .alignmentGuide(.top) { dimension in
                    // Back 버튼 상단에 로고를 맞춤
                    dimension[.top] + 6 * heightRatio
                }
        }
        .frame(height: 57.0 * heightRatio) // 전체 높이 설정
    }
}


#Preview {
    Register()
}
