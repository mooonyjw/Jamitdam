/*
 상단바 컴포넌트
 - 제목 및 오른쪽 버튼 내용은 동적으로 변경 가능
 - 오른쪽 버튼은 사용 여부 결정 가능
 - 알림창, 마이페이지 세부 페이지에서 사용된다.
 */


import SwiftUI

struct TopBar: View {
    var title: String
    var showBackButton: Bool = true
    var backButtonFunc: (() -> Void)
    var rightButton: String = ""
    var rightButtonFunc: (() -> Void) = {}
    var rightButtonDisabled: Bool = false
    
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
                Button(action: rightButtonFunc) {
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
        backButtonFunc: { print("뒤로 가기 클릭") },
        rightButton: "추가",
        rightButtonFunc: { print("추가 버튼 클릭") }
    )
}
