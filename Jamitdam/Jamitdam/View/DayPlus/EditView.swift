
import Foundation
import SwiftUI

struct EditView: View {
    @State private var nickname : String = ""
    @State private var emoji : String = ""
    @State private var selectedDate = Date()
    
    @State private var selectedID: UUID?
    @State private var selectedRelationship: Relationship?
    let relationships: [Relationship] = getRelationships()
    
    
    var body: some View {
        
        Button (action: {
            //action
        }) {
            Text("완료")
                .foregroundColor(.graybasic)
            
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 25)
        
        Spacer()
        
        VStack(spacing: 20) {
                         
        
            
            // 내 인연을 클릭
            Text("누구와의 디데이인가요?")
                .font(.title2.bold())
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20) {
                    ForEach(relationships, id: \.id) {
                        relationship in
                        
                        // 해당 인연이 선택 되었는지 여부를 나타내는 변수
                        let isSelected = selectedID == relationship.id
                        
                        Button(action: {
                            // 단일 선택 동작: 동일한 버튼 클릭 시 선택 해제
                            selectedID = isSelected ? nil : relationship.id
                            
                
                        }) {
                            VStack(spacing: 8) {
                                // 아이콘 영역
                                ZStack {
                                    Circle()
                                        .fill(Color("Redsoftbase"))
                                        .frame(width: 50, height: 50)
                                    
                                    Text(relationship.icon)
                                        .font(.system(size: 30))
                                    
                                    if isSelected {
                                        ZStack {
                                            Circle()
                                                .fill(Color("Redemphasis2"))
                                                .frame(width:50, height: 50)
                                                .opacity(0.7)
                                            
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color("Whitebackground"))
                                                .frame(width: 20, height: 20)
                                                .bold()
                                
                                        }
                                        
                                    }
                                }
                                .padding(.bottom, 5)
                                
                                // 닉네임 영역
                                Text(relationship.nickname)
                                    .foregroundStyle(.black)
                                    .font(.system(size:14))
                                    .frame(maxWidth: 70)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                
                              
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            .padding(.bottom, 100)
            
            DatePicker("인연을 시작한 날짜", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal, 25)
                .font(.system(size: 18))
                //.labelsHidden()
        }
        Spacer()
    }
    
    
    
}

#Preview {
    EditView()
}
