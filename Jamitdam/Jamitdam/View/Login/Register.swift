import SwiftUI

class CustomNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

struct RegisterWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CustomNavigationController {
        let navigationController = CustomNavigationController(rootViewController: UIHostingController(rootView: Register()))
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: CustomNavigationController, context: Context) {}
}


struct Register: View {
    
    @State private var email: String = ""
    
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 모든 정보가 입력되면 true가 된다.
    @State private var isEnabled: Bool = false
    
    
    
    @State private var verificationCode: String = ""
    @State private var isCodeFieldVisible = false // 인증번호 입력 필드 표시 여부
    @State private var isCodeSent = false // 인증번호 전송 여부
    @State private var isCodeEntered = false // 인증번호 입력 여부

    @State private var limitTime: Int = 300 // 5분 타이머
    @State private var showAlert = false // 인증번호 만료시 알림창
    @State private var isTimerActive = false // 타이머 활성화 여부
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @StateObject private var navigationState = NavigationState()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>



    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    let pwRegex = /[A-Za-z0-9!_@$%^&+=]{8,20}/
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var isEmailValid: Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
    
    var isCodeValid: Bool {
        let codePattern = "[0-9]{6}"
        let codePredicate = NSPredicate(format: "SELF MATCHES %@", codePattern)
        return codePredicate.evaluate(with: verificationCode)
    }
    
    func converSecToTime(sec: Int) -> String {
        let min = Int(sec / 60)
        let sec = sec % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                
                ZStack(alignment: .topLeading){
                    
                    Color("Whitebackground")
                    
                    BackButton{
                        navigationState.navigateToLogin = true
                    }
                    .padding()
                    
                    VStack {
                        
                        
                        // Logo
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80 * widthRatio, height: 56 * heightRatio)
                            .padding(.top, heightRatio * 30)
                        
                        // Welcome Text
                        VStack(alignment: .leading) {
                            Text("회원가입")
                                .font(.system(size: 25 * widthRatio, weight: .bold))
                                .padding(.bottom, heightRatio * 15)
                            Text("이메일 주소 *")
                                .font(.body)
                            Text("인증을 위해 이메일 주소를 입력해주세요.")
                                .font(.body)
                                .foregroundColor(Color.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, widthRatio * 20)
                        .padding(.top, heightRatio * 60)
                        .padding(.bottom, heightRatio * 5)
                        
                        
                        VStack(spacing: heightRatio * 22) {
                            ZStack{
                                
                                TextField("이메일", text: $email)
                                    .padding()
                                    .frame(height: heightRatio * 65)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                    .padding(.horizontal, widthRatio * 20)
                                
                                // 전송 버튼이 눌리면 인증번호 전송 상태 변경, 타이머 활성화, 타이머 5분 초기화
                                Button(action: {
                                    isCodeSent = true
                                    isTimerActive = true
                                    limitTime = 300

                                }){
                                    Text(isCodeSent ? "재전송" : "인증번호 전송")
                                        .font(.system(.callout, weight: .bold))
                                        .foregroundColor(Color("Whitebackground"))
                                        .padding(.horizontal, widthRatio * 7)
                                        .padding(.vertical, heightRatio * 12)
                                        .background(isEmailValid ? Color("Redemphasis2") : Color.gray)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)

                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, widthRatio * 35)
                            }
                            
                            if isCodeSent {
                                ZStack{
                                    
                                    TextField("인증번호 입력", text: $verificationCode)
                                        .padding()
                                        .frame(height: heightRatio * 65)
                                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                        .padding(.horizontal, widthRatio * 20)
                                        .transition(.opacity)
                                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
                                        .animation(.easeInOut, value: isCodeFieldVisible)
                                    
                                    Button(action: {
                                        //
                                    }){
                                        Text("확인")
                                            .font(.system(.callout, weight: .bold))
                                            .foregroundColor(Color("Whitebackground"))
                                            .padding(.horizontal, widthRatio * 13)
                                            .padding(.vertical, heightRatio * 12)
                                            .background(isCodeValid ? Color("Redemphasis2") : Color.gray)
                                            .cornerRadius(10)
                                            .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)

                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, widthRatio * 35)
                                    
                                    Text(converSecToTime(sec: limitTime))
                                        .onReceive(timer) { _ in
                                            if isTimerActive {
                                                if limitTime > 0 {
                                                    limitTime -= 1
                                                }
                                                if limitTime == 0 {
                                                    if !isCodeValid {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        }
                                        .font(.system(.callout, weight: .bold))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, widthRatio * 100)
                                        .alert(isPresented: $showAlert) {
                                            Alert(title: Text("인증번호가 만료되었습니다. 다시 전송해 주십시오."), dismissButton: .default(Text("확인"), action: {
                                                isTimerActive = false
                                            })
                                            )
                                        }
                                }
                            }
                        }
                        
                        VStack {
                            Text("아이디 *")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, widthRatio * 20)
                            
                            TextField("아이디", text: $username)
                                .padding()
                                .frame(height: heightRatio * 65)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                .padding(.horizontal, widthRatio * 20)
                                .padding(.bottom, heightRatio * 10)
                                
                            
                            Text("비밀번호 *")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, widthRatio * 20)
                            
                            SecureField("비밀번호", text: $password)
                                .padding()
                                .frame(height: heightRatio * 65)
                                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("Grayunselected"), lineWidth: 1))
                                .padding(.horizontal, widthRatio * 20)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, heightRatio * 148)
                        
                        Spacer()
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    //.navigationBarHidden(true)
                    
                    
                    // Login Button
                    RedButton(title: "다음", isEnabled: $isEnabled, height: heightRatio * 55 ) {
                        navigationState.navigateToNickname = true
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 70 * heightRatio)
                    
                    
                }
                
            }
            .navigationBarBackButtonHidden(true)
            
            
            .navigationDestination(isPresented: $navigationState.navigateToNickname){
                //Home()
            }
            .navigationDestination(isPresented: $navigationState.navigateToLogin){
                Login()
            }
            
        }
    }
}

#Preview {
    Register()
}
