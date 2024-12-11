import SwiftUI



struct AddFriendView: View {
    
    @State private var friendName: String = ""
    @State private var friendID: String = ""
    @State private var friendsList = [user2, user3, user4, user5]
    @State private var selectedFriend: User? = nil
    @State private var navigateToFriendProfile = false
    
    let textFieldPadding = UIScreen.main.bounds.height * 0.0213
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "아이디로 친구 추가",
                rightButton: "추가",
                rightButtonFunc: {
                    if let friend = matchingFriend() {
                        selectedFriend = friend
                        navigateToFriendProfile = true
                    }                },
                rightButtonDisabled: !isFriendValid()
            )
            
            
            // 간격 33
            Spacer().frame(height: UIScreen.main.bounds.height * 0.0391)

            
            CustomTextField("친구 이름", text: $friendName)
                .padding(.horizontal, textFieldPadding)
            
            Spacer().frame(height: UIScreen.main.bounds.height * 0.0213)
            
            CustomTextField("친구 아이디", text: $friendID)
                .padding(.horizontal, textFieldPadding)
            
            Spacer()
            
            NavigationLink(
                destination: AddFriendProfileView(selectedFriend: $selectedFriend),
                isActive: $navigateToFriendProfile
            ) {
                EmptyView()
            }
            
        }
        .background(Color("Whitebackground"))
        .navigationBarBackButtonHidden(true) 
    }
    
    // 일치하는 사용자가 있을 시 추가 버튼 활성화
    private func isFriendValid() -> Bool {
        matchingFriend() != nil
    }
    
    // 일치하는 친구를 찾기
    private func matchingFriend() -> User? {
        friendsList.first { user in
            user.name == friendName && user.userID == friendID
        }
    }
}



struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding(.bottom, UIScreen.main.bounds.height * 0.0105)
                
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("Grayunselected"))
        }
    }
}


#Preview {
    AddFriendView()
}
