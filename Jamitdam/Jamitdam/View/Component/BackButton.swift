import SwiftUI

struct BackButton: View {
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

        }
        .padding(.top, 0)
        .frame(height: 57.0 * heightRatio)
    }
}
