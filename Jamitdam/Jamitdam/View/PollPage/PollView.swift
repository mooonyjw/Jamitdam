import SwiftUI

struct PollView: View {
    @State private var poll = dummyPolls[0] // 첫 번째 투표 데이터
    @State private var currentUser = user1 // 현재 사용자

    var body: some View {
        TopBar(title: "투표를 잇다")
        VStack(alignment: .leading, spacing: 16) {
            // 투표 작성자 정보
            HStack {
                Image(poll.writer.profile)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(poll.writer.name)
                        .font(.system(size: 20, weight: .semibold))
                   
                }
                Spacer()
                Text("\(poll.voters.count)명이 참여함")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Divider()

            // 투표 옵션
            ForEach(poll.options.indices, id: \.self) { index in
                Button(action: {
                    poll.vote(by: currentUser, for: index)
                }) {
                    HStack {
                        Text(poll.options[index])
                        Spacer()
                        Text("\(poll.votes[index])표")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(poll.voters[currentUser.id] == index ? Color.blue : Color.gray, lineWidth: 1)
                    )
                }
                .disabled(poll.voters[currentUser.id] != nil) // 이미 투표했다면 비활성화
            }

            // 투표 상태 표시
            if let userVoteIndex = poll.voters[currentUser.id] {
                Text("내가 투표한 항목: \(poll.options[userVoteIndex])")
                    .font(.callout)
                    .foregroundColor(.blue)
            } else {
                Text("투표를 선택하세요")
                    .font(.callout)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("투표")
    }
}


#Preview {
    PollView()
}
