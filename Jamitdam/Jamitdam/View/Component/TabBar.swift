import SwiftUI

struct TabBar: View {
    
    @State private var showPopUp: Bool = false
    @State private var isLoggedIn: Bool = false // 로그인 상태 관리
    @State private var showLoginModal: Bool = false // 로그인 모달 표시 상태
    @State private var isTabBarHidden: Bool = false


    
    var body: some View {
        NavigationStack {
            ZStack {
               
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("홈")
                        }
                    PollHomeView()
                        .tabItem {
                            Image(systemName: "bubble.left.and.bubble.right")
                            Text("투표")
                        }
                    Text("")
                        .tabItem {
                        }
                        .disabled(true)

                    CalendarView(isTabBarHidden: $isTabBarHidden)

                        .tabItem {
                            Image(systemName: "calendar")
                            Text("달력")
                        }
                        .toolbar(isTabBarHidden ? .hidden: .visible, for: .tabBar)
                  
                    MyPageView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("마이페이지")
                        }
                }
                .accentColor(Color("Redlogo"))
                
                .onAppear {
                    if !isLoggedIn {
                        showLoginModal = true // 로그인 상태가 아니면 모달 표시
                    }
                }
                .sheet(isPresented: $showLoginModal, onDismiss: {
                    if !isLoggedIn {
                        showLoginModal = true // 로그인이 안 되어 있으면 모달 다시 표시
                    }
                }) {
                    LoginModal(isLoggedIn: $isLoggedIn, showLoginModal: $showLoginModal)
                }
                // 새로운 글 버튼
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Button(action: {
                            // 팝업 표시 토글
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("Redlogo"))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(y: 0)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
                .zIndex(1)
                .opacity(isTabBarHidden ? 0 : 1)
                
                
                // 팝업
                if showPopUp {
                    VStack {
                        Spacer()
                        PostPopUp()
                            .offset(y: -70)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showPopUp)
                }
            }
        }
        .onAppear {
            // 로그인 상태를 즉시 확인하여 초기값 설정
            checkLoginStatus()
        }
    }
    func checkLoginStatus() {
        if !isLoggedIn {
            showLoginModal = true // 로그인 상태가 아니면 모달 표시
        }
    }
}

struct PostPopUp: View {
    @State private var buttonWidth: CGFloat = 173
    
    var body: some View {
        VStack {
            // 1. 잼얘 생성하기 버튼
            NavigationLink(destination: WriteJamView()) {
                HStack {
                    Text("잼얘 생성하기")
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                    Spacer()
                        .frame(width: 10)
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(Color("Graybasic"))
                }
            }
            .padding(.vertical, 5)
            
            Divider()
                .frame(width: buttonWidth, height: 1)
                .background(Color("Grayoutline"))
            
            // 2. 투표 생성하기
            NavigationLink(destination: CreateVoteView()) {
                HStack {
                    Text("투표 생성하기")
                        .font(.system(size: 16))
                        .foregroundColor(Color.black)
                    Spacer()
                        .frame(width: 10)
                    Image(systemName: "tray")
                        .foregroundColor(Color("Graybasic"))
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .frame(width: buttonWidth)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
}

#Preview {
    TabBar()
}
