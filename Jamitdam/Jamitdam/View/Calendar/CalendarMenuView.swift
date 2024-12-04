
import Foundation
import SwiftUI

import SwiftUI

struct CalendarMenuView: View {
    @Binding var isMenuVisible: Bool
    @Binding var displayedCalendar: CalendarData
    
    // 원래 사용자
    var user: User
    // 선택된 사용자 업데이트
    @Binding var selectedUser: User
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    isMenuVisible = false
                    selectedUser = user
                    displayedCalendar = CalendarData(UserID: user.id, currentDate: Date(), posts: getPosts(for: user, from: dummyPosts))
                }) {
                    HStack {
                        Text("내 달력")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                        
                        Spacer()
                    
                        Image(systemName: "chevron.up")
                            .foregroundColor(.black)
                       
                    }
                    .frame(width: 163)
                   
                }
                
                // 친구가 많아지면 스크롤 뷰로 나타내기
                
                if user.friends.count>2 {
                    ScrollView {
                        FriendsListView(user: user, isMenuVisible: $isMenuVisible, displayedCalendar: $displayedCalendar, selectedUser: $selectedUser)
                            
                    }
                    .frame(width: 170)
                    .frame(maxHeight: 110)
                   
                } else {
                    FriendsListView(user: user, isMenuVisible: $isMenuVisible, displayedCalendar: $displayedCalendar, selectedUser: $selectedUser)
                        .frame(width: 170)
                        
                }

               
            }
            .padding()
            .background(Color.white)

            .cornerRadius(10)
            .shadow(radius: 10)
            .zIndex(1)
    }
  
}

// 친구 목록을 별도로 분리하여 ScrollView와 VStack에서 모두 재사용 가능
struct FriendsListView: View {
    //  원래 사용자
    var user: User
  
    @Binding var isMenuVisible: Bool
    @Binding var displayedCalendar: CalendarData
    @Binding var selectedUser: User

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(user.friends) { friend in
                Button(action: {
     
                        selectedUser = friend
                        displayedCalendar = getCalendar(for: friend, from: dummyCalendars)
                  
                        isMenuVisible = false
       
                }) {
                    HStack {
                        Text("\(friend.name) 달력")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        Image(friend.profile)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}


#Preview {
    let user1Calendar = dummyCalendars.first(where: {$0.userID == user1.id}) ?? CalendarData(UserID: user1.id, currentDate: Date(), posts: getPosts(for: user1, from: dummyPosts))
    @State var displayedCalendar = user1Calendar
    @State var selectedUser = user1
    
    CalendarMenuView( isMenuVisible: .constant(true), displayedCalendar: $displayedCalendar, user:user1, selectedUser: $selectedUser)
    
}
