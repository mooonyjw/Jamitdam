import SwiftUI


struct CreateJamView: View {
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 인연이 선택되면 true가 된다.
    @State private var isFocused: Bool = false
    
    let relationships: [Relationship] = getRelationships()
    
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    
    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            NavigationStack{
                ZStack {
                    Color("BackgroundWhite")
                    VStack {
                        Text("누구와의 일인가요?")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 25 * widthRatio, weight: .semibold))
                        
                        Spacer().frame(height: 3)
                        
                        
                        Text("글의 주인공 한 명을 선택해주세요.\n달력에서 주인공을 확인할 수 있어요.")
                            .lineSpacing(3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 14 * widthRatio))
                            .foregroundColor(Color("Graybasic"))
            
                        
                            
                        Spacer().frame(height: 27 * heightRatio)
                        
                        let item = GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 43 * widthRatio)
                        
                        let columns = Array(repeating: item, count: 3)
                        
                        LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                            ForEach(relationships, id: \.id) {
                                relationship in
                                VStack{
                                    Text(relationship.icon)
                                        .font(.system(size: 48 * widthRatio))
                                        .background(
                                            Circle()
                                                .fill(Color("Redsoftbase"))
                                                .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                
                                        )
                                    Spacer(minLength: 15 * heightRatio)
                                    Text(relationship.nickname)
                                        .font(.system(.headline))
                                    Spacer(minLength: 43 * heightRatio)
                                    }
                                
                                }

                        }
                        
                        Spacer().frame(height: 203 * heightRatio)
                        
                    }

                    

                }.navigationTitle("잼얘 생성하기")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        }

    }
    
}


#Preview {
    CreateJamView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
}
