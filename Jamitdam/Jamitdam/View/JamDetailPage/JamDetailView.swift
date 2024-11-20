import SwiftUI

struct JamDetailView: View {
    
    // 글 주인공 (더미데이터 유수현)
    private var owner: User = user1
    // 글 (더미데이터 유수현의 글)
    private var post: Post = dummyPosts[0]
    
    var body: some View {
        // 작성자 프로필
        var profile: String = owner.profile
        // 작성자 이름
        var name: String = owner.name
        // 글 제목
        var title: String = post.title
        // 글 본문
        var content: String = post.content
        // 글 작성 시간
        var timestamp: Date = post.timestamp
        //
        
        ScrollView {
            TopBar(title: "재미를 잇다")
            VStack {
                
                // 작성자 프로필
                HStack {
                    Image(profile)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack {
                        Text(name)
                            .font(.system(size: 20, weight: .semibold))
                        
                    }

                }
                .padding(.top, 37)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(content)
                    .font(.system(size: 25))
                    .frame(height: 110)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            // 글 본문은 좀 더 안쪽으로 들어오도록 한다
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

#Preview {
    JamDetailView()
}
