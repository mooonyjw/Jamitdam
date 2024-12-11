import SwiftUI

//var like1: Like = Like(userId: user1.id, postId: posts1[0].id)
//var like2: Like = Like(userId: user1.id, postId: posts1[1].id)
//var like3: Like = Like(userId: user1.id, postId: posts2[0].id)
//
//var likes: [Like] = [like1, like2, like3]

struct LikePostListView: View {

    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844

    var user: User
    var postList: [Post] = []
    
    init(user: User) {
        self.user = user
        // 좋아요 누른 글들
        self.postList = likes.filter { $0.userId == user.id }.map { like in
            dummyPosts.first { $0.id == like.postId }!
        }
    }
    var body: some View {

        GeometryReader { geometry in
            let heightRatio = geometry.size.height / screenHeight
            
            VStack {
                TopBar(title: "좋아요 누른 글")
                
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
    LikePostListView(user: user1)
}
