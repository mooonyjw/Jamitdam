import Foundation
import SwiftUI

struct CreateVoteView: View {
    @State private var title: String = ""
    @State private var content: String = ""
    // 두 개의 기본 항목 제공
    @State private var options: [String] = ["", ""]
    @State private var multipleChoice: Bool = false
    @State private var anonymousVote: Bool = false
    @State private var allowOptionAddition: Bool = false
    @State private var notifyBeforeEnd: Bool = false
    @State private var showTooltip: Bool = false
    //@State private var isEnabled: Bool = false
    
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    private var isEnabled: Bool {
        // 제목, 내용, 투표 항목 2개가 비어있지 않은 경우에만 활성화
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !content.trimmingCharacters(in: .whitespaces).isEmpty &&
        options.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count >= 2
    }
    
    
    var body: some View {
        // TopBar
        TopBar(
            title: "투표 생성하기"
        )
        GeometryReader { geometry in
            
            VStack {
                // 항목 추가 시, 화면이 길어질 것을 대비해서 스크롤 뷰로 작성
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // 제목 입력 받기
                        HStack(){
                            Text("제목")
                                .font(.headline)
                            Text("*")
                                .font(.subheadline)
                                .foregroundColor(.redemphasis)
                        }
                        .padding(.horizontal)
                        
                        TextField("제목을 입력해 주세요.", text: $title)
                            .padding()
                            .frame(height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        // 내용 입력 받기
                        HStack(){
                            Text("내용")
                                .font(.headline)
                            Text("*")
                                .font(.subheadline)
                                .foregroundColor(.redemphasis)
                        }
                        .padding(.horizontal)
                        
                        ZStack(alignment: .topLeading){
                            
                            TextEditor(text: $content)
                                .padding(.horizontal, 13)
                                .frame(height: 100)
                            
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            
                            if content.isEmpty{
                                Text("내용을 입력해 주세요.")
                                    .foregroundColor(Color(.placeholderText))
                                    .font(.body)
                                    .padding(.horizontal, 33)
                                    .padding(.top, 8)
                                
                            }
                            
                        }
                        
                        // 투표 항목 입력
                        VStack() {
                            // 동적으로 추가
                            ForEach($options.indices, id: \.self){
                                index in
                                TextField("항목 입력", text: $options[index])
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                options.append("")
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("항목 추가")
                                }
                                .padding(.top, 5)
                                .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        
                        // 토글
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("복수선택", isOn: $multipleChoice)
                                .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                            Toggle("익명투표", isOn: $anonymousVote)
                                .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                            Toggle("선택항목 추가 허용", isOn: $allowOptionAddition)
                                .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                            HStack(alignment: .center, spacing: 5){
                                VStack{
                                    Button(action:{
                                        withAnimation{
                                            showTooltip.toggle()
                                        }
                                    }) {
                                        Image(systemName: "questionmark.circle")
                                            .foregroundColor(.gray)
                                        //.frame(width: 20, height: 20)
                                        
                                    }
                                    .overlay(
                                        HStack(spacing: 110) {
                                            Spacer()
                                            VStack(spacing: 80) {
                                                Spacer()
                                                
                                                HStack {
                                                    Text("투표 종료 30분 전, 알림을 보내드립니다.")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .lineLimit(nil)
                                                    
                                                    Button(action: {
                                                        showTooltip = false
                                                    }) {
                                                        Image(systemName: "xmark")
                                                            .foregroundColor(.gray)
                                                            .font(.caption)
                                                    }
                                                }
                                                .padding(8)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(radius: 5)
                                                .frame(width: 200)
                                                .opacity(showTooltip ? 1 : 0)
                                                .offset(y: -85)
                                            }
                                        }
                                    )
                                }
                                
                                Toggle("투표 종료 전 알림 받기", isOn: $notifyBeforeEnd)
                                    .padding(.leading, 5)
                                    .toggleStyle(SwitchToggleStyle(tint: Color("Redemphasis2")))
                            }
                        }
                        .padding()
                    }
                    .padding(.top)
                }
            }
                RedButton(title: "완료", isEnabled: .constant(isEnabled), height: 55){
                    // action
                    print("완료 버튼이 선택됨")
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden(true)
            
        
    }
}


#Preview {
    CreateVoteView()
}
