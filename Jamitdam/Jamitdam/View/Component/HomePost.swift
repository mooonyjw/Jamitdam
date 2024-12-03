import SwiftUI

struct HomePost: View {
    
    var user: User
    var post: Post
    //var likesCount: Int
    init(user: User, post: Post) {
        self.user = user
        self.post = post
        //self.likesCount = post.likesCount
    }
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    @State var isLiked: Bool = false
    // 좋아요 개수
    @State var likesCount: Int = 5
    // 더미 댓글 데이터
    @State var comments: [Comment] = [comment1, comment2, co_comment1]
    
    public var body: some View {
        GeometryReader { geometry in
            
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            NavigationLink(destination: MyPageView()) {
                ZStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                            .frame(height: 16)
                        
                        // 글 작성자 이름, 프사
                        HStack(alignment: .top, spacing: 10) {
                            Image(user.profile)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            // 작성자 이름, 시간
                            VStack(alignment: .leading, spacing: 3) {
                                Text(user.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                Text(timeAgoSinceDate(post.timestamp))
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("Graybasic"))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        // 제목
                        Text(post.title)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        
                        Spacer()
                            .frame(height: 5)
                        
                        Text(post.content)
                            .font(.system(size: 16))
                            .padding(.top, 2)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        // 넘을 시 점점점으로
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        // 좋아요 및 댓글
                        HStack {
                            // 좋아요
                            HStack {
                                LikeButton(isLiked: $isLiked, likesCount: $likesCount, userId: user1.id, postId: post.id)
                                Text("\(likesCount)")
                                    .foregroundColor(Color("Graybasic"))
                                    .font(.system(size: 20))
                            }
                            .frame(width: 70, alignment: .leading)
                            
                            
                            // 댓글
                            HStack {
                                Image(systemName: "quote.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("Graybasic"))
                                Text("\(comments.count)")
                                    .foregroundColor(Color("Graybasic"))
                                    .font(.system(size: 20))
                            }
                            
                        }
                    }
                    .padding([.top, .bottom, .trailing])
                    // 왼쪽 간격 조절
                    .padding(.leading, 30)
                    .frame(width: 354, height: 256, alignment: .top)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .buttonStyle(PlainButtonStyle())
        }

    }
}

#Preview {
    NavigationView {
        HomePost(user: user1, post: dummyPosts[0])
    }
}
