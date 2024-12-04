import SwiftUI

struct MyPageView: View {
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    // 유수현의 마이페이지
    @State private var user: User = user1
    @State private var nickname: String = ""
    @State private var lover: Relationship = tiger

    // 친구 추가 액션 시트
    @State private var isPresentingBottomSheet = false
    
    @State private var navigationSelection: String? = nil
    
    // 알림 토글
    @State private var onAlarm: Bool = true
    // 다크모드 토글
    @State private var darkMode: Bool = false
    
    var body: some View {
        NavigationStack {
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
                            
                        }
                        
                        // 화면 가운데 프로필 이미지
                        Image(user.profile)
                            .resizable()
                            .frame(width: 110 * widthRatio, height: 110 * heightRatio)
                            .clipShape(Circle())
                            .padding(.top, 26 * heightRatio)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // 닉네임
                        Text(nickname)
                            .font(.system(size: 25 * widthRatio))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Spacer()
                            .frame(height: 8 * heightRatio)
                        
                        NavigationLink(destination: AddFriendProfileView()) {
                            Text("프로필 편집")
                                .font(.headline)
                                .foregroundColor(Color("Graybasic"))
                        }
                        
                        Spacer()
                            .frame(height: heightRatio * 36)
                        
                        
                        
                        // 상단 버튼 (인연 보기, 친구 보기, 디데이)
                        HStack {
                            MyPageButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "🩷", title: "인연 보기", destination: RelationshipListView())
                            
                            Spacer().frame(width: 11.5 * widthRatio)
                            
                            MyPageButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "😎", title: "친구 보기", destination: FriendListView(user: user))
                            
                            Spacer().frame(width: 11.5 * widthRatio)
                            
                            // destination 설정 해야함
                            DdayButton(widthRatio: widthRatio, heightRatio: heightRatio, lover: lover, Dday: 40)
                            
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
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 글", button: "chevron.right", destination: AddFriendProfileView())
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 투표", button: "chevron.right", destination: SelectingFriendProfileView(friend: user3))
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            // 구분선
                            Rectangle()
                                .frame(height: 1 * heightRatio)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26 * widthRatio)
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
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "좋아요 누른 글", button: "chevron.right", destination: AddFriendProfileView())
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "투표한 글", button: "chevron.right", destination: SelectingFriendProfileView(friend: user4))
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1 * heightRatio)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26 * widthRatio)
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
                                                    navigationSelection = "addFriend"

                                                },
                                                .default(Text("카카오톡으로 친구 추가")) {
                                                    navigationSelection = "kakaoFriend"
                                                },
                                                .cancel()
                                            ]
                                        )
                                    }
                            
                                    Spacer()
                                        .frame(width: 17 * widthRatio)
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 57 * heightRatio)
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "차단된 친구", button: "chevron.right", destination: BlockedFriendListView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "친구 요청 확인하기", button: "chevron.right", destination: RequestedFriendListView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1 * heightRatio)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26 * widthRatio)
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
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "튜토리얼 보기", titleButton: true, destination: SelectingFriendProfileView(friend: user4))
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            Rectangle()
                                .frame(height: 1 * heightRatio)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26 * widthRatio)
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
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "탈퇴하기", titleColor: Color.red, titleButton: true, destination: SelectingFriendProfileView(friend: user4))

                            }

                        }
                        NavigationLink(destination: AddFriendView(), tag: "addFriend", selection: $navigationSelection) {
                            EmptyView()
                        }
                        
                        NavigationLink(destination: AddFriendView(), tag: "kakaoFriend", selection: $navigationSelection) {
                            EmptyView()
                        }
                    }
                }
            }
            .onAppear {
                nickname = user.name
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
    
    var lover: Relationship
    
    // 입력받을 디데이 날짜
    let Dday: Int
    @State private var title: String


    init(widthRatio: CGFloat, heightRatio: CGFloat, lover: Relationship, Dday: Int) {
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
        self.lover = lover
        self.Dday = Dday
        self._title = State(initialValue: "D+\(Dday)")
    }
    
    var body: some View {
        // 디데이 수정 페이지로 이동

        NavigationLink(destination: DayPlusView(relationship: tiger, startDate: Calendar.current.date(byAdding: .day, value: -40, to: Date())!
           )) {

            VStack {
                
                ZStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 35 * widthRatio))
                        .foregroundColor(Color.white)
                    
                    Text(lover.icon)
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
                    .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                
                if !onAlarm {
                    // 알람 끄기?
                }
            } else {
                Toggle("", isOn: $darkMode)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                
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
