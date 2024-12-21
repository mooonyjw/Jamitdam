
import SwiftUI

struct FriendProfileView: View {
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    @Binding var user: User?
    @State private var nickname: String = ""

    // 친구 추가 액션 시트
    @State private var isPresentingBottomSheet = false
    
    @State private var navigationSelection: String? = nil
    

    
    var body: some View {
        //NavigationStack {
            GeometryReader { geometry in
                
                let widthRatio = geometry.size.width / screenWidth
                let heightRatio = geometry.size.height / screenHeight
            
                    VStack {
                        
                        AddFriendCustomBar(widthRatio: widthRatio, heightRatio: heightRatio)
                        
                        // 화면 가운데 프로필 이미지
                        Image(user!.profile)
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
 
                        Spacer()
                            .frame(height: heightRatio * 36)
                        
                        
                        
                        // 상단 버튼 (인연 보기, 친구 보기, 디데이)
                        HStack(spacing: 30 * widthRatio) {
                            MyPageButton(widthRatio: widthRatio, heightRatio: heightRatio, icon: "🩷", title: "인연 보기", destination: RelationshipListView())
                            
                            // destination 설정 해야함
                            DdayButton(widthRatio: widthRatio, heightRatio: heightRatio, lover: son, dday: dday2)
                            
                        }
                        .padding(.leading, 26 * widthRatio)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        // 친구의 기록
                        VStack {
                            Spacer()
                                .frame(height: 40 * heightRatio)
                                .fontWeight(.bold)
                            
                            
                            Text("친구의 기록")
                                .font(.system(size: 20 * widthRatio))
                                .fontWeight(.medium)
                                .padding(.leading, 26 * widthRatio)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 13 * heightRatio)
                            
                            
                            VStack {
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 글", button: "chevron.right", destination: RelationshipListView())
                                // destination 설정 해야함
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "작성한 투표", button: "chevron.right", destination: RelationshipListView())
                            }
                            
                            Spacer()
                                .frame(height: 20 * heightRatio)
                            
                            // 구분선
                            Rectangle()
                                .frame(height: 1 * heightRatio)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .padding(.horizontal, 26 * widthRatio)
                        }
                        
                        
                        // 친구 관리
                        VStack {
                            Spacer()
                                .frame(height: 13 * heightRatio)
                                .fontWeight(.bold)

                            
                            VStack {

                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "친구 삭제", titleButton: true, destination: BlockedFriendListView())
                                
                                MyPageList(widthRatio: widthRatio, heightRatio: heightRatio, title: "친구 차단", titleColor: Color.red, titleButton: true, destination: RequestedFriendListView())
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
            .onAppear {
                nickname = user!.name
            }
            .navigationBarHidden(true)
        //}
        
    }
    
}


//#Preview {
//    FriendProfileView(user: user2)
//}
