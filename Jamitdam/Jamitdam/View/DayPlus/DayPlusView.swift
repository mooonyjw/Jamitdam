
import Foundation
import SwiftUI

struct DayPlusView: View {
    
    // EditView에서 데이터를 전달받도록
    var relationship: Relationship
    var startDate: Date

    
   // 얼마나 지났는지 날짜 계산
    private var daysSinceStart: Int {
        let calendar = Calendar.current
        // 시간제거
        let startOfStartDate = calendar.startOfDay(for: startDate)
        let startOfToday = calendar.startOfDay(for: Date())
        return max(-1, Calendar.current.dateComponents([.day], from: startOfStartDate, to: startOfToday).day ?? 0)
    }
    
    
    // 화면 닫기 위해 사용
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 25) {
            // 닫기 편집 버튼
            HStack{
                
                Button(action: {
                    // action 넣기
                    // 소정이가 만든 마이페이지 화면으로
                }) {
                    Text("닫기")
                        .font(.callout)
                        .foregroundColor(.graybasic)
                        .padding()
                }
                Spacer()
                Button(action: {
                    //action
                    dismiss()
                }) {
                    Text("편집")
                        .font(.callout)
                        .foregroundColor(.graybasic)
                        .padding()
                }
                    
            }
            .padding(.bottom, 80)
            
           
            
            // 하트, 이모지
            ZStack {
                //하트
                Image(systemName: "heart.fill")
                    .font(.system(size: 200))
                    .foregroundColor(.whitebackground)
                
                //이모지
                Text(relationship.icon)
                    .font(.system(size: 80))
                
            }
            
            Text(relationship.nickname)
                .font(.title.bold())
                .padding()
            
            Text("\(relationship.nickname) 님과 \n인연을 시작한 지")
                .font(.title3)
                .multilineTextAlignment(.center)
          
            if daysSinceStart < 0 {
                Text("D + 0")
                    .font(.largeTitle.bold())
                    .foregroundColor(.redlogo)
            }
            else { Text("D + \(daysSinceStart)")
                    .font(.largeTitle.bold())
                    .foregroundColor(.redlogo)
            }
                
               
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.redsoftbase)
        .navigationBarBackButtonHidden(true)
        
        
    }

}

#Preview {
    
    //DayPlusView()
    DayPlusView(
        relationship: tiger,
           startDate: Calendar.current.date(byAdding: .day, value: -40, to: Date())!
       )
}
