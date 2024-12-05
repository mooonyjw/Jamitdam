import SwiftUI


struct MyPollListView: View {

    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844

    var user: User
    var pollList: [Poll] = []
    
    init(user: User) {
        self.user = user
        self.pollList = dummyPolls.filter { $0.writer.id == user.id }
    }
    var body: some View {

        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            
            VStack {
                TopBar(title: "작성한 투표")
                
                ScrollView {
                    VStack(spacing: 20 * heightRatio) {
                        ForEach(pollList) { poll in
                            VotePost(poll: poll)
                        }
                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MyPollListView(user: user1)
}
