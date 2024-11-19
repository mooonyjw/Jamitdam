import SwiftUI

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
        if !hashtagContent.isEmpty {
            hashtag = hashtagContent.trimmingCharacters(in: .whitespacesAndNewlines)
            hashtagContent = "" // 입력 필드 초기화
            isEditing = false // 수정 상태 종료
        }
    }

    func updateButtonState() {
        isEnabled = !nickname.isEmpty && !hashtag.isEmpty && !icon.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack {
                TopBar(title: "새로운 인연 생성하기")
                ScrollView {
                    Spacer()
                        .frame(height: 50)
                    VStack(spacing: 20) {
                        Text("그 사람은 누구인가요?")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 25, weight: .semibold))

                        Text("이모지와 별명으로 상대방을 표현해보아요.")
                            .lineSpacing(3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 14))
                            .foregroundColor(Color("Graybasic"))

                        VStack(spacing: 40) {
                            ZStack {
                                Circle()
                                    .fill(Color("Redsoftbase"))
                                    .frame(width: 130, height: 130)

                                EmojiTextfield(text: $icon, isShowingAlert: $isShowingAlert)
                                    .frame(width: 100, height: 130)

                                if icon.isEmpty {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color("Grayunselected"))
                                        .transition(.opacity)
                                }
                            }
                            .alert(isPresented: $isShowingAlert) {
                                Alert(
                                    title: Text(""),
                                    message: Text("이모지를 입력해주세요!"),
                                    dismissButton: .default(Text("확인"))
                                )
                            }

                            VStack(spacing: 10) {
                                TextField("title", text: $nickname,
                                          prompt: Text("별명 입력")
                                            .font(.system(size: 25))
                                            .foregroundColor(Color("Graybasic")))
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.default)
                                    .font(.system(size: 25, weight: .semibold))

                                if nickname.isEmpty {
                                    Rectangle()
                                        .fill(Color("Graybasic"))
                                        .frame(width: 120, height: 2)
                                }
                            }
                        }

                        VStack {
                            Text("관계 해시태그")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.system(size: 25, weight: .semibold))

                            HStack {
                                Text("#")
                                    .padding(.leading)

                                if isEditing || hashtag.isEmpty {
                                    TextField("title", text: $hashtagContent, prompt: Text("여기를_눌러서_관계를_해시태그로_표현해보아요.")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("Graybasic")))
                                    .font(.system(size: 18, weight: .semibold))
                                    .onSubmit {
                                        saveHashtag()
                                    }

                                } else {
                                    Text(hashtag)
                                        .font(.system(size: 18, weight: .semibold))

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
                            .frame(height: 25)
                        }

                        Toggle("친구들에게 알림 보내기", isOn: $alertFriends)
                            .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                            .padding(.horizontal)

                        RedButton(title: "완료", isEnabled: $isEnabled, height: 55, action: { print("hi") })
                    }
                }
                .onChange(of: icon) { _ in updateButtonState() }
                .onChange(of: nickname) { _ in updateButtonState() }
                .onChange(of: hashtag) { _ in updateButtonState() }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    CreateRelationshipView()
}
