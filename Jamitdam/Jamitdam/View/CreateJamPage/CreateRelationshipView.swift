import SwiftUI

struct KeyboardHost<Content: View>: UIViewControllerRepresentable {
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIHostingController(rootView: content())
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct CreateRelationshipView: View {
    // 버튼을 활성화시키기 위한 변수
    @State private var isEnabled: Bool = false
    
    // 사용자가 입력한 이모지
    @State private var icon: String = ""
    // 사용자가 입력한 닉네임
    @State private var nickname: String = ""
    // 사용자가 입력한 해시태그
    @State private var hashtagContent: String = ""
    // 최종 저장된 해시태그
    @State private var hashtag: String = ""
    
    // 해시태그 저장 후 수정 중인지 여부
    @State private var isEditing: Bool = false
    
    // 친구들에게 알림 보낼지 여부
    @State private var alertFriends: Bool = true
    
    // emoji 입력이 아닐 시 alert를 띄우기 위한 변수
    @State private var isShowingAlert = false
    
    
    func saveHashtag() {
        print(hashtagContent)
        if !hashtagContent.isEmpty {
            hashtag = hashtagContent.trimmingCharacters(in: .whitespacesAndNewlines)
            // 입력 필드 초기화
            hashtagContent = ""
            // 수정 상태 종료
            isEditing = false
            print(hashtag)

        }
    }
    
    func updateButtonState() {
        isEnabled = !nickname.isEmpty && !hashtag.isEmpty && !icon.isEmpty
    }
    
    var body: some View {
        // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
        let screenWidth: CGFloat = 390
        let screenHeight: CGFloat = 844
        

        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            NavigationStack {
                TopBar(title: "새로운 인연 생성하기")
                    ZStack {
                        Color("BackgroundWhite")
                        .ignoresSafeArea()
                        VStack {
                            Text("그 사람은 누구인가요?")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.system(size: 25 * widthRatio, weight: .semibold))
                            
                            Text("이모지와 별명으로 상대방을 표현해보아요.")
                                .lineSpacing(3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.system(size: 14 * widthRatio))
                                .foregroundColor(Color("Graybasic"))
                            
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(Color("Redsoftbase"))
                                        .frame(width: 130 * widthRatio, height: 130 * heightRatio)
                                    /*
                                    TextField("", text: $icon)
                                        .font(.system(size: 25 * widthRatio, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.default)
                                        .frame(width: 100 * widthRatio, height: 130 * heightRatio)
                                        .font(.system(size: 60 * widthRatio))
                                     */
                                    EmojiTextfield(text: $icon, isShowingAlert: $isShowingAlert)
                                        .frame(width: 100 * widthRatio, height: 130 * heightRatio)
                                    
                                    if icon.isEmpty {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 30 * widthRatio, height: 30 * heightRatio)
                                            .foregroundColor(Color("Grayunselected"))
                                            .transition(.opacity)
                                    }
                                }
                                .frame(height: 150 * heightRatio)
                                
                                Spacer()
                                    .frame(height: 40 * heightRatio)
                                
                                VStack {
                                    TextField("title", text: $nickname,
                                              prompt: Text("별명 입력")
                                        .font(.system(size: 25 * heightRatio))
                                                        .foregroundColor(Color("Graybasic")))
                                        .multilineTextAlignment(.center)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .keyboardType(.default)
                                        .frame(width: 100 * widthRatio, height: 25 * heightRatio)
                                        .font(.system(size: 25 * widthRatio, weight: .semibold))
                                    
                                    // 닉네임이 비어있을 때 placeholder의 밑줄
                                    if nickname.isEmpty {
                                        Rectangle()
                                            .fill(Color(("Graybasic")))
                                            .frame(width: 120 * widthRatio, height: 2)
                                    }
                                }
                                .frame(height: 30 * heightRatio)
                            }
                            .frame(height: 302 * heightRatio)
                            
                            
                            VStack {
                                Text("관계 해시태그")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .font(.system(size: 25 * widthRatio, weight: .semibold))
                                
                                HStack {
                                    Text("#")
                                        .padding(.leading)
                                     
                                    // 스페이스 눌러야 해시태그 수정 뜨는거 -> 그냥 완료하면 수정 뜨는걸로?
                                    // 해시태그 작성 완료되면 가운데로 와버리는거 고치기
                                    
                                    if isEditing || hashtag.isEmpty {
                                        TextField("title", text: $hashtagContent, prompt: Text("여기를_눌러서_관계를_해시태그로_표현해보아요.")
                                            .font(.system(size: 14 * widthRatio))
                                            .foregroundColor(Color("Graybasic")))
                                        .font(.system(size: 18 * widthRatio, weight: .semibold))
                                        .onChange(of: hashtagContent) { newValue in
                                            if newValue.contains(" ") || newValue.contains("\n") {
                                                saveHashtag()
                                            }
                                        }
                                    }
                                    else {
                                        Text(hashtag)
                                            .font(.system(size: 18 * widthRatio, weight: .semibold))
                                        
                                        Button(action: {
                                            isEditing = true
                                            hashtagContent = hashtag
                                            hashtag = ""
                                        }) {
                                            Text("수정")
                                                .foregroundColor(Color("Graybasic"))
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 25 * heightRatio)
                            }
                            .frame(height: 64 * heightRatio)
                            
                            
                            Toggle("친구들에게 알림 보내기", isOn: $alertFriends)
                                .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                                .padding(.leading)
                                .padding(.trailing)
                                .frame(height: 64 * heightRatio)
                            
                            RedButton(title: "완료", isEnabled: $isEnabled, height: 55 * heightRatio, action: {print("hi")})
                        }
                        .onChange(of: icon) { _ in
                            updateButtonState()
                        }
                        .onChange(of: nickname) { _ in
                            updateButtonState()
                        }
                        .onChange(of: hashtag) { _ in
                            updateButtonState()
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
        }

    }
}

#Preview {
    CreateRelationshipView()
}
