import Foundation
import SwiftUI

struct CalendarView: View {
    // 캘린더 가져오기

    @State private var selectedDate: Date? = nil
    // 상세보기 표시 여부
    @State private var isDetailViewVisible = false
    // 달력 메뉴
    @State private var isMenuVisible = false
    
    //@State private var selectedCalendar = "내 달력"
    
    @State var displayedCalendar: CalendarData = getCalendar(for: user1, from: dummyCalendars)
    // 달력 유저
    @State var selectedUser: User = user1
    
    var body: some View{
        
        ZStack(alignment: .topLeading) {
            
            if isDetailViewVisible {
                // 배경을 탭하면 팝업 창 닫기
                Color.whitebackground.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isDetailViewVisible = false
                    }
            }
            
            
            
            VStack(spacing: 8) {
                
               
                headerView()
                monthSelector()
                weekHeader()
                dateGrid()
                
                // Posts
                Spacer()
                
                if isDetailViewVisible,
                   let selectedDate = selectedDate, let postData = getPosts(for: selectedUser, from: dummyPosts).first(where: { displayedCalendar.isSameDay(date1: $0.timestamp, date2: selectedDate)}) {
                    PostDetailView(for: selectedDate)
                                   .padding()
                                   .background(Color("Redemphasis").opacity(0.2))
                                   .cornerRadius(30)
                                   .frame(maxHeight: .none)
                                   .transition(.move(edge: .bottom))
                                   .animation(.easeInOut)
                               
                               }
                
                
            }
            .ignoresSafeArea(edges:.bottom)
            
            if isMenuVisible {
                GeometryReader { geometry in
                    CalendarMenuView( isMenuVisible: $isMenuVisible, displayedCalendar: $displayedCalendar, user: selectedUser, selectedUser: $selectedUser)
                        .padding(.horizontal, 8)
                        .padding(.top, 5)
                        
                       
                }
                
            }
        }
    }
                                  
    @ViewBuilder
    func headerView() -> some View {
        // 내 달력
        HStack(spacing: 20) {
            Text("내 달력")
                .font(.title2.bold())
//            Text("\(selectedUser.name) 달력")
//                .font(.title2.bold())
//           
//            Button {
//                withAnimation{
//                    isMenuVisible.toggle()
//                }
//            } label: {
//                Image(systemName: "chevron.down")
//                    .font(.callout)
//                    .foregroundColor(.black)
//            }
            
            Spacer()
            
        }
       
        .padding()
    }
    
    @ViewBuilder
    func monthSelector() -> some View {
        // 연도, 월, 앞 뒤 버튼
        HStack(spacing: 5) {
            Text(displayedCalendar.formattedDate(from: displayedCalendar.getCurrentMonth(), format: "yyyy년"))
                .font(.headline)
                .fontWeight(.bold)
            Text(displayedCalendar.formattedDate(from: displayedCalendar.getCurrentMonth(), format: "MM월"))
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack(spacing:35) {
                
                Button {
                    withAnimation{
                        displayedCalendar.currentMonthOffset -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.redemphasis)
                    
                }
                Button {
                    withAnimation{
                        displayedCalendar.currentMonthOffset += 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.redemphasis)
                    
                }
            }
        }
        
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func weekHeader()->some View {
        // 요일
        let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        HStack(spacing: 0) {
            ForEach(days, id: \.self){ day in
                Text(day)
                    .font(.callout)
                    .foregroundColor(.graybasic)
                    .frame(maxWidth: .infinity)
            }
        }
    }
                                  
    @ViewBuilder
    func dateGrid()->some View {
        // 날짜
        // Lazy Grid
        let columns  = Array(repeating: GridItem(.flexible()), count: 7)
        LazyVGrid(columns: columns, spacing: 15){
            ForEach(displayedCalendar.extractDate()) { value in
               // 날짜에 대한 개별 뷰
                
                CardView(value: value)
                    .onTapGesture {
                        
                        if displayedCalendar.hasPost(for: value.date, from: getPosts(for: selectedUser, from: dummyPosts)){
                            selectedDate = value.date
                            isDetailViewVisible = true
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                // 날짜 텍스트
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(
                        displayedCalendar.isSameDay(date1: value.date, date2: displayedCalendar.currentDate) ? .redemphasis : .primary
                    )
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                // 겹친 동그라미 표시
                let posts = getPosts(for: selectedUser, from: dummyPosts).filter({
                    displayedCalendar.isSameDay(date1: $0.timestamp, date2: value.date)
                })
                if !posts.isEmpty {
                    ZStack {
                        ForEach(0..<min(posts.count, 3), id: \.self) { index in
                            Circle()
                                .fill(Color.redbase)
                                .frame(width: 35, height: 35)
                                .offset(x: CGFloat(index * -5))
                                .shadow(radius: 2)
                            Text(posts[index].relationships[0].icon)
                                .font(.title2)
                                .offset(x: CGFloat(index * -5))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    // post가 있는 날짜의 상세 뷰
    // 해당 날짜의 모든 포스트 가져오기

    @ViewBuilder
    func PostDetailView(for date: Date) -> some View {
        // 해당 날짜의 모든 포스트 가져오기
        let posts = getPosts(for: selectedUser, from: dummyPosts).filter {
            displayedCalendar.isSameDay(date1: $0.timestamp, date2: date)
        }
        
        if !posts.isEmpty {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(posts, id: \.id) { post in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(displayedCalendar.formattedDate(from: post.timestamp, format: "yyyy년 MM월 dd일"))
                                    .font(.title3.bold())
                                Spacer()
                            }
                            
                            HStack {
                                Text(post.relationships[0].icon)
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(post.relationships[0].nickname)
                                        .font(.callout.bold())
                                    Text("#" + post.relationships[0].hashtags[0])
                                        .font(.caption.bold())
                                        .foregroundColor(Color("Redemphasis"))
                                }
                            }
                            
                            Text("그 날의 글")
                                .font(.subheadline)
                                .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(post.title ?? "")
                                    .font(.headline)
                                Text(post.content ?? "")
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding()
                            .background(Color("Whitebackground"))
                            .cornerRadius(15)
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding()
                
            }

            .transition(.move(edge: .bottom))
            .animation(.easeInOut)
        }
    }
}


    
#Preview {
   
    let initialCalendar = getCalendar(for: user1, from: dummyCalendars)
    var displayedCalendar = initialCalendar
    // 기본적으로 본인 사용자로 초기화
    var selectedUser = user1
    
    CalendarView(displayedCalendar: displayedCalendar, selectedUser: selectedUser)
    
}
