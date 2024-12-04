import SwiftUI


struct CreateJamView: View {
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 인연이 선택되면 true가 된다.
    @State private var isEnabled: Bool = true

    // 선택된 인연을 표시하기 위한 딕셔너리
    // 인연이 선택되면 인연의 UUID와 boolean 값이 담긴다.
    @State private var selectedStates: [UUID: Bool] = [:]
    
    // 선택된 인연이 담긴 배열
    // 이 페이지에서는 사용되지 않지만 DB에 추가하는 등의 작업이 필요하므로 선택된 인연을 담는 배열을 만든다.
    @State private var selectedRelationships: [Relationship] = []
    
    @State private var navigateToWrite: Bool = false
    @State private var navigateToCreateRelationship: Bool = false
    
    let relationships: [Relationship] = getRelationships()
    
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    

    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
                TopBar(title: "잼얘 생성하기")
                ZStack {
                    Color("BackgroundWhite")
                    VStack {
                        Text("누구와의 일인가요?")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 25 * widthRatio, weight: .semibold))
                        
                        Spacer().frame(height: 3)
                        
                        Text("글의 주인공을 선택해주세요.\n달력에서 주인공을 확인할 수 있어요.")
                            .lineSpacing(3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .font(.system(size: 14 * widthRatio))
                            .foregroundColor(Color("Graybasic"))
                        
                        Spacer().frame(height: 27 * heightRatio)
                        
                        let item = GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 43 * widthRatio)
                        
                        let columns = Array(repeating: item, count: 3)
                        
                        // 인연이 3행을 넘길 때부터 스크롤이 가능하게 하기 위해
                        // 조건부로 ScrollView를 사용
                        // 3행을 넘긴다 -> 인연이 9개 이상이다
                        
                        if relationships.count > 8 {
                            ScrollView{
                                LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                                    
                                    ForEach(relationships, id: \.id) {
                                        relationship in
                                        
                                        // 해당 인연이 선택 되었는지 여부를 나타내는 변수
                                        let isSelected = selectedStates[relationship.id] ?? false
                                        
                                        Button(action: {
                                            // 인연이 선택되면 딕셔너리에 true가 담기고
                                            // 선택된 인연을 다시 선택하면 딕셔너리에 false가 담긴다.
                                            selectedStates[relationship.id] = !isSelected
                                            
                                            // 선택된 인연을 선택 해제하는 경우
                                            if isSelected {
                                                // 인연을 선택된 인연들의 배열에서 제거한다.
                                                selectedRelationships.removeAll() {
                                                    relationship.id == $0.id
                                                }
                                            }
                                            // 선택되지 않은 인연을 선택하는 경우
                                            else {
                                                // 인연을 선택된 인연들의 배열에 추가한다.
                                                selectedRelationships.append(relationship)
                                            }
                                            
                                        }) {
                                            VStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(Color("Redsoftbase"))
                                                        .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                    
                                                    Text(relationship.icon)
                                                        .font(.system(size: 48 * widthRatio))
                                                        .background(
                                                            Circle()
                                                                .fill(Color("Redsoftbase"))
                                                                .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                        )
                                                    
                                                    if isSelected {
                                                        ZStack {
                                                            Image(systemName: "checkmark")
                                                                .resizable()
                                                                .foregroundColor(Color("Whitebackground"))
                                                                .frame(width: 30 * widthRatio, height: 30 * heightRatio)
                                                                .background(
                                                                    Circle()
                                                                        .fill(Color("Redemphasis2"))
                                                                        .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                                )
                                                        }
                                                    }
                                                }
                                                Spacer(minLength: 15 * heightRatio)
                                                Text(relationship.nickname)
                                                    .foregroundStyle(.black)
                                                    .font(.system(.headline))
                                                Spacer(minLength: 43 * heightRatio)
                                            }
                                        }
                                    }
                                    Button(action: {
                                        navigateToCreateRelationship = true
                                    }) {
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color("Grayoutline"))
                                                    .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                Image(systemName: "plus")
                                                    .resizable()
                                                    .foregroundColor(Color("Grayunselected"))
                                                    .frame(width: 40 * widthRatio, height: 40 * widthRatio)
                                                
                                            }
                                            Spacer(minLength: 15 * heightRatio)
                                            Text("")
                                            Spacer(minLength: 43 * heightRatio)
                                        }
                                    }
                                }
                            }.frame(maxHeight: 416 * heightRatio, alignment: .top)
                                .padding(.horizontal)
                        }
                        else {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 0) {
                                
                                ForEach(relationships, id: \.id) {
                                    relationship in
                                    
                                    // 해당 인연이 선택 되었는지 여부를 나타내는 변수
                                    let isSelected = selectedStates[relationship.id] ?? false
                                    
                                    Button(action: {
                                        // 인연이 선택되면 딕셔너리에 true가 담기고
                                        // 선택된 인연을 다시 선택하면 딕셔너리에 false가 담긴다.
                                        selectedStates[relationship.id] = !isSelected
                                        
                                        // 선택된 인연을 선택 해제하는 경우
                                        if isSelected {
                                            // 인연을 선택된 인연들의 배열에서 제거한다.
                                            selectedRelationships.removeAll() {
                                                relationship.id == $0.id
                                            }
                                        }
                                        // 선택되지 않은 인연을 선택하는 경우
                                        else {
                                            // 인연을 선택된 인연들의 배열에 추가한다.
                                            selectedRelationships.append(relationship)
                                        }
                                        
                                    }) {
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color("Redsoftbase"))
                                                    .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                
                                                Text(relationship.icon)
                                                    .font(.system(size: 48 * widthRatio))
                                                    .background(
                                                        Circle()
                                                            .fill(Color("Redsoftbase"))
                                                            .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                    )
                                                
                                                if isSelected {
                                                    ZStack {
                                                        Image(systemName: "checkmark")
                                                            .resizable()
                                                            .foregroundColor(Color("Whitebackground"))
                                                            .frame(width: 30 * widthRatio, height: 30 * heightRatio)
                                                            .background(
                                                                Circle()
                                                                    .fill(Color("Redemphasis2"))
                                                                    .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                                            )
                                                    }
                                                }
                                            }
                                            Spacer(minLength: 15 * heightRatio)
                                            Text(relationship.nickname)
                                                .foregroundStyle(.black)
                                                .font(.system(.headline))
                                            Spacer(minLength: 43 * heightRatio)
                                        }
                                    }
                                }
                                Button(action: {
                                    navigateToCreateRelationship = true
                                
                                }) {
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color("Grayoutline"))
                                                .frame(width: 90 * widthRatio, height: 90 * heightRatio)
                                            Image(systemName: "plus")
                                                .resizable()
                                                .foregroundColor(Color("Grayunselected"))
                                                .frame(width: 40 * widthRatio, height: 40 * widthRatio)
                                            
                                        }
                                        Spacer(minLength: 15 * heightRatio)
                                        Text("")
                                        Spacer(minLength: 43 * heightRatio)
                                    }
                                }
                            }
                            .frame(minHeight: 416 * heightRatio, alignment: .top)
                        }
                        Spacer().frame(height: 50 * heightRatio)
                    
                        
                        NavigationLink(
                            destination: CreateRelationshipView(),
                            isActive: $navigateToCreateRelationship
                        ) {
                            EmptyView()
                        }
                        NavigationLink(destination: WriteJamView(),
                                       isActive: $navigateToWrite) {
                            EmptyView()
                        }
                        RedButton(title: "다음", isEnabled: $isEnabled, height: 55) {
                            if isEnabled {
                                navigateToWrite = true
                            }
                        }
                    }
                
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    CreateJamView()
}
