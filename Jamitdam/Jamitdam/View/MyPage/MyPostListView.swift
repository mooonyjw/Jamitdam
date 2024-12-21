import SwiftUI


struct MyPostListView: View {

    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844

    var user: User
    var postList: [Post] = []
    
    init(user: User) {
        self.user = user
        self.postList = dummyPosts.filter { $0.author.id == user.id }
    }
    var body: some View {

        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            
            VStack {
                TopBar(title: "작성한 글")
                
                ScrollView {
                    VStack(spacing: 20 * heightRatio) {
                        ForEach(postList) { post in
                            HomePost(post: post)
                        }
                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MyPostListView(user: user1)
}
