//
//  BlockedFriendListView.swift
//  Jamitdam
//
//  Created by sojeong on 11/7/24.
//

import SwiftUI
import Foundation

struct BlockedFriendListView: View {
    @State private var blockedFriendIDs: [String] = ["john123", "jane456"]
    
    var body: some View {
        TopBar(
            title: "차단된 친구",
            backButtonFunc: { print("뒤로 가기 클릭") }
        )
        
        Spacer()
        
        
    }
}

#Preview {
    BlockedFriendListView()
}
