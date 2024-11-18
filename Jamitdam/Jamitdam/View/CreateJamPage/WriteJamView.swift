import SwiftUI

struct WriteJamView: View {
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    // 글 제목
    @State private var title: String = ""
    // 글 본문
    @State private var content: String = ""
    
    // 현재 언급 중인지를 나타내는 변수
    @State private var isMentioning: Bool = false
    // @ 뒤에 오는 글자로 누구를 언급하는지 필터링하기 위한 변수
    @State private var mentionQuery: String = ""
    // 언급이 나타날 위치
    @State private var mentionPosition: CGPoint = .zero
    
    // 본문 텍스트 필드의 공간을 동적으로 조정하기 위한 변수, 기본 값은 30
    @State private var textFieldHeight: CGFloat = 30
    
    // 언급 목록에 보일 더미 변수
    let relationships = getRelationships()
    
    // 언급된 인연 id 목록
    // 글 작성 버튼 누를 시 글 내용 분석하여 추가
    @State private var mentionedRelationshipIDs: [UUID] = []
    
    // 언급 시 보여줄 인연 목록
    var filteredRelationships: [Relationship] {
        // @만 입력하면 인연 목록 전체를 보여준다
        if mentionQuery.isEmpty {
            return relationships
        }
        // @ 뒤에 이름 입력시 이름에 해당하는 인연을 보여준다
        else {
            print(mentionQuery)
            return relationships.filter{ $0.nickname.contains(mentionQuery) }
        }
    }
    
    private func insertMention(_ relationship: Relationship) {
        // @와 쿼리를 관계의 이모지 + 닉네임으로 대체
        if let range = content.range(of: "@\(mentionQuery)") {
            content.replaceSubrange(range, with: "\(relationship.icon)\(relationship.nickname)")
        }
        // 멘션 종료
        isMentioning = false
        mentionQuery = ""
    }

    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            // 본문 창의 최대 높이
            let maxContentHeight = heightRatio * 200
            
            NavigationStack {
                ZStack {
                    Color("Backgroundwhite")
                    VStack {
                        // 제목 입력 란
                        VStack {
                            TextField("title", text: $title, prompt: Text("제목")
                                .font(.system(size: 20 * widthRatio)).foregroundColor(Color("Graybasic")))
                            .keyboardType(.default)
                            .frame(width: .infinity, height: 20 * heightRatio)
                            .font(.system(size: 25 * widthRatio, weight: .bold))
                            .padding(.horizontal)
                            
                            Rectangle()
                                .fill(Color("Graybasic"))
                                .frame(width: .infinity, height: 1)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        
                        // 본문 입력 란
                        VStack {
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("본문을 입력해주세요.")
                                        .font(.system(size: 20 * widthRatio)).foregroundColor(Color("Graybasic"))
                                        .padding(.leading)
                                }
                                MentionTextField(text: $content, isMentioning: $isMentioning, mentionQuery: $mentionQuery, mentionPosition: $mentionPosition, height: $textFieldHeight, maxHeight: maxContentHeight, fontSize: 20 * widthRatio)
                                    .padding(.horizontal)
                                    .frame(height: textFieldHeight)
                                    .onChange(of: content) { newText in
                                        if newText.count > 300 {
                                            content = String(newText.prefix(300))
                                        }
                                    }
                            }
                            
                            // 언급창 줄바꿈 시마다 높이 바뀌는거 해결하기
                            
                            if isMentioning {
                                ZStack() {
                                    RoundedRectangle(cornerRadius: 10).fill(Color("Whitebackground"))
                                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 0)
                                    .frame(width: 170 * widthRatio, height: 150 * heightRatio)
                                    
                                    ScrollView {
                                        VStack(alignment: .leading) {
                                            ForEach(filteredRelationships, id: \.id) { relationship in
                                                HStack{
                                                    Text(relationship.icon)
                                                        .font(.system(size: 30 * widthRatio))
                                                    Text(relationship.nickname)
                                                        .font(.system(size: 20 * widthRatio))
                                                        .bold()
                                                }
                                                .onTapGesture {
                                                    insertMention(relationship)
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: 150 * heightRatio)
                                }
                                .position(mentionPosition)
                                .padding(.horizontal)
                            }
                        }
                        .frame(height: 360 * heightRatio, alignment: .top)
                        
                        Text("\(content.count) / 300")
                            .foregroundColor(Color("Graybasic"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                        
                        // 글 해시태그
                        VStack {
                            Text("글 해시태그")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.system(size: 25 * widthRatio, weight: .semibold))
                            
                        }
                    }
                }
                .navigationTitle("글 작성하기")
                .navigationBarTitleDisplayMode(.inline)
            }

        }
    }
}

#Preview {
    WriteJamView()
}
