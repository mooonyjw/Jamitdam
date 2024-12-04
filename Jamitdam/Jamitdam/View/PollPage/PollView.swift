import SwiftUI

struct PollView: View {
    @State var poll: Poll // 전달받은 투표 데이터
    @State private var currentUser = user1 // 현재 사용자
    @State private var showPopover: Bool = false // 말풍선 표시 여부
    @State private var selectedOption: Int? = nil // 사용자가 선택한 옵션 인덱스
    @State private var hasVoted: Bool = false // 사용자가 투표를 완료했는지 여부
    @State private var editingComment: Comment? = nil // 현재 수정 중인 댓글
    @State private var editedContent: String = ""     // 수정된 댓글 내용


    
    // 더미 댓글 데이터
    @State var comments: [Comment] = [poll_comment1, poll_comment2, poll_comment3]
    
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
    
    var isEnabled: Bool {
        // 사용자가 옵션을 선택했는지 확인
        return selectedOption != nil
    }
    
    func enableReply(parent: Comment) {
        
        // 대댓글 작성 로직 추가
        print("대댓글 작성 모드 활성화 for \(parent.id)")
        self.parentComment = parent
        self.isReply = true
        DispatchQueue.main.async {
            self.isKeyboardActive = true
        }
    }
    
    func initializeComments() {
        topLevelComments = comments.filter { $0.parentId == nil }
        replyDict = [:]
        
        for comment in comments {
            // 대댓글인 경우
            if let parentId = comment.parentId {
                if replyDict[parentId] != nil {
                    replyDict[parentId]?.append(comment)
                } else {
                    replyDict[parentId] = [comment]
                }
            }
        }
    }
    // 이모티콘 찾기
    func extractEmoji(from text: String) -> String? {
        for char in text {
            if char.isEmoji {
                return String(char)
            }
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 상단바
                TopBar(title: "운명을 잇다")
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // 작성자 프로필
                            HStack {
                                // 작성자 정보
                                Image(poll.writer.profile)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(poll.writer.name)
                                        .font(.system(size: 20, weight: .semibold))
                                    Text(poll.timeElapsedString())
                                        .font(.footnote)
                                        .foregroundColor(Color("Graybasic"))
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                                
                                Menu {
                                    // 본인이 작성한 글만 수정/삭제 버튼 표시
                                    if poll.writer.id == currentUser.id {
                                        Button(action: {
                                            print("수정 동작 실행")
                                            editPoll()
                                        }) {
                                            Label("수정", systemImage: "pencil")
                                        }

                                        Button(role: .destructive, action: {
                                            print("삭제 동작 실행")
                                            deletePoll()
                                        }) {
                                            Label("삭제", systemImage: "trash")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .rotationEffect(.degrees(90))
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                        .padding(8)
                                }
                                
                                
                            }
                            .padding()
                            
                            // 본문 내용
                            if let content = poll.content {
                                Text(content)
                                    .font(.system(size: 20))
                                    .frame(height: 110)
                                    .frame(minHeight: 110, maxHeight: .infinity)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                //.font(.system(size: 16))
                                //.fixedSize(horizontal: false, vertical: true) // 줄바꿈 허용
                                
                                // 본문에서 첫 번째 이모티콘 추출
                                let emoji = extractEmoji(from: content)
                                
                                // 첫 번째 이모티콘과 관련된 해시태그 표시
                                if let emoji = emoji,
                                   let hashtag = relationships.first(where: { $0.icon == emoji })?.hashtags {
                                    Text("#\(hashtag)")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Redemphasis"))
                                        .padding(.horizontal)
                                        .padding(.top, 5)
                                }
                            }
                           
                            if !hasVoted {
                                // 투표 화면 (투표 완료 전)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(poll.options.indices, id: \.self) { index in
                                        Button(action: {
                                            selectedOption = index
                                        }) {
                                            // 옵션 버튼 스타일
                                            HStack {
                                                Text(poll.options[index])
                                                    .font(.system(size: 17))
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal)
                                                Spacer()
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(selectedOption == index ? Color("Redsoftbase") : Color.white)
                                                    .frame(height: 55)
                                                    .padding(.horizontal)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(
                                                        selectedOption == index ? Color("Redemphasis2") : Color.gray,
                                                        lineWidth: 1
                                                    )
                                                    .frame(height: 55)
                                                    .padding(.horizontal)
                                            )
                                        }
                                    }
                                    
                                    // 투표하기 버튼
                                    RedButton(title: "투표하기", isEnabled: .constant(isEnabled), height: 55) {
                                        if let selectedOption = selectedOption {
                                            print("Before voting: \(poll.votes)") // 투표 전 상태 출력
                                            poll.vote(by: currentUser, for: selectedOption) // 투표 실행
                                            print("After voting: \(poll.votes)") // 투표 후 상태 출력
                                            hasVoted = true
                                        }
                                    }
                                    .disabled(!isEnabled) // 선택된 옵션이 없으면 비활성화
                                    
                                }
                            } else {
                                // 투표 결과 화면 (투표 완료 후)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(poll.options.indices, id: \.self) { index in
                                        HStack {
                                            // 옵션 텍스트
                                            Text(poll.options[index])
                                                .font(.system(size: 17))
                                                .foregroundColor(.black)
                                                .padding(.leading)
                                            
                                            Spacer()
                                            
                                            // 받은 투표 수 표시
                                            Text("\(poll.votes[index])표")
                                                .font(.system(size: 16))
                                                .padding(.horizontal)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(index == selectedOption ? Color("Redsoftbase") : Color.white)
                                                .padding(.horizontal)
                                                .frame(height: 55)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(
                                                    index == selectedOption ? Color("Redemphasis2") : Color.gray,
                                                    lineWidth: 1
                                                )
                                                .padding(.horizontal)
                                                .frame(height: 55)
                                        )
                                    }
                                    
                                    // 다시 투표하기 버튼 (RedButton 사용)
                                    RedButton(title: "다시 투표하기", isEnabled: .constant(true), height: 55) {
                                        hasVoted = false  // 투표 상태 초기화
                                        selectedOption = nil  // 선택 초기화
                                    }
                                    .padding(.bottom, 5)
                                    
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
                                    .padding(.horizontal)
                                    
                                    Divider()
                                    
                                    // 댓글 섹션
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                            Text("댓글")
                                                .font(.headline)
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        
                                        // 댓글 목록
                                        ForEach(comments.filter { $0.parentId == nil }, id: \.id) { comment in
                                            VStack(alignment: .leading) {
                                                
                                                // 댓글 작성자 및 내용
                                                HStack(alignment: .top) {
                                                    if let commentWriter = users.first(where: { $0.id == comment.userId }) {
                                                        Image("\(commentWriter.profile)")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 50, height: 50)
                                                            .clipShape(Circle())
                                                        
                                                        Spacer()
                                                            .frame(width: 10)
                                                        
                                                        VStack(alignment: .leading) {
                                                            // 작성자 이름 및 작성 시간
                                                            HStack {
                                                                Text("\(commentWriter.name)")
                                                                    .font(.system(size: 15, weight: .semibold))
                                                                Text(comment.timeElapsedString())
                                                                    .font(.footnote)
                                                                    .foregroundColor(Color("Graybasic"))
                                                            }
                                                            .padding(.bottom, 1)
                                                            // 댓글 내용
                                                            Text(comment.content)
                                                                .font(.system(size: 16))
                                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                        }
                                                        Spacer()
                                                        Button(action: {
                                                            // 대댓글 작성 동작
                                                            enableReply(parent: comment)
                                                        }) {
                                                            Image(systemName: "bubble.right")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 15, height: 15)
                                                                .foregroundColor(Color("Graybasic"))
                                                        }
                                                        if comment.userId == currentUser.id {
                                                            Menu {
                                                                Button(role: .destructive, action: {
                                                                    deleteComment(comment)
                                                                }) {
                                                                    Label("삭제", systemImage: "trash")
                                                                }
                                                            } label: {
                                                                Image(systemName: "ellipsis")
                                                                    .rotationEffect(.degrees(90))
                                                                    .font(.system(size: 15))
                                                                    .foregroundColor(.gray)
                                                                    .padding(.top, 5)
                                                                    
                                                            }
                                                        }
                                                    }
                                                }
                                                .padding(.bottom, 15)
                                                .swipeActions {
                                                    Button(role: .destructive) {
                                                        deleteComment(comment)
                                                    } label: {
                                                        Label("삭제", systemImage: "trash")
                                                    }
                                                }
                                                // 대댓글이 있는 경우 표시
                                                if let replies = replyDict[comment.id] {
                                                    ForEach(replies, id: \.id) { reply in
                                                        HStack(alignment: .top) {
                                                            if let replyWriter = users.first(where: { $0.id == reply.userId }) {
                                                                Image("\(replyWriter.profile)")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 40, height: 40)
                                                                    .clipShape(Circle())
                                                                
                                                                Spacer()
                                                                    .frame(width: 10)
                                                                
                                                                VStack(alignment: .leading) {
                                                                    // 작성자 이름 및 작성 시간
                                                                    HStack {
                                                                        Text("\(replyWriter.name)")
                                                                            .font(.system(size: 15, weight: .semibold))
                                                                        Text(reply.timeElapsedString())
                                                                            .font(.footnote)
                                                                            .foregroundColor(Color("Graybasic"))
                                                                    }
                                                                    .padding(.bottom, 0.3)
                                                                    // 대댓글 내용
                                                                    Text(reply.content)
                                                                        .font(.system(size: 16))
                                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                                    
                                                                }
                                                                
                                                                Spacer()
                                                                // 본인이 작성한 댓글만 삭제 버튼 표시
                                                                if reply.userId == currentUser.id {
                                                                    Menu {
                                                                        Button(role: .destructive, action: {
                                                                            deleteComment(reply)
                                                                        }) {
                                                                            Label("삭제", systemImage: "trash")
                                                                        }
                                                                    
                                                                    } label: {
                                                                        Image(systemName: "ellipsis")
                                                                            .rotationEffect(.degrees(90))
                                                                            .font(.system(size: 15))
                                                                            .foregroundColor(.gray)
                                                                            .padding(.top, 5)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        .padding(.leading, 70) // 대댓글 들여쓰기
                                                        .swipeActions {
                                                            // 삭제 버튼
                                                            Button(role: .destructive) {
                                                                deleteComment(comment)
                                                            } label: {
                                                                Label("삭제", systemImage: "trash")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                            .id(comment.id)
                                            
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    // 새로운 댓글이 추가되면 가장 아래로 스크롤
                    .onChange(of: scrollToId) { id in
                        if let id = id {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        // 댓글과 대댓글 분류하여 배열과 딕셔너리 초기화
                        initializeComments()
                    }
                    .onTapGesture {
                        // 배경 터치 시 키보드를 내린다
                        print(isKeyboardActive)
                        isKeyboardActive = false
                        
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
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color("Graybasic"))
                                }
                            }
                            .padding(.top, 5)
                            
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
                        
                        ZStack(alignment: .leading) {
                            if myComment.isEmpty {
                                Text("당신의 의견을 입력해주세요!")
                                    .foregroundColor(Color("Grayunselected"))
                                    .padding(10)
                                    .font(.system(size: 15))
                            }

                            TextField("", text: $myComment)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .font(.system(size: 15))
                                .foregroundColor(Color.black)
                                .focused($isKeyboardActive)
                        }
                        
                        Button(action: {
                            if hasVoted {
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
                            } else {
                                // 투표가 필요한 경우
                                print("투표를 완료해야 댓글을 입력할 수 있습니다.")
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
                    .padding(.top, 5)
                }
                .background(Color.clear)
                
            }
            .navigationBarHidden(true) // TopBar로 대체
        }
    }
    
    // 글 삭제 함수
    func deletePoll() {
        guard poll.writer.id == currentUser.id else {
            print("삭제 권한이 없습니다.")
            return
        }

        print("글 삭제 실행")
        // 삭제 후 다른 화면으로 이동하는 로직 추가
    }
    
    // 글 수정 함수
    func editPoll() {
        guard poll.writer.id == currentUser.id else {
            print("수정 권한이 없습니다.")
            return
        }

        print("글 수정 실행")
        // 수정 화면으로 이동하거나 수정 UI 표시
    }

    // 대댓글 추가
    func addReply(user: User, parent: Comment) {
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
    func addComment(user: User) {
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
    
    // 댓글 삭제 함수
    func deleteComment(_ comment: Comment) {
        print("댓글 삭제 시도: \(comment.content)")
        
        // 현재 사용자가 작성한 댓글인지 확인
        guard comment.userId == currentUser.id else {
            print("삭제 권한이 없습니다.")
            return
        }
        
        // 대댓글 작성 중인 상태에서 원본 댓글이 삭제되었는지 확인
        if let parent = parentComment, parent.id == comment.id {
            // 대댓글 작성 상태 초기화
            parentComment = nil
            isReply = false
            myComment = "" // 입력 중인 댓글 초기화
        }
        
        // 대댓글이 있는 경우 함께 삭제
        if let replies = replyDict[comment.id] {
            // 댓글과 대댓글 모두 삭제
            comments.removeAll { $0.id == comment.id || replies.contains(where: { $0.id == $0.id }) }
            replyDict[comment.id] = nil
        } else {
            // 댓글만 삭제
            comments.removeAll { $0.id == comment.id }
        }
        
        // 최상위 댓글 목록 업데이트
        topLevelComments.removeAll { $0.id == comment.id }
        
        // UI 업데이트
        initializeComments()
    }
    
}

extension Character {
    var isEmoji: Bool {
        let scalars = unicodeScalars
        return scalars.count == 1 && scalars.first?.properties.isEmojiPresentation == true
            || scalars.contains(where: { $0.properties.isEmoji })
    }
}

//#Preview {
//    PollView(poll: poll)
//}
