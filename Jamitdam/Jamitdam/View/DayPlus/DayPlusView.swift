
import Foundation
import SwiftUI

struct DayPlusView: View {
    
    @State private var selectedDate = Date()
    //@Binding var selectedRelationship: Relationship?
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 25) {
            // 닫기 편집 버튼
            HStack{
                
                Button(action: {
                    // action 넣기
                }) {
                    Text("닫기")
                        .font(.callout)
                        .foregroundColor(.graybasic)
                        .padding()
                }
                Spacer()
                Button(action: {
                    //action
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
                //DB 에서 가져오기가 아니라 수정 페이지에서 입력한 내용이 들어가도록 수정하기
                Text("🎧")
                    .font(.system(size: 80))
                
                
            }
            
            Text("에어팟")
                .font(.title.bold())
                .padding()
            
            Text("에어팟 님과 \n인연을 시작한 지")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            
            Text("D + 40")
                .font(.largeTitle.bold())
                .foregroundColor(.redlogo)
               
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.redsoftbase)

        
    }
        
    
    
    
}

#Preview {
    
    DayPlusView()
}
