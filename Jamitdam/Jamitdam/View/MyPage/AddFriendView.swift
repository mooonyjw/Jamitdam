//
//  AddFriendView1.swift
//  Jamitdam
//
//  Created by sojeong on 11/6/24.
//

import SwiftUI

struct AddFriendView: View {
    
    @State private var friendName: String = ""
    @State private var friendID: String = ""
    @State private var friendsList = [("John", "john123"), ("Jane", "jane456")] // 더미데이터
    
    let textFieldPadding = UIScreen.main.bounds.height * 0.0213
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "아이디로 친구 추가",
                backButtonFunc: { print("뒤로 가기 클릭") },
                rightButton: "추가",
                rightButtonFunc: { print("추가 버튼 클릭") },
                rightButtonDisabled: !isFriendValid()
            )
            
            
            //Spacer().frame(height: 33)
            Spacer().frame(height: UIScreen.main.bounds.height * 0.0391)

            
            CustomTextField("친구 이름", text: $friendName)
                .padding(.horizontal, textFieldPadding)
            
            Spacer().frame(height: UIScreen.main.bounds.height * 0.0213)
            
            CustomTextField("친구 아이디", text: $friendID)
                .padding(.horizontal, textFieldPadding)
            
            Spacer()
            
        }
        .background(Color("Whitebackground"))
    }
    
    // 일치하는 사용자가 있을 시 추가 버튼 활성화
    private func isFriendValid() -> Bool {
        friendsList.contains { (name, id) in
            name == friendName && id == friendID
        }
    }
}



struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding(.bottom, UIScreen.main.bounds.height * 0.0105) // 텍스트 필드 내부 아래쪽 여백
                
            Rectangle()
                .frame(height: 1) // 아래 모서리 선 두께
                .foregroundColor(Color("Grayunselected"))
        }
    }
}


#Preview {
    AddFriendView()
}
