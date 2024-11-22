import SwiftUI

struct JamDetailView: View {
    
    // 글 주인공 (더미데이터 유수현)
    private var writer: User = user1
    // 글 (더미데이터 유수현의 글)
    private var post: Post = dummyPosts[0]
    // 좋아요 눌렀는지 여부
    // false로 초기화하지만 DB -> likebutton으로부터 정보를 받아서 업데이트
    @State var isLiked: Bool = false
    // 좋아요 개수
    @State var likesCount: Int = 0
    
    // 더미 댓글 데이터
    @State var comments: [Comment] = [comment1, comment2, co_comment1]
    
    // 최상위 댓글 배열
    @State var topLevelComments: [Comment] = []
    // 대댓글 딕셔너리
    // key: 최상위 댓글 배열, value: 대댓글 목록
    @State var replyDict: [UUID: [Comment]] = [:]
    
    // 사용자가 입력한 댓글
    @State var myComment: String = ""

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

        TopBar(title: "재미를 잇다")
        ScrollView {
            VStack {
                // 작성자 프로필
                HStack {
                    Image(profile)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    Spacer()
                        .frame(width: 10)
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.system(size: 20, weight: .semibold))
                        Text(timeAgoSinceDate(writeDate))
                            .font(.system(size: 14))
                            .padding(.leading, 2)
                    }
                }
                .padding(.top, 37)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 본문
                Text(content)
                    .font(.system(size: 25))
                    .frame(height: 110)
                    .frame(minHeight: 110, maxHeight: .infinity)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // 좋아요 및 댓글
                HStack {
                    // 좋아요
                    HStack {
                        LikeButton(isLiked: $isLiked, likesCount: $likesCount, userId: user1.id, postId: postId)
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
                    }
        

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Rectangle()
                    .frame(width: .infinity, height: 1)
                    .foregroundColor(Color("Graybasic"))
                    .padding(.bottom, 10)
                
                // 댓글 목록
                ForEach(comments.filter { $0.postId == postId }, id: \.id) { comment in
                    VStack(alignment: .leading) {
                        VStack {
                            // 댓글 작성자 프로필
                            HStack(alignment: .top) {
                                if let commentWriter = users.first(where: { $0.id == comment.userId  && comment.parentId == nil }) {
                                    Image("\(commentWriter.profile)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    
                                    Spacer()
                                        .frame(width: 10)
                                    
                                    VStack(alignment: .leading) {
                                        // 사용자 이름 및 작성 시간
                                        HStack {
                                            Text("\(commentWriter.name)")
                                                .font(.system(size: 20))
                                            Text(timeAgoSinceDate(comment.date))
                                                .font(.system(size: 12))
                                        }
                                        // 댓글 내용
                                        Text(comment.content)
                                            .font(.system(size: 20))
                                    }
                                }
                            }
                            .padding(.bottom, 15)
                        }
                        
                        // 대댓글이 있는 경우 표시
                        if let replies = replyDict[comment.id] {
                            ForEach(replies, id: \.id) { reply in
                                if let replyWriter = users.first(where: { $0.id == reply.userId }) {
                                    HStack {
                                        Image("\(replyWriter.profile)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                        
                                        Spacer()
                                            .frame(width: 10)
                                        
                                        VStack(alignment: .leading) {
                                            // 사용자 이름 및 작성 시간
                                            HStack {
                                                Text("\(replyWriter.name)")
                                                    .font(.system(size: 20))
                                                Text(timeAgoSinceDate(comment.date))
                                                    .font(.system(size: 12))
                                            }
                                            // 댓글 내용
                                            Text(reply.content)
                                                .font(.system(size: 20))
                                        }
                                    }
                                    .padding(.leading, 70)
                                }
                            }
                            .padding(.bottom, 15)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            // 사용자의 좋아요 상태를 체크하여 초깃값 설정
            initializeLikeStatus()
            // 댓글과 대댓글 분류하여 배열과 딕셔너리 초기화
            initializeComments()
        }
        
        // 하단 키보드 고정
        HStack {
            // 유저 프로필
            
            Image(user1.profile)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .leading)
                .clipShape(Circle())
                .padding(.leading)
            
            Spacer()
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Grayunselected"), lineWidth: 1)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                
                TextField("", text: $myComment)
                    .keyboardType(.default)
                    .frame(height: 50)
                    .font(.system(size: 20))
                    .padding(.leading, 10)
                
                if myComment.isEmpty {
                    Text("당신의 의견을 입력해주세요!")
                        .font(.system(size: 15)).foregroundColor(Color("Grayunselected"))
                        .padding(.horizontal, 10)
                }
            }
            
            Button(action: {
                // 댓글을 추가
                addComment(user: user1)
                
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(myComment.isEmpty ? Color("Redbase") : Color("Redemphasis"))
            }
            .disabled(myComment.isEmpty)
            .padding(.trailing)


        }
        .frame(alignment: .bottom)
    }
    
    // 좋아요 상태 초기화를 위한 함수
    public func initializeLikeStatus() {
        // 좋아요 여부를 체크하는 함수 사용
        isLiked = checkIfLiked(userId: writer.id, postId: post.id)
        likesCount = post.likesCount
    }
    
    // 유저가 글을 좋아요 눌렀는지 여부를 확인하는 함수
    public func checkIfLiked(userId: UUID, postId: UUID) -> Bool {
        // 실제 데이터 소스를 사용해 좋아요 여부를 확인
        return likes.contains { like in
            like.userId == userId && like.postId == postId
        }
    }
    
    // 최상위 댓글과 대댓글 분류
    public func initializeComments() {
        topLevelComments = comments.filter { $0.parentId == nil }
        replyDict = [:]
        
        for comment in comments {
            // 대댓글인 경우
            if let parentId = comment.parentId {
                if replyDict[parentId] != nil {
                    replyDict[parentId]?.append(comment)
                }
                else {
                    replyDict[parentId] = [comment]
                }
            }
        }
    }
    
    // 대댓글 추가
    public func addReply(user: User, comment: Comment) {
        if let parentId = comment.parentId {
            if replyDict[parentId] != nil {
                replyDict[parentId]?.append(comment)
            }
            else {
                replyDict[parentId] = [comment]
            }
        }
    }
    
    // 댓글 추가
    public func addComment(user: User) {
        guard !myComment.isEmpty else { return }
        
        let newComment = Comment(
            userId: user.id,
            postId: post.id,
            date: Date(),
            content: myComment,
            parentId: nil
        )
        
        comments.append(newComment)
        topLevelComments.append(newComment)
        myComment = ""
    }
    
}

#Preview {
    JamDetailView()
}
