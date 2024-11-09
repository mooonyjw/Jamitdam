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
    @State private var friendsList = [("John", "john123"), ("Jane", "jane456")]
    
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            
            let _widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                TopBar(
                    title: "아이디로 친구 추가",
                    backButtonFunc: { print("뒤로 가기 클릭") },
                    rightButton: "추가",
                    rightButtonFunc: { print("추가 버튼 클릭") },
                    rightButtonDisabled: !isFriendValid()
                )
                
                
                // 간격 33
                Spacer().frame(height: 33 * heightRatio)
                
                
                CustomTextField("친구 아이디", text: $friendID, fieldHeightRatio: heightRatio)
                    .padding(.horizontal, 18 * heightRatio)
                
                Spacer().frame(height: 33 * heightRatio)
                
                CustomTextField("친구 아이디", text: $friendID, fieldHeightRatio: heightRatio)
                    .padding(.horizontal, 18 * heightRatio)
                
                Spacer()
                
            }
            .background(Color("Whitebackground"))
        }
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
    var fieldHeightRatio: CGFloat
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>, fieldHeightRatio: CGFloat) {
        self.placeholder = placeholder
        self._text = text
        self.fieldHeightRatio = fieldHeightRatio
    }
    
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                // 간격 7
                .padding(.bottom, fieldHeightRatio * 7)
                
            Rectangle()
                .frame(height: 1) 
                .foregroundColor(Color("Grayunselected"))
        }
    }
}


#Preview {
    AddFriendView()
}
