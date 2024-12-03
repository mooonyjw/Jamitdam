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
    
    // 사용자가 현재 대댓글을 입력하고 있는 댓글
    @State var parentComment: Comment? = nil
    // 사용자가 현재 대댓글을 입력하고 있는지 여부
    @State var isReply: Bool = false
    
    // 답글버튼을 누를 시 자동으로 키보드가 올라오게 하기 위한 변수
    @FocusState private var isKeyboardActive: Bool
    
    // 댓글 작성 시 그 댓글로 스크롤되게 하기 위해 스크롤 아이디 변수로 관리
    @State private var scrollToId: UUID?

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
        ScrollViewReader { proxy in
            VStack {
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
                            .font(.system(size: 20))
                            .frame(height: 110)
                            .frame(minHeight: 110, maxHeight: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // 이미지
                        if !post.images.isEmpty {
                            ImageSlider(imageUrls: post.images)
                                .padding(.bottom, 30)
                                .padding(.horizontal, -25)
                        }
                        
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
                                Text("\(comments.count)")
                                    .foregroundColor(Color("Graybasic"))
                                    .font(.system(size: 20))
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(Color("Grayunselected"))
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
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                            
                                            Spacer()
                                                .frame(width: 10)
                                            
                                            VStack(alignment: .leading) {
                                                // 사용자 이름 및 작성 시간
                                                HStack {
                                                    Text("\(commentWriter.name)")
                                                        .font(.system(size: 13))
                                                    Text(timeAgoSinceDate(comment.date))
                                                        .font(.system(size: 12))
                                                }
                                                // 댓글 내용
                                                Text(comment.content)
                                                    .font(.system(size: 15))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                // 답글 모드로 전환
                                                enableReply(parent: comment)
                                            }) {
                                                Image(systemName: "bubble")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(Color("Graybasic"))
                                            }
                                            .frame(alignment: .trailing)
                                        }
                                    }
                                    .padding(.bottom, 15)
                                }
                                
                                // 대댓글이 있는 경우 표시
                                if let replies = replyDict[comment.id] {
                                    ForEach(replies, id: \.id) { reply in
                                        if let replyWriter = users.first(where: { $0.id == reply.userId }) {
                                            HStack(alignment: .top) {
                                                Image("\(replyWriter.profile)")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                                
                                                Spacer()
                                                    .frame(width: 10)
                                                
                                                VStack(alignment: .leading) {
                                                    // 사용자 이름 및 작성 시간
                                                    HStack {
                                                        Text("\(replyWriter.name)")
                                                            .font(.system(size: 13))
                                                        Text(timeAgoSinceDate(reply.date))
                                                            .font(.system(size: 12))
                                                    }
                                                    // 댓글 내용
                                                    Text(reply.content)
                                                        .font(.system(size: 15))
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                }
                                            }
                                            .padding(.leading, 40)
                                        }
                                    }
                                    .padding(.bottom, 15)
                                }
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            // 각 댓글 뷰에 id 설정
                            .id(comment.id)
                        }
                    }
                }
                // 새로운 댓글이 추가되면 가장 아래로 스크롤
                .onChange(of: scrollToId) { id in
                    if let id = id {
                        proxy.scrollTo(id, anchor: .bottom)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    // 사용자의 좋아요 상태를 체크하여 초깃값 설정
                    initializeLikeStatus()
                    // 댓글과 대댓글 분류하여 배열과 딕셔너리 초기화
                    initializeComments()
                }
                .onTapGesture {
                    // 배경 터치 시 키보드를 내린다
                    print(isKeyboardActive)
                    isKeyboardActive = false
                    
                }
            }
        }
                
        
        VStack {
            // 언급 중인 경우
            if parentComment != nil && isReply {
                if let parentWriter = users.first(where: { $0.id ==  parentComment?.userId } ) {
                    HStack {
                        Text("\(parentWriter.name)님의 댓글에 답글을 작성중이에요!")
                            .font(.system(size: 15))
                        
                        // 언급 취소 버튼
                        Button(action: {
                            isReply = false
                            parentComment = nil
                            
                        }) {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("Graybasic"))
                        }
                    }

                }
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
                        .focused($isKeyboardActive)
                    
                    if myComment.isEmpty {
                        Text("당신의 의견을 입력해주세요!")
                            .font(.system(size: 15)).foregroundColor(Color("Grayunselected"))
                            .padding(.horizontal, 10)
                    }
                }
                .background(Color.clear)
                
                Button(action: {
                    // 댓글을 추가
                    if !isReply && parentComment == nil {
                        addComment(user: user1)
                    }
                    // 대댓글을 추가
                    else {
                        if let parent = parentComment {
                            addReply(user: user1, parent: parent)
                        }
                    }
                    
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(myComment.isEmpty ? Color("Redbase") : Color("Redemphasis"))
                }
                .disabled(myComment.isEmpty)
                .padding(.trailing)
            }
            .background(Color.clear)
            .frame(alignment: .bottom)
            .padding(.bottom)
        }
        .background(Color.clear)
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
    
    // parent 댓글에 대한 대댓글 모드
    public func enableReply(parent: Comment) {
        self.parentComment = parent
        self.isReply = true
        DispatchQueue.main.async {
            self.isKeyboardActive = true
        }
    }
    
    // 대댓글 추가
    public func addReply(user: User, parent: Comment) {
        let newReply = Comment(
            userId: user.id,
            postId: post.id,
            date: Date(),
            content: myComment,
            parentId: parent.id
        )
        
        if replyDict[parent.id] != nil {
            replyDict[parent.id]?.append(newReply)
        }
        else {
            replyDict[parent.id] = [newReply]
        }
        
        self.comments.append(newReply)
        self.myComment = ""
        self.isReply = false
        self.parentComment = nil
        // 키보드를 내린다
        self.isKeyboardActive = false
        
        // 답글 추가 시 해당 답글의 부모 댓글 스크롤
        DispatchQueue.main.async {
            withAnimation {
                scrollToId = newReply.id
            }
        }
    }
    
    // 댓글 추가
    public func addComment(user: User) {
        guard !self.myComment.isEmpty else { return }
        
        let newComment = Comment(
            userId: user.id,
            postId: post.id,
            date: Date(),
            content: myComment,
            parentId: nil
        )
        
        self.comments.append(newComment)
        self.topLevelComments.append(newComment)
        self.myComment = ""
        
        // 댓글 추가 시 해당 답글로 스크롤
        DispatchQueue.main.async {
            withAnimation {
                scrollToId = newComment.id
            }
        }
    }
    
}

#Preview {
    JamDetailView()
}

/*
 고칠거
 
 1. 언급 시 키보드 올라오게 하기
 2. 언급 비활성화 기능도 추가하기
 3. 바탕 누르면 키보드 내려가게 하기
 4. 댓글 작성 완료하면 키보드 내려가게 하기
 
 */
