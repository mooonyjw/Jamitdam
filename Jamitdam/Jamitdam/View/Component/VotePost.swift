import SwiftUI

struct VotePost: View {
    
    var user: User
    var inputPoll: Poll
    var comments: [Comment]
    init(poll: Poll) {
        self.inputPoll = poll
        self.user = poll.writer
        self.comments = dummyPollComments
            .filter { $0.postId == post.id }
    }
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    //@State var comments: [Comment] = [comment1, comment2, co_comment1]
    
    // onAppear로 Poll 초기화 - 하드코딩 아님
    @State private var poll: Poll = dummyPolls[0]
    public var body: some View {

        NavigationLink(destination: PollView(poll: poll)) {
            
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
                        Text(timeAgoSinceDate(poll.createdAt))
                            .font(.system(size: 12))
                            .foregroundColor(Color("Graybasic"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 20)
                
                if let content = poll.content {
                    Text(content)
                        .font(.system(size: 16))
                        .padding(.top, 2)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        // 넘을 시 점점점으로
                        .truncationMode(.tail)
                }
                
                Spacer()
                    .frame(height: 30)
                
                VoteButton(poll: $poll)
                    
                Spacer()
                    .frame(height: 30)
                         
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
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 4)
            .padding(.horizontal)
            .onAppear {
                // onAppear로 Poll 초기화
                poll = inputPoll
            }

        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VoteButton: View { // View 프로토콜 준수
    
    @Binding var poll: Poll
//    init(poll: Poll) {
//        self.poll = poll
//    }
    @State private var currentUser = user1 // 현재 사용자
    @State private var showPopover: Bool = false // 말풍선 표시 여부
    @State private var selectedOption: Int? = nil // 사용자가 선택한 옵션 인덱스
    @State private var hasVoted: Bool = false // 사용자가 투표를 완료했는지 여부
    @State private var editingComment: Comment? = nil // 현재 수정 중인 댓글
    @State private var editedContent: String = ""     // 수정된 댓글 내용
    
    
    var body: some View { // 소문자로 body 작성
        let isEnabled: Bool = selectedOption != nil // 옵션 선택 여부 확인
        
        return VStack(alignment: .leading, spacing: 12) { // 반환
            if !hasVoted {
                // 투표 화면 (투표 완료 전)
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
                                //.padding(.horizontal)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    selectedOption == index ? Color("Redemphasis2") : Color.gray,
                                    lineWidth: 1
                                )
                                .frame(height: 55)
                                //.padding(.horizontal)
                        )
                    }
                }
                
                Button(action: {
                    // 버튼이 활성화 상태일 때만 action 수행
                    if isEnabled {
                        if let selectedOption = selectedOption {
                            print("Before voting: \(poll.votes)") // 투표 전 상태 출력
                            poll.vote(by: currentUser, for: selectedOption) // 투표 실행
                            print("After voting: \(poll.votes)") // 투표 후 상태 출력
                            hasVoted = true
                        }
                    }
                }) {
                    Text("투표하기")
                        .font(.system(.title3, weight: .semibold))
                        .padding(.leading)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(isEnabled ? Color("Redlogo") : Color("Grayunselected"))
                        .foregroundColor(Color("Whitebackground"))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
                }
                .disabled(!isEnabled)
            } else {
                // 투표 결과 화면 (투표 완료 후)
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
                            //.padding(.horizontal)
                            .frame(height: 55)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                index == selectedOption ? Color("Redemphasis2") : Color.gray,
                                lineWidth: 1
                            )
                            //.padding(.horizontal)
                            .frame(height: 55)
                    )
                }
                
                Button(action: {
                    // 버튼이 활성화 상태일 때만 action 수행
                    if isEnabled {
                        hasVoted = false
                        selectedOption = nil
                    }
                }) {
                    Text("다시 투표하기")
                        .font(.system(.title3, weight: .semibold))
                        .padding(.leading)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(isEnabled ? Color("Redlogo") : Color("Grayunselected"))
                        .foregroundColor(Color("Whitebackground"))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
                }
                .disabled(!isEnabled)

            }
        }
        //.padding()
    }
}

#Preview {
    NavigationStack {
        VotePost(poll: dummyPolls[1])
    }
}

