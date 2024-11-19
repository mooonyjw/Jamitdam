import SwiftUI

import SwiftUI

struct MyPageView: View {
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
            ScrollView {
                VStack(spacing: 20) {
                    // Logo + 저장 버튼
                    // Logo + 저장 버튼
                    HStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 40, height: 28.5)
                            .padding(.leading, 39)
                        
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
                                    .padding(.trailing, 18)
                            }
                        } else {
                            // Add 버튼 공간 확보
                            Spacer().frame(width: 44)
                        }
                        
                    }
                    
                    // 화면 가운데 프로필 이미지
                    ZStack(alignment: .bottomTrailing) {
                        // 프로필 변경 시 갤러리에서 가져온 이미지
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .padding(.top, 26)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Image(user.profile)
                                .resizable()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .padding(.top, 26)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        // 카메라 버튼
                        Button(action: {
                            isEdited = true
                            isShowingImagePicker = true
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("Redbase"))
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                        .offset(x: -145, y: 10)
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
                            .font(.system(size: 25))
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
                                .font(.system(size: 25))
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
                        
                        
                        // 닉네임 밑줄
                        Rectangle()
                            .frame(width: underlineWidth, height: 1)
                            .foregroundColor(Color("Graybasic"))
                            .offset(y: 0)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    // 버튼 섹션: 인연 보기, 친구 보기, 디데이
                    Grid(horizontalSpacing: 20, verticalSpacing: 10) {
                        GridRow {
                            MyPageButton(icon: "🩷", title: "인연 보기", destination: AddFriendProfileView())
                            MyPageButton(icon: "😎", title: "친구 보기", destination: SelectingFriendProfileView())
                            DdayButton(icon: "🐻‍❄️", Dday: 100)
                        }
                    }
                    //.padding(.horizontal, 10)


                    // 나의 기록, 나의 활동, 친구 관리
                    section(title: "나의 기록") {
                        MyPageList(title: "작성한 글", button: "chevron.right", destination: AddFriendProfileView())
                        MyPageList(title: "작성한 투표", button: "chevron.right", destination: SelectingFriendProfileView())
                    }

                    section(title: "나의 활동") {
                        MyPageList(title: "좋아요 누른 글", button: "chevron.right", destination: AddFriendProfileView())
                        MyPageList(title: "투표한 글", button: "chevron.right", destination: SelectingFriendProfileView())
                    }

                    section(title: "친구 관리") {
                        MyPageList(title: "친구 추가", button: "plus", destination: AddFriendProfileView())
                        MyPageList(title: "차단된 친구", button: "chevron.right", destination: SelectingFriendProfileView())
                    }

                    section(title: "앱 관리") {
                        ToggleList(whatToggle: 1, onAlarm: $onAlarm, darkMode: $darkMode)
                        ToggleList(whatToggle: 2, onAlarm: $onAlarm, darkMode: $darkMode)
                    }
                    
                    section(title: "로그인", content:  {
                        MyPageList(title: "로그아웃", titleButton: true, destination: AddFriendProfileView())
                        
                        MyPageList(title: "탈퇴하기", titleColor: Color.red, titleButton: true, destination: SelectingFriendProfileView())
                    }, dividerOn: false)
                    
                }
                .padding()
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

    var profileImageSection: some View {
        ZStack(alignment: .bottomTrailing) {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
            } else {
                Image(user.profile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
            }

            Button(action: {
                isShowingImagePicker = true
            }) {
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 16)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $profileImage)
        }
    }

    var nicknameSection: some View {
        VStack {
            if isEditingName {
                TextField("닉네임 입력", text: $nickname)
                    .onChange(of: nickname) { newValue in
                        showWarning = newValue.count > 8
                        isEdited = newValue != user.name && newValue.count <= 8
                    }
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text(nickname)
                    .font(.title2)
                    .onTapGesture {
                        isEditingName = true
                    }
            }

            if showWarning {
                Text("8글자 이내로 작성해주세요.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Divider().frame(height: 1).background(Color.gray)
        }
    }

    func section<Content: View>(title: String, @ViewBuilder content: () -> Content, dividerOn: Bool = true) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Spacer()
                .frame(height: 30)
            
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.medium)
                .padding(.leading, 26)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 20)
            
            content()
            
            Spacer()
                .frame(height: 20)
            
            if dividerOn {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .padding(.horizontal, 26)
            }
        }
    }

    func saveChanges() {
        user.name = nickname
        isEdited = false

        withAnimation {
            showSaveMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSaveMessage = false
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
    
//    var widthRatio: CGFloat
//    var heightRatio: CGFloat
    
    var icon: String
    var title: String
    
    // 이동하는 페이지
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Text(icon)
                    .font(.system(size: 20))
                
                Spacer()
                    .frame(height: 10)
                
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
            }
        }
        .frame(width: 105, height: 85)
        .background(Color("Redbase"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}


// 디데이 버튼
struct DdayButton: View {
    
//    var widthRatio: CGFloat
//    var heightRatio: CGFloat
    
    var icon: String
    
    // 입력받을 디데이 날짜
    let Dday: Int
    @State private var title: String


    init(icon: String, Dday: Int) {
//        self.widthRatio = widthRatio
//        self.heightRatio = heightRatio
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
                        .font(.system(size: 35))
                        .foregroundColor(Color.white)
                    
                    Text(icon)
                        .font(.system(size: 20))
                }
                Spacer()
                    .frame(height: 0)
                
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
            }
        }
        .frame(width: 105, height: 85)
        .background(Color("Redbase"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}



// 각 목록 뷰
struct MyPageList<Destination: View>: View {
    
//    var widthRatio: CGFloat
//    var heightRatio: CGFloat
    
    var title: String
    var titleColor: Color = Color.black
    var titleButton: Bool = false
    
    // 오른쪽 버튼
    var button: String?
    var destination: Destination
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 26)
            
            // 튜토리얼 보기, 로그아웃, 탈퇴하기는 글자 자체가 버튼임
            if titleButton {
                Button(action: {
                    print("버튼 클릭")
                }) {
                    Text(title)
                        .font(.system(size: 18))
                        .foregroundColor(titleColor)
                }
            } else {
                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(titleColor)
            }
            
            Spacer()
            
            if let button = button {
                NavigationLink(destination: destination) {
                    Image(systemName: button)
                        .font(.system(size: 21))
                        .foregroundColor(Color("Graybasic"))
                }
            }
            
            Spacer()
                .frame(width: 19)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 57)
    }
}

struct ToggleList: View {
//    var widthRatio: CGFloat
//    var heightRatio: CGFloat
    
    // 1: 알람 2: 다크모드
    var whatToggle: Int
    
    @Binding var onAlarm: Bool
    @Binding var darkMode: Bool
    
    var body: some View {
        
        HStack {
            Spacer()
                .frame(width: 26)
            
            if whatToggle == 1 {
                Text("알림")
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
            } else {
                Text("다크모드")
                    .font(.system(size: 18))
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
                .frame(width: 19)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 57)
    }
            
}


#Preview {
    MyPageView()
}
