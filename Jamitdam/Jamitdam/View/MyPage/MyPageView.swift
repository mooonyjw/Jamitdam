import SwiftUI

struct MyPageView: View {
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    // 유수현의 마이페이지
    @State private var user: User = user1
    @State private var nickname: String = ""
    @State private var underlineWidth: CGFloat = 0
    
    // 닉네임 변경 여부
    @State private var isEditingName = false
    // 8글자 이상 닉네임 입력 시
    @State private var showWarning = false
    
    @State private var isShowingImagePicker = false
    // 선택된 갤러리 이미지
    @State private var profileImage: UIImage? = nil
    
    // 변경 사항 여부
    @State private var isEdited = false
    @State private var editedName: String = ""
    
    @State private var showSaveMessage = false
    
    // 친구 추가 액션 시트
    @State private var isPresentingBottomSheet = false
    
    // 알림 토글
    @State private var onAlarm: Bool = true
    // 다크모드 토글
    @State private var darkMode: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: 40 * heightRatio)
                        
                        // Logo + 저장 버튼
                        HStack {
                            Image("Logo")
                                .resizable()
                                .frame(width: 40 * widthRatio, height: 28.5 * heightRatio)
                                .padding(.leading, 39 * widthRatio)
                            
                            // 오른쪽 여백 확보
                            Spacer()
                            
                            // 저장 버튼 누를 시
                            if isEdited {
                                Button(action: {
                                    print("변경사항 저장")
                                    // 변경된 닉네임을 유저의 닉네임으로 업데이트
                                    user.name = editedName
                                    // 변경된 프사를 유저의 프사로 업데이트 - 추후 구현?
                                    //user.profile = String(profileImage)
                                    isEdited.toggle()
                                    
                                    // 저장 알림 표시
                                    withAnimation {
                                        showSaveMessage = true
                                    }
                                    
                                    // 2초 후 알림 사라지도록 설정
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showSaveMessage = false
                                        }
                                    }
                                }) {
                                    Text("저장")
                                        .padding(.trailing, 18 * widthRatio)
                                }
                            } else {
                                // Add 버튼 공간 확보
                                Spacer().frame(width: 44 * widthRatio)
                            }
                            
                        }
                        
                        // 화면 가운데 프로필 이미지
                        ZStack(alignment: .bottomTrailing) {
                            // 프로필 변경 시 갤러리에서 가져온 이미지
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .frame(width: 110 * widthRatio, height: 110 * heightRatio)
                                    .clipShape(Circle())
                                    .padding(.top, 26 * heightRatio)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Image(user.profile)
                                    .resizable()
                                    .frame(width: 110 * widthRatio, height: 110 * heightRatio)
                                    .clipShape(Circle())
                                    .padding(.top, 26 * heightRatio)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            // 카메라 버튼
                            Button(action: {
                                isEdited = true
                                isShowingImagePicker = true
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .frame(width: 30 * widthRatio, height: 30 * heightRatio)
                                    .foregroundColor(Color("Redbase"))
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            .offset(x: -145 * widthRatio, y: 10 * heightRatio)
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            // 갤러리로 이동
                            ImagePicker(selectedImage: $profileImage)
                        }
                    
                        
                        // 닉네임
                        VStack(spacing: 0) {
                            // 편집모드
                            if isEditingName {
                                // 편집 모드에서는 TextField를 표시
                                // 8글자 넘을 시 경고창 띄워야됨
                                TextField("", text: $nickname, onCommit: {
                                    isEditingName = false
                                    if nickname.count > 8 {
                                        // 8글자 이상일 경우 경고창 표시 및 저장 비활성화
                                        showWarning = true
                                        isEdited = false
                                    } else {
                                        // 닉네임이 유효할 경우
                                        editedName = nickname
                                        isEdited = true
                                    }
                                })
                                .onChange(of: nickname) { newValue in
                                    // 닉네임 길이 확인 및 저장 버튼 상태 업데이트
                                    showWarning = newValue.count > 8
                                    isEdited = newValue.count <= 8 && newValue != user.name
                                }
                                .font(.system(size: 25 * widthRatio))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .preference(key: TextWidthPreferenceKey.self, value: geometry.size.width)
                                    }
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                                .onPreferenceChange(TextWidthPreferenceKey.self) { textWidth in
                                    underlineWidth = textWidth
                                }
                                
                                if showWarning {
                                    Text("8글자 이내로 작성해주세요.")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                        .padding(.top, 4)
                                }
                                
                            } else {
                                // 편집 모드가 아니면 Text를 표시
                                Text(nickname)
                                    .font(.system(size: 25 * widthRatio))
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .background(
                                        GeometryReader { geometry in
                                            Color.clear
                                                .preference(key: TextWidthPreferenceKey.self, value: geometry.size.width)
                                        }
                                    )
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .onPreferenceChange(TextWidthPreferenceKey.self) { textWidth in
                                        underlineWidth = textWidth
                                    }
                                    .onTapGesture {
                                        // 닉네임 선택 시 닉네임 수정 가능
                                        isEditingName = true
                                        // 변경 사항 생김 - 저장 버튼 활성화
                                        isEdited = true
                                    }
                            }
                        }
                        Spacer()
                            .frame(height: 0)
                        
                        // 닉네임 밑줄
                        Rectangle()
                            .frame(width: underlineWidth, height: 1)
                            .foregroundColor(Color("Graybasic"))
                            .offset(y: 4)
                        
                        Spacer()
                            .frame(height: heightRatio * 36)
                        
                        
                        
                        // 상단 버튼 (인연 보기, 친구 보기, 디데이)
                        HStack {
                            MyPageButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "🩷", title: "인연 보기", destination: AddFriendProfileView())
                            
                            Spacer().frame(width: 11.5 * widthRatio)
                            
                            MyPageButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "😎", title: "친구 보기", destination: SelectingFriendProfileView())
                            
                            Spacer().frame(width: 11.5 * widthRatio)
                            
                            DdayButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "🐻‍❄️", Dday: 100)
                            
                        }
                        .padding(.leading, 26 * widthRatio)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        // 나의 기록
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            
                            Text("나의 기록")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            
                            VStack {
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 글", button: "chevron.right", destination: AddFriendProfileView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 투표", button: "chevron.right", destination: SelectingFriendProfileView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26)
                        }
                        
                        // 나의 활동
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            
                            
                            Text("나의 활동")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            
                            VStack {
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "좋아요 누른 글", button: "chevron.right", destination: AddFriendProfileView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "투표한 글", button: "chevron.right", destination: SelectingFriendProfileView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26)
                        }
                        
                        // 친구 관리
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            Text("친구 관리")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            VStack {
                                
                                // 친구 추가 리스트
                                HStack {
                                    Spacer()
                                        .frame(width: 26 * widthRatio)

                                    Text("친구 추가")
                                        .font(.system(size: 18 * widthRatio))
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                   
                                        Image(systemName: "plus")
                                            .font(.system(size: 21 * widthRatio))
                                            .foregroundColor(Color("Graybasic"))
                                            .onTapGesture {
                                                isPresentingBottomSheet = true
                                            }
                                            .actionSheet(isPresented: $isPresentingBottomSheet) {
                                                ActionSheet(
                                                    title: Text("친구 추가 방식을 선택해주세요."),
                                                    buttons: [
                                                        .default(Text("아이디로 친구 추가")) {
                                                            // 페이지 이동 추후 구현
                                                    
                                                        },
                                                        .default(Text("카카오톡으로 친구 추가")) {
                                                            // 카카오톡으로 링크 보내기
                                                        },
                                                        .cancel {
                                                        }
                                                    ]
                                                )
                                            }
                                    
                                    Spacer()
                                        .frame(width: 17 * widthRatio)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 57 * heightRatio)
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "차단된 친구", button: "chevron.right", destination: SelectingFriendProfileView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "친구 요청 확인하기", button: "chevron.right", destination: SelectingFriendProfileView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26)
                        }
                        
                        // 앱 관리
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            
                            
                            Text("앱 관리")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            VStack {
                                ToggleList(widthRatio: widthRatio, heightRatio: heightRatio, whatToggle: 1, onAlarm: $onAlarm, darkMode: $darkMode)
                                
                                ToggleList(widthRatio: widthRatio, heightRatio: heightRatio, whatToggle: 2, onAlarm: $onAlarm, darkMode: $darkMode)
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "튜토리얼 보기", titleButton: true, destination: SelectingFriendProfileView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26)
                        }
                        
                        // 로그인
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            
                            
                            Text("로그인")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            VStack {
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "로그아웃", titleButton: true, destination: AddFriendProfileView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "탈퇴하기", titleColor: Color.red, titleButton: true, destination: SelectingFriendProfileView())

                            }

                        }
                    }
           
                }
                
                // 저장 시 알림 메세지
                if showSaveMessage {
                    VStack {
                        Text("변경사항이 저장되었습니다.")
                            .font(.system(size: 18 * widthRatio))
                            .padding()
                            .background(Color("Grayunselected"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.opacity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                }
            }
            .onAppear {
                nickname = user.name
                editedName = user.name
            }
            // 전체 영역에 탭 가능하도록 설정
            .contentShape(Rectangle())
            // 외부를 터치하면 닉네임 편집 모드 종료
            .onTapGesture {
                if isEditingName{
                    isEditingName = false
                }
            }
        }
    }
    
}

struct TextWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// 인연 보기, 친구 보기 버튼
struct MyPageButton<Destination: View>: View {
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var icon: String
    var title: String
    
    // 이동하는 페이지
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Text(icon)
                    .font(.system(size: 20 * widthRatio))
                
                Spacer()
                    .frame(height: 10 * heightRatio)
                
                Text(title)
                    .font(.system(size: 14 * widthRatio))
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
            }
        }
        .frame(width: 105 * widthRatio, height: 85 * heightRatio)
        .background(Color("Redbase"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}


// 디데이 버튼
struct DdayButton: View {
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var icon: String
    
    // 입력받을 디데이 날짜
    let Dday: Int
    @State private var title: String


    init(widthRatio: CGFloat, heightRatio: CGFloat, icon: String, Dday: Int) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.icon = icon
        self.Dday = Dday
        self._title = State(initialValue: "D+\(Dday)")
    }
    
    var body: some View {
        // 디데이 수정 페이지로 이동
        NavigationLink(destination: AddFriendProfileView()) {
            VStack {
                
                ZStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 35 * widthRatio))
                        .foregroundColor(Color.white)
                    
                    Text(icon)
                        .font(.system(size: 20 * widthRatio))
                }
                Spacer()
                    .frame(height: 0)
                
                Text(title)
                    .font(.system(size: 20 * widthRatio))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            }
        }
        .frame(width: 105 * widthRatio, height: 85 * heightRatio)
        .background(Color("Redbase"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}



// 각 목록 뷰
struct MyPageList<Destination: View>: View {
    
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

struct ToggleList: View {
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    // 1: 알람 2: 다크모드
    var whatToggle: Int
    
    @Binding var onAlarm: Bool
    @Binding var darkMode: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
                .frame(width: 26 * widthRatio)
            
            if whatToggle == 1 {
                Text("알림")
                    .font(.system(size: 18 * widthRatio))
                    .foregroundColor(Color.black)
            } else {
                Text("다크모드")
                    .font(.system(size: 18 * widthRatio))
                    .foregroundColor(Color.black)
            }
            
            
            Spacer()
            
            if whatToggle == 1{
                Toggle("", isOn: $onAlarm)
                    .labelsHidden()
                
                if !onAlarm {
                    // 알람 끄기?
                }
            } else {
                Toggle("", isOn: $darkMode)
                    .labelsHidden()
                
                if darkMode {
                    // 다크모드?
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
    MyPageView()
}
