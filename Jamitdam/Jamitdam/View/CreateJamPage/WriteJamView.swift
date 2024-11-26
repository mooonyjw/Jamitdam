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
    
    // 사용자의 해시태그 입력
    @State private var hashtagContent: String = ""
    // 완전히 입력된 하나의 해시태그
    @State private var hashtag: String = ""
    // 입력된 해시태그들
    @State private var hashtags: [String] = []
    // 해시태그 작성 중인지 여부
    @State private var isEditing: Bool = false
    // 해시태그 작성 필드 활성화 여부
    @State private var isTextFieldEnabled: Bool = true
    
    // 사용자가 불러온 이미지 배열. 최대 10개까지 추가 가능
    @State private var selectedImages: [UIImage] = []
    // 이미지 선택 화면 표시 여부
    @State private var isImagePickerPresented: Bool = false
    // 선택한 이미지
    @State private var selectedImage: UIImage?
    
    // 언급 시 보여줄 인연 목록
    var filteredRelationships: [Relationship] {
        if mentionQuery.isEmpty {
            return relationships
        } else {
            return relationships.filter { $0.nickname.contains(mentionQuery) }
        }
    }
    
    private func insertHashtags() {
        if !hashtagContent.isEmpty {
            let sanitizedHashtag = hashtagContent.trimmingCharacters(in: .whitespacesAndNewlines)
                // 공백을 "_"로 변환
                .replacingOccurrences(of: " ", with: "_")
            // 입력 필드 초기화
            hashtagContent = ""
            // 변환된 해시태그 추가
            hashtags.append(sanitizedHashtag)
            // 수정 상태 종료
            isEditing = false
        }
        isTextFieldEnabled = hashtags.count >= 2 ? false : true
    }
    
    private func removeHashtag(at index: Int) {
        hashtags.remove(at: index)
        isEditing = false
        isTextFieldEnabled = hashtags.count >= 2 ? false : true
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
            TopBar(title: "글 작성하기")
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // 본문 입력
                        ZStack(alignment: .topLeading) {
                            VStack {
                                // 제목 입력
                                VStack(spacing: 10) {
                                    TextField("제목", text: $title, prompt: Text("제목")
                                        .font(.system(size: 20)).foregroundColor(Color("Graybasic")))
                                        .keyboardType(.default)
                                        .frame(height: 40)
                                        .font(.system(size: 25, weight: .bold))
                                        .padding(.top)
                                    
                                    Rectangle()
                                        .fill(Color("Graybasic"))
                                        .frame(height: 1)
                                        .ignoresSafeArea(edges: .horizontal)
                                }
                                ZStack {
                                    if content.isEmpty {
                                        Text("본문을 입력해주세요.")
                                            .font(.system(size: 20)).foregroundColor(Color("Graybasic"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.horizontal, 4)
                                    }
                                    MentionTextField(
                                        text: $content,
                                        isMentioning: $isMentioning,
                                        mentionQuery: $mentionQuery,
                                        mentionPosition: $mentionPosition,
                                        height: $textFieldHeight,
                                        maxHeight: 250,
                                        fontSize: 20
                                    )
                                    .frame(height: textFieldHeight)
                                    .onChange(of: content) { newText in
                                        if newText.count > 300 {
                                            content = String(newText.prefix(300))
                                        }
                                    }
                                }
                                if isMentioning {
                                    GeometryReader { geometry in
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10).fill(Color("Whitebackground"))
                                            
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
                                        .offset(x: mentionPosition.x, y: mentionPosition.y) // `offset`으로 위치 조정
                                        
                                        
                                    }
                                }
                                Spacer()
                                .frame(maxHeight: .infinity)

                            }
                        }
                        .frame(height: 360)
                        
                        // 이미지
                        if !selectedImages.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(selectedImages.indices, id: \.self) { index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedImages[index])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(10)

                                            Button(action: {
                                                // 이미지 삭제
                                                selectedImages.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.redemphasis)
                                                    .background(Circle().fill(Color.white))
                                            }
                                            .offset(x: -5, y: 5)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(selectedImages.count < 10 ? Color("Redemphasis2") : Color.gray)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .disabled(selectedImages.count >= 10)
                            .onTapGesture {
                                print("Tapped outside button")
                            }
                        }
                        
                        // 글자 수 제한 표시
                        Text("\(content.count) / 300")
                            .foregroundColor(Color("Graybasic"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        // 글 해시태그
                        VStack {
                            HStack(spacing: 10) {
                                Text("글 해시태그")
                                    .font(.system(size: 25, weight: .semibold))
                                
                                Text("최대 2개까지 작성할 수 있어요.")
                                    .foregroundColor(Color("Graybasic"))
                                    .font(.system(size: 12))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack {
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 10).fill(Color("Redsoftbase"))
                                        .shadow(color: Color.black.opacity(0), radius: 15, x: 0, y: 0)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                    
                                    VStack {
                                        HStack {
                                            Text("#")
                                                .font(.system(size: 14))
                                            
                                            TextField("title", text: $hashtagContent, prompt: Text("여기를_눌러서_해시태그를_추가해보아요.")
                                                .font(.system(size: 14))
                                                .foregroundColor(Color("Graybasic")))
                                            .font(.system(size: 18, weight: .semibold))
                                            .onSubmit {
                                                insertHashtags()
                                            }
                                            .frame(alignment: .leading)
                                            .disabled(!isTextFieldEnabled)
                                        }
                                        .padding(.top)
                                        
                                        if !hashtags.isEmpty {
                                            ScrollView(.horizontal) {
                                                HStack {
                                                    ForEach(hashtags.indices, id: \.self) { index in
                                                        HStack {
                                                            Text("#")
                                                                .font(.system(size: 18, weight: .semibold))
                                                            Text(hashtags[index])
                                                                .font(.system(size: 18, weight: .semibold))
                                                            Button(action: {
                                                                removeHashtag(at: index)
                                                            }) {
                                                                Image(systemName: "xmark")
                                                                    .foregroundColor(Color("Graybasic"))
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(width: .infinity, height: 50)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    // 키보드 높이 만큼 패딩 추가
                    .padding(.bottom, keyboardHeight)
                }

            }
            .padding()
            .background(Color("Whitebackground").ignoresSafeArea())
            //.navigationTitle("글 작성하기")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setupKeyboardObservers()
            }
            .onDisappear {
                removeKeyboardObservers()
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
                    .onChange(of: selectedImage) { newImage in
                        if let image = newImage, selectedImages.count < 10 {
                            selectedImages.append(image)
                            selectedImage = nil
                        }
                    }
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
