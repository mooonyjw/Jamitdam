import SwiftUI

struct TopBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var title: String
    var showBackButton: Bool = true
    var rightButton: String = ""
    var rightButtonFunc: (() -> Void)?
    var rightButtonDisabled: Bool = false
    
    func backButtonFunc() {
        print("뒤로가기 클릭")
        dismiss()
    }
    
    var body: some View {
        HStack {
            Button(action: backButtonFunc) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 21))
                    .padding()
                    .foregroundColor(Color("Graybasic"))
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .padding()
            
            Spacer()
            
            // 추가 버튼의 유무 결정 가능
            if !rightButtonDisabled && rightButton != ""{
                Button(action: rightButtonFunc!) {
                    Text(rightButton)
                        .padding()
                }
            } else {
                Spacer().frame(width: 44) // Add 버튼 공간 확보
            }
        }
        .padding(.top, 0)
        .frame(height: 57.0)
        .background(Color("Whitebackground"))
        
        
        // divider
        .overlay(
            Divider().foregroundColor(Color("Graybasic")).padding(.bottom, 0),
            alignment: .bottom
            
        )
        
    }
}

#Preview {
    TopBar(
        title: "상단바 제목",
        rightButton: "추가",
        rightButtonFunc: { print("추가 버튼 클릭") }
    )
}
