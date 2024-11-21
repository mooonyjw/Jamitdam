import SwiftUI

struct JamDetailView: View {
    
    // 투표 주인공 (더미데이터 유수현)
    private var writer: User = user1
    // 투표 (더미데이터 유수현의 투표)
    private var post: Post = dummyPosts[0]

    
    var body: some View {
        // 글 ID
        let postId: UUID = post.id
        // 작성자 ID
        let writerId: UUID = writer.id
        // 작성자 프로필
        let profile: String = writer.profile
        // 작성자 이름
        let name: String = writer.name
        // 글 제목
        let title: String = post.title
        // 글 본문
        let content: String = post.content
        // 글 작성 시간
        let writeDate: Date = post.timestamp

        
        ScrollView {
            TopBar(title: "운명을 잇다")
            VStack {
                // 작성자 프로필
                HStack {
                    Image(profile)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.system(size: 20, weight: .semibold))
//                        Text(timeAgoSinceDate(writeDate))
//                            .font(.system(size: 13))
//                            .padding(.leading, 2)
                    }
                }
                .padding(.top, 37)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 본문
                Text(content)
                    .font(.system(size: 25))
                    .frame(height: 110)
                    .frame(minHeight: 110)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 좋아요 및 댓글
                HStack {
                    // 좋아요
                    HStack(spacing: 5) {
                        LikeButton(isLiked: $isLiked, likesCount: $likesCount, userId: user1.id, postId: postId)
                        Text("\(likesCount)")
                            .foregroundColor(Color("Graybasic"))
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    // 댓글
                    HStack(spacing: 5) {
                        Image(systemName: "quote.bubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Graybasic"))
                    }
        

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(Color("Graybasic"))
                    
            }
            // 글 본문은 좀 더 안쪽으로 들어오도록 한다
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .onAppear {
            // 사용자의 좋아요 상태를 체크하여 초깃값 설정
            initializeLikeStatus()
        }
    }
    
    // 좋아요 상태 초기화를 위한 함수
    private func initializeLikeStatus() {
        // 좋아요 여부를 체크하는 함수 사용
        isLiked = checkIfLiked(userId: writer.id, postId: post.id)
        likesCount = post.likesCount
    }
    
    // 유저가 글을 좋아요 눌렀는지 여부를 확인하는 함수
    private func checkIfLiked(userId: UUID, postId: UUID) -> Bool {
        // 실제 데이터 소스를 사용해 좋아요 여부를 확인
        return likes.contains { like in
            like.userId == userId && like.postId == postId
        }
    }
}

#Preview {
    JamDetailView()
}
