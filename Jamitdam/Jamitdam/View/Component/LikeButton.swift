import SwiftUI

public struct LikeButton: View {
    // 좋아요 상태를 나타내는 변수
    // DB로부터 좋아요 상태를 가져와야 한다.
    @Binding private var isLiked: Bool
    // 좋아요 개수를 업데이트하기 위한 바인딩
    @Binding private var likesCount: Int
    // 사용자 id
    private var userId: UUID
    // 글 또는 투표 id
    private var postId: UUID
    
    // 애니메이션 크기 조정을 위한 크기 조정 변수
    @State private var scale: CGFloat = 1.0
    
    public var body: some View {
        Button(action: {
            // 버튼 눌렀을 때 커졌다가 작아지는 애니메이션
            withAnimation(.easeInOut(duration: 0.2)) {
                scale = 2.0
            }
            withAnimation(.easeInOut(duration: 0.1)) {
                scale = 1.0
            }
            
            // 버튼을 누를 때 좋아요 상태를 토글
            isLiked.toggle()
            // DB에 바뀐 상태 업데이트
            toggleLikeStatus()
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("Redemphasis"))
                .scaleEffect(scale)
        }
        .onAppear {
            isLiked = checkIfLiked()
        }
    }
    
    public init(isLiked: Binding<Bool>, likesCount: Binding<Int>, userId: UUID, postId: UUID) {
        self._isLiked = isLiked
        self._likesCount = likesCount
        self.userId = userId
        self.postId = postId
    }
    
    // 유저가 글을 좋아요눌렀는지 여부를 확인하는 함수
    // 더미 likes 배열 사용
    public func checkIfLiked() -> Bool {
        return likes.contains { like in
            like.userId == userId && like.postId == postId
        }
    }
    
    // 좋아요 상태를 토글하는 함수
    // 더미 likes 배열 사용
    private func toggleLikeStatus() {
        // 실제 DB 업데이트 로직 필요
        if let postIndex = dummyPosts.firstIndex(where: { $0.id == postId }) {
            // 좋아요 취소
            if isLiked {
                dummyPosts[postIndex].likesCount += 1
                likesCount += 1
                likes.append(Like(userId: userId, postId: postId))
                print("like")
            }
            // 좋아요
            else {
                dummyPosts[postIndex].likesCount -= 1
                likesCount -= 1
                likes.removeAll { $0.userId == userId && $0.postId == postId }
                print("like 취소")
            }
        }
    }
}