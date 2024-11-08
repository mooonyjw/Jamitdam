//
//  RelationshipListView.swift
//  Jamitdam
//
//  Created by sojeong on 11/8/24.
//

import SwiftUI
import Foundation

struct RelationshipListView: View {
    
    @State private var relationships: [Relationship] = user1.relationships
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "인연",
                    backButtonFunc: { print("뒤로 가기 클릭") },
                    rightButton: "편집",
                    rightButtonDisabled: false
                )
                
                Spacer().frame(height: 9 * heightRatio)
                
                ForEach(friends) { friend in
                    RelationshipRow(friend: friend, widthRatio: widthRatio, heightRatio: heightRatio)
                }
                
                Spacer()
            }
        }
    }
}

struct RelationshipRow: View {
    var relationship: Relationship
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var body: some View {
        HStack {
            
            Spacer().frame(width: 18 * widthRatio)
            
            Text("😊") // 이모지 텍스트
                .font(.system(size: 47 * widthRatio)) // 크기 조정
                .frame(width: 47 * widthRatio, height: 47 * heightRatio) // 프레임 크기 조정
                .background(Color.yellow) // 배경 색상
                .clipShape(Circle()) // 원형으로 자르기
            
            Spacer().frame(width: 21 * widthRatio)
            
            Text(relationship.nickname)
                .font(.system(size: widthRatio * 20))
                .foregroundColor(Color.black)
            
            Spacer()
            
            Text(relationship.hashtags[0])
                .font(.system(size: 20 * widthRatio))
                .foregroundColor(Color.black)
            
            
            Spacer().frame(width: 21 * widthRatio)
            
        }
        .padding(.vertical, 19 * heightRatio)
    }
}

#Preview {
    RelationshipListView()
}
