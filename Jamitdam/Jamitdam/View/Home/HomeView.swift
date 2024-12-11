import SwiftUI

struct HomeView: View {
    
    // 글 주인공 (더미데이터 유수현)
    private var writer: User = user1
    // 글 (더미데이터 유수현의 글)
    //private var post: Post = dummyPosts[0]

    private var posts: [Post] = dummyPosts // 모든 포스트 데이터
    @EnvironmentObject var navigationState: NavigationState

    @State private var showLoginModal: Bool = false
    @State private var transitionToHome: Bool = false // 자연스러운 전환 제어

    var body: some View {
        NavigationStack {
            ZStack {
                Color("Whitebackground") // 배경색 설정
                    .ignoresSafeArea() // 전체 화면에 배경색 적용
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 56)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 30)
                
                VStack {
                    // 헤더 섹션
                    HStack {
                        
                        // 검색 버튼
                        Button(action: {
                            // 검색 버튼 액션
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 6)
                        // 알림 버튼
                        Button(action: {
                            // 알림 버튼 액션
                        }) {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                    
                    Spacer() // 나머지 공간을 차지하게 하여 헤더가 위에 고정되도록 설정
                    
                    
                    ScrollView{
                        // "운명을 잇다" 섹션
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Text("재미를 잇다")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Image("HomeIcon")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                            
                            Text("한땀한땀 재미를 이어보아요.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.leading, 15)
                        
                        
                        Spacer() // 나머지 공간 차지
                        // 포스트 리스트 섹션
                        if(navigationState.isLoggedIn) {
                            ForEach(posts, id: \.id) { post in
                                HomePost(post: post)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding(.top)
                }
                
                
            }
            .navigationBarBackButtonHidden(true)
            
        }
    }
}
    
#Preview {

    HomeView()
}
