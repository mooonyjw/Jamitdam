import SwiftUI

// 위에 상단바
struct AddFriendCustomBar: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var showBackButton: Bool = true
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    func backButtonFunc() {
        print("뒤로가기 클릭")
        dismiss()
    }
    
    var body: some View {
        HStack {
            Button(action: backButtonFunc) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 21 * widthRatio))
                    .padding()
                    .foregroundColor(Color("Graybasic"))
            }
            
            Spacer()
            
            // 오른쪽에 로고 배치
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 40 * widthRatio, height: 28.5 * heightRatio)
                .padding(.trailing, 27 * widthRatio)
        }
        .padding(.top, 0)
        .frame(height: 57.0 * heightRatio)
    }
}

