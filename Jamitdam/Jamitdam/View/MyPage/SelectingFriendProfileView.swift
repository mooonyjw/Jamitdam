import SwiftUI


struct SelectingFriendProfileView: View {
    
    var body: some View {
        TopBar(
            title: "프로필 선택",
            backButtonFunc: { print("뒤로 가기 클릭") }
        )
        
        Spacer()
    }
}

#Preview {
    SelectingFriendProfileView()
}
