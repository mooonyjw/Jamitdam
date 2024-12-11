
import Foundation
import SwiftUI

struct DayPlusView: View {
    
    var dday: DdayData

    // 화면 닫기 위해 사용
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        //NavigationStack {
            VStack(alignment: .center, spacing: 25) {
                // 닫기 편집 버튼
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("닫기")
                            .font(.callout)
                            .foregroundColor(.graybasic)
                            .padding()
                    }
                    Spacer()
                    NavigationLink(destination: EditView(userID: dday.userID, editingDday: dday)) {
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
                    Text(dday.relationship.icon)
                        .font(.system(size: 80))
                    
                }
                
                Text(dday.relationship.nickname)
                    .font(.title.bold())
                    .padding()
                
                Text("\(dday.relationship.nickname) 님과 \n인연을 시작한 지")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                if dday.daysSinceStart < 0 {
                    Text("D + 0")
                        .font(.largeTitle.bold())
                        .foregroundColor(.redlogo)
                }
                else { Text("D + \(dday.daysSinceStart)")
                        .font(.largeTitle.bold())
                        .foregroundColor(.redlogo)
                }
                
                
                Spacer()
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.redsoftbase)
            .navigationBarBackButtonHidden(true)
            
        //}
    }

}

#Preview {
    
    //DayPlusView()
    DayPlusView(dday: dday1)
}
