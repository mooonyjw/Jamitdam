import SwiftUI

struct TabBar: View {
    
    @State private var showPopUp: Bool = false
    
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
                    CalendarView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("달력")
                        }
                    MyPageView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("마이페이지")
                        }
                }
                .accentColor(Color("Redlogo"))
                
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
