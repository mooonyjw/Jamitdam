import SwiftUI

struct Register: View {
    @State private var email: String = ""
    
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 모든 정보가 입력되면 true가 된다.
    @State private var isEnabled: Bool = false
    @State private var verificationCode: String = ""
    @State private var isCodeSent = false
    @State private var isTimerActive = false
    @State private var limitTime: Int = 300
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var isIDDuplicated = false


    @StateObject private var navigationState = NavigationState()

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

    // 공백 포함 안 됨
    func isPasswordnoWhitespace(_ password: String) -> Bool {
        let noWhitespaceRequirement = password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
        return noWhitespaceRequirement
    }
    
    // 최소 8자 이상, 최대 20자 이하
    func isPasswordLengthValid(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 20
    }
    
    // 대소문자 포함
    func isPasswordCaseValid(_ password: String) -> Bool {
        let uppercaseRequirement = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let lowercaseRequirement = password.range(of: "[a-z]", options: .regularExpression) != nil
        return uppercaseRequirement && lowercaseRequirement
    }
    
    // 특수 문자 포함
    func isPasswordCharValid(_ password: String) -> Bool {
        let specialCharacterRequirement = password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil
        return specialCharacterRequirement
    }
    
    func convertSecToTime(sec: Int) -> String {
        let min = sec / 60
        let sec = sec % 60
        return String(format: "%02d:%02d", min, sec)
    }

    func checkUsernameDuplicate() {
        // 유효성 검사
        guard isIDValid else {
            isIDDuplicated = false
            return
        }

        // 중복 확인
        isIDDuplicated = dummyLoginID.contains { $0.userID == username }
    }
    
    var isFormValid: Bool {
        return isEmailValid &&
               isIDValid &&
               isPasswordValid &&
               isCodeValid
    }

    // 비밀번호 유효성 검사 함수
    var isPasswordValid: Bool {
        return isPasswordLengthValid(password) &&
               isPasswordCaseValid(password) &&
               isPasswordCharValid(password) &&
               isPasswordnoWhitespace(password)
    }
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                let heightRatio = geometry.size.height / screenHeight
                let widthRatio = geometry.size.width / screenWidth
                
                VStack {
                    // Custom Navigation Bar 사용
                    AddFriendCustomBar(
                        widthRatio: widthRatio,
                        heightRatio: heightRatio
                    )
                    .frame(height: 57)
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
                            .padding(.horizontal)
                            
                            
                            
                            VStack(spacing: 20) {
                                ZStack {
                                    // RoundedRectangle으로 박스 그리기
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("Grayunselected"), lineWidth: 1)
                                        .frame(height: 65)
                                    
                                    // TextField와 Button 배치
                                    HStack {
                                        TextField("이메일", text: $email)
                                            .frame(maxWidth: .infinity, alignment: .leading) // TextField 확장
                                        
                                        // 인증번호 전송 버튼
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
                                        // isEmailValid가 false이면 버튼 비활성화
                                        .disabled(!isEmailValid)
                                    }
                                    // ZStack 내부 여백
                                    .padding(.horizontal, 15)
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
                                        .padding(.trailing, 15)
                                        
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
                            .padding(.horizontal)
                            
                            // Alert for expired code
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("인증번호가 만료되었습니다."),
                                    message: Text("다시 인증번호를 전송해주세요."),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
                            
                            // 아이디, 비밀번호 Fields
                            VStack(spacing: 15) {
                                HStack(spacing: 15){
                                    Text("아이디 *")
                                        .font(.body)
                                    
                                    if isIDDuplicated {
                                        Text("중복된 아이디입니다.")
                                            .font(.callout)
                                            .foregroundColor(Color("Redemphasis"))
                                    }
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ZStack {
                                    // RoundedRectangle으로 박스 그리기
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("Grayunselected"), lineWidth: 1)
                                        .frame(height: 65)
                                        .padding(.horizontal)
                                    
                                    // TextField와 Button 배치
                                    HStack {
                                        // TextField
                                        TextField("아이디", text: $username)
                                            .onChange(of: username) { newValue in
                                                if newValue.count > 12 {
                                                    // 12자 초과 입력 차단
                                                    username = String(newValue.prefix(12))
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 15)
                                        
                                        // 인증번호 전송 버튼
                                        Button(action: {
                                            checkUsernameDuplicate()
                                        }) {
                                            Text("중복 확인")
                                                .font(.callout.bold())
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 12)
                                                .background(isIDValid ? Color("Redemphasis2") : .gray)
                                                .cornerRadius(10)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 15)
                                    }
                                    // ZStack 내부 여백
                                    .padding(.horizontal, 15)
                                }
                                
                                HStack(spacing: 1){
                                    Text("비밀번호 *")
                                        .font(.body)
                                        .padding(.horizontal)
                                    
                                    if !isPasswordnoWhitespace(password) {
                                        Text("공백을 제거해주세요.")
                                            .font(.callout)
                                            .foregroundColor(Color("Redemphasis"))
                                    }
                                    else if !isPasswordLengthValid(password) {
                                        Text("8~20자 사이의 비밀번호를 입력해주세요.")
                                            .font(.callout)
                                            .foregroundColor(Color("Redemphasis"))
                                    }
                                    else if !isPasswordCaseValid(password) {
                                        Text("대소문자를 포함해야 합니다.")
                                            .font(.callout)
                                            .foregroundColor(Color("Redemphasis"))
                                    }
                                    else if !isPasswordCharValid(password) {
                                        Text("특수문자를 포함해야 합니다.")
                                            .font(.callout)
                                            .foregroundColor(Color("Redemphasis"))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                SecureField("비밀번호", text: $password)
                                    .padding()
                                    .frame(height: 65)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                    .padding(.horizontal)
                                
                                
                            }
                        }
                        .padding(.top, 30)
                    }
                    
                    Spacer()
                    
                    // Next Button
                    RedButton(title: "다음", isEnabled: .constant(isFormValid), height: 55) {
                        navigationState.navigateToNickname = true
                    }
                    .disabled(!isFormValid)
                    .padding(.bottom, 70 * heightRatio)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigationState.navigateToNickname) {
                RegisterNickname()
            }
        }
    }
    
}


#Preview {
    Register()
}
