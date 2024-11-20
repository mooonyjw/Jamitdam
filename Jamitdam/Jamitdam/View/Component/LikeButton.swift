import SwiftUI

struct LikeButtonView: View {
    // 좋아요 상태를 나타내는 변수
    // DB로부터 좋아요 상태를 가져와야 한다.
    @State private var isLiked: Bool = false
    
    var body: some View {
        Button(action: {
            // 버튼을 누를 때 좋아요 상태를 토글
            // DB에 바뀐 상태 업데이트
            isLiked.toggle()
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("Redemphasis"))
        }
    }
}

struct ButtonView: View {
    var body: some View {
        LikeButtonView()
    }
}

#Preview {
    ButtonView()
}
