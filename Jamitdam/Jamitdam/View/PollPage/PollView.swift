import SwiftUI

struct PollView: View {
    
    var relationship: Relationship = tiger // 호랭이 객체 사용

    @State private var poll = dummyPolls[0] // 첫 번째 투표 데이터
    @State private var currentUser = user1 // 현재 사용자
    @State private var showPopover: Bool = false // 말풍선 표시 여부


    var body: some View {
        NavigationStack {
            TopBar(title: "투표를 잇다")
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // 작성자 정보
                        HStack {
                            Image(poll.writer.profile)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(poll.writer.name)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                Text(poll.timeElapsedString())
                                    .font(.footnote)
                                    .foregroundColor(Color("Graybasic"))
                            }
                            Spacer()
                            
                            Button(action: {
                                // 빈 버튼 (컨텍스트 메뉴로 작동)
                            }) {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90)) // 세로로 돌리기
                                    .font(.system(size: 20)) // 크기 조정
                                    .foregroundColor(Color("Graybasic"))
                                    
                            }
                            .contextMenu {
                                Button(action: {
                                    // 수정 동작
                                }) {
                                    Label("수정", systemImage: "pencil")
                                }

                                Button(role: .destructive, action: {
                                    // 삭제 동작
                                }) {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                        }
                        
                        // 관계 아이콘 (호랭이 아이콘)
                        HStack {
                            Text(relationship.icon)
                                .font(.largeTitle)
                                .onTapGesture {
                                    withAnimation {
                                        //showHashtagPopover.toggle() // 말풍선 토글
                                    }
                                }
                                //.popover(isPresented: $showHashtagPopover) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(relationship.hashtags, id: \.self) { hashtag in
                                            Text("#\(hashtag)")
                                                .font(.headline)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding()
                                    .frame(width: 200) // 말풍선 크기 조정
                                }
                            Spacer()
                        }
                        
                        // 투표 본문
                        if let content = poll.content {
                            Text(content)
                                .font(.callout)
                        }
                        
                        // 투표 옵션
                        VStack(spacing: 10) {
                            ForEach(poll.options.indices, id: \.self) { index in
                                Button(action: {
                                    poll.vote(by: currentUser, for: index)
                                }) {
                                    HStack {
                                        Text(poll.options[index])
                                            .font(.system(size: 16))
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(poll.voters[currentUser.id] == index ? Color.blue : Color.gray, lineWidth: 1)
                                    )
                                }
                                .disabled(poll.voters[currentUser.id] != nil) // 이미 투표했다면 비활성화
                            }
                        }
                        
                        // 투표 상태 표시
                        if let userVoteIndex = poll.voters[currentUser.id] {
                            Text("내가 투표한 항목: \(poll.options[userVoteIndex])")
                                .font(.callout)
                                .foregroundColor(.blue)
                        } else {
                            Button(action: {
                                // 투표 버튼 동작
                            }) {
                                Text("투표하기")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                        
                        // 댓글 표시
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("이모리")
                                    .font(.system(size: 14, weight: .bold))
                                Text("2분 전")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Text("감자탕 미친놈아")
                                .font(.body)
                        }
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarHidden(true) // Top Bar로 대체
            }
        }
    }



#Preview {
    PollView()
}
