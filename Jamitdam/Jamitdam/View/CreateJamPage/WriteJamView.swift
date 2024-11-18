import SwiftUI

struct WriteJamView: View {
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
    @State private var mentionedRelationshipIDs: [UUID] = []
    
    // 키보드 높이 관리 변수
    @State private var keyboardHeight: CGFloat = 0
    
    // 언급 시 보여줄 인연 목록
    var filteredRelationships: [Relationship] {
        if mentionQuery.isEmpty {
            return relationships
        } else {
            return relationships.filter { $0.nickname.contains(mentionQuery) }
        }
    }
    
    private func insertMention(_ relationship: Relationship) {
        if let range = content.range(of: "@\(mentionQuery)") {
            content.replaceSubrange(range, with: "\(relationship.icon)\(relationship.nickname)")
        }
        isMentioning = false
        mentionQuery = ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // 제목 입력
                        VStack(spacing: 10) {
                            TextField("제목", text: $title, prompt: Text("제목")
                                .font(.system(size: 20)).foregroundColor(Color("Graybasic")))
                                .keyboardType(.default)
                                .frame(height: 40)
                                .font(.system(size: 25, weight: .bold))
                                .padding(.horizontal)
                            
                            Rectangle()
                                .fill(Color("Graybasic"))
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                        
                        // 본문 입력
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                VStack {
                                    Text("본문을 입력해주세요.")
                                        .font(.system(size: 20)).foregroundColor(Color("Graybasic"))
                                        .padding(.leading)
                                        .frame(height: 30)
                                    Spacer()
                                        .frame(height: .infinity)
                                }
                            }
                            MentionTextField(
                                text: $content,
                                isMentioning: $isMentioning,
                                mentionQuery: $mentionQuery,
                                mentionPosition: $mentionPosition,
                                height: $textFieldHeight,
                                maxHeight: 200,
                                fontSize: 20
                            )
                            .padding(.horizontal)
                            .frame(height: textFieldHeight, alignment: .topLeading)
                            .onChange(of: content) { newText in
                                if newText.count > 300 {
                                    content = String(newText.prefix(300))
                                }
                            }
                            if isMentioning {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).fill(Color("Whitebackground"))
                                        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 0)
                                        .frame(width: 170, height: 150)
                                    
                                    ScrollView {
                                        VStack(alignment: .leading) {
                                            ForEach(filteredRelationships, id: \.id) { relationship in
                                                HStack {
                                                    Text(relationship.icon)
                                                        .font(.system(size: 30))
                                                    Text(relationship.nickname)
                                                        .font(.system(size: 20))
                                                        .bold()
                                                }
                                                .onTapGesture {
                                                    insertMention(relationship)
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: 150)
                                }
                                .position(mentionPosition)
                                .padding(.horizontal)
                            }
                            Spacer()
                                .frame(height: .infinity)
                        }
                        .frame(height: 360)
                        
                        // 글자 수 제한 표시
                        Text("\(content.count) / 300")
                            .foregroundColor(Color("Graybasic"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                        
                        // 글 해시태그
                        VStack {
                            Text("글 해시태그")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .font(.system(size: 25, weight: .semibold))
                        }
                    }
                    .padding(.bottom, keyboardHeight) // 키보드 높이 만큼 패딩 추가
                }
            }
            .padding()
            .background(Color("Backgroundwhite").ignoresSafeArea())
            .navigationTitle("글 작성하기")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setupKeyboardObservers()
            }
            .onDisappear {
                removeKeyboardObservers()
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation {
                self.keyboardHeight = 0
            }
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

#Preview {
    WriteJamView()
}
