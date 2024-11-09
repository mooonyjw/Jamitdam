
import Foundation
import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    
    // Month update on arrow button clicks
    @State var currentMonth: Int = 0
    
    var body: some View{
        VStack(spacing: 8) {
            // 내 달력
            HStack(spacing: 20) {
                Text("내 달력")
                    .font(.title2.bold())
                    //.frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    withAnimation{
                        
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            
            // 연도, 월, 앞 뒤 버튼
            HStack(spacing: 5) {
                Text(extraDate()[0])
                    .font(.headline)
                    .fontWeight(.bold)
                Text(extraDate()[1])
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing:35) {
                    
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.redemphasis)
                        
                    }
                    Button {
                        withAnimation{
                            currentMonth += 1
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
            
            // Days
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            
            // Day View
            HStack(spacing: 0) {
                ForEach(days, id: \.self){ day in
                    Text(day)
                        .font(.callout)
                        .foregroundColor(.graybasic)
                        .frame(maxWidth: .infinity)
                }
            }
            
            
            // Dates
            // Lazy Grid
            let columns  = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(extractDate()) { value in
                   CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color("Redemphasis"))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        
                        )
                        .onTapGesture {
                            if hasTask(for: value.date) {
                                currentDate = value.date
                            }
                            
                        }
                        .disabled((!hasTask(for: value.date)))
                }
            }
            
            // Tasks
            
            if let postData = posts.first(where: { isSameDay(date1: $0.postDate, date2: currentDate)}) {
                PostDetailView(postData: postData)
                    .padding()
                    .background(Color("Redemphasis").opacity(0.2))
                    .cornerRadius(30)
                    .padding(.top, 16)
                    .frame(maxHeight: .none)
                
            }    
        }
        .ignoresSafeArea(edges:.bottom)
        .onChange(of: currentMonth) { _ in
            // updating Month
            currentDate = getCurrentMonth()
            
        }
    }
                                  
          
func hasTask(for date: Date)->Bool {
    posts.contains{ isSameDay(date1: $0.postDate, date2: date)}
}
                                  
                                  
    @ViewBuilder
    func CardView(value: DateValue)->some View {
        VStack{
         
            if value.day != -1 {
                if let post = posts.first(where: { post in
                    
                    return isSameDay(date1: post.postDate, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: post.postDate, date2: currentDate) ? .white : .primary
                        )
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: post.postDate, date2: currentDate) ? .white : Color("Redemphasis"))
                        .frame(width: 8, height: 8)
                }
                else {
                    
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
        // calendar 여백 조정
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
        
    }
    @ViewBuilder
    func PostDetailView(postData: PostMetaData) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(extraDate()[0]) \(extraDate()[1]) \(Calendar.current.component(.day, from: currentDate))일")
                    .font(.title3.bold())
                Spacer()
                Button("삭제"){
                    // Add delete functionality here
                }
                .foregroundColor(.black)
            }
            
            HStack {
                Text(postData.post.emoji)
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(postData.post.nickname)
                        .font(.callout.bold())
                        
                    Text(postData.post.hashtag)
                        .font(.caption.bold())
                        
                        .foregroundColor(Color("Redemphasis"))
                }
            }
            
            Text("그 날의 글")
                .font(.subheadline)
                .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text(postData.post.title ?? "")
                    .font(.headline)
           
                Text(postData.post.content ?? "")
           
            }
            .padding()
            .background(Color("Whitebackground"))
            .cornerRadius(15)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
        .padding(.top, 10)
        
    }
    
    
    // checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    // extrating Year and Month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        
        let date = formatter.string(from: getCurrentMonth())
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        // Getting Current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        // Getting Current Month Date
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap{date -> DateValue in
            // getting day
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get extra week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}
    
#Preview {
    @State var currentDate = Date()
    return CalendarView(currentDate: $currentDate)
}

// Extending Date to get Current Month Dates
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day-1, to: startDate)!
        }
    }
}
