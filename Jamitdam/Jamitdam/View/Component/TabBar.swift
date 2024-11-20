import SwiftUI

struct TabBar: View {
    
    init() {
        // 탭바의 선택된 항목 색상 설정
        UITabBar.appearance().tintColor = UIColor(named: "Redlogo")
        // 탭바의 비선택 항목 색상 설정
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        
        TabView {
            AddFriendProfileView()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            FriendListView()
                .tabItem{
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("투표")
                }
            MyPageView()
                .tabItem{
                    Image(systemName: "plus.square")
                    Text("새로운 글")
                }
            RelationshipListView()
                .tabItem{
                    Image(systemName: "calendar")
                    Text("달력")
                }
            MyPageView()
                .tabItem{
                    Image(systemName: "person")
                    Text("마이페이지")
                }
            
        }
        .accentColor(Color("Redlogo"))
        
    }
}

#Preview {
    TabBar()
}
