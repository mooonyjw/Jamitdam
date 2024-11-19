import SwiftUI
import Foundation

struct RelationshipListView: View {
    
    @State private var user1Relationships: [Relationship] = getRelationships()
    @State private var isShowDeleteAlert = false
    @State private var selectedRelationship: Relationship?

    // 편집 모드 상태
    @State private var isEditing = false
    // 수정 페이지로 이동 여부 상태
    @State private var navigateToEdit = false
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "인연",
                    // isEditing이 false일 때는 편집, true일 때는 완료
                    rightButton: isEditing ? "완료" : "편집",
                    // 편집 버튼 누를 시 편집 모드로 전환
                    rightButtonFunc: {
                        isEditing.toggle()
                        print(isEditing ? "편집 모드 활성화" : "편집 모드 비활성화")
                    }
                )

                Spacer().frame(height: 9 * heightRatio)
                
                // 인연 리스트
                List {
                    ForEach(user1Relationships) { relationship in
                        RelationshipRow(relationship: relationship, widthRatio: widthRatio, heightRatio: heightRatio)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if isEditing {
                                    selectedRelationship = relationship
                                    navigateToEdit = true
                                    print("\(relationship.nickname) 수정 페이지로 이동")
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    selectedRelationship = relationship
                                    isShowDeleteAlert.toggle()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete { indexSet in
                        user1Relationships.remove(atOffsets: indexSet)
                    }
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .alert(isPresented: $isShowDeleteAlert) {
                    Alert(
                        title: Text("삭제하시겠습니까?"),
                        message: Text("이 인연을 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            if let relationship = selectedRelationship {
                                deleteRelationship(relationship)
                            }
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            print("인연 추가 버튼 클릭")
                            // 인연 추가 페이지로 이동
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .padding()
                                .background(Color("Redemphasis2"))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            )
        }
    }

    func deleteRelationship(_ relationship: Relationship) {
        if let index = user1Relationships.firstIndex(where: { $0.id == relationship.id }) {
            user1Relationships.remove(at: index)
        }
    }
}

// 인연 리스트의 각 행 커스텀
struct RelationshipRow: View {
    var relationship: Relationship
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    
    var body: some View {
        HStack {
            Spacer().frame(width: 18 * widthRatio)
            
            Text(relationship.icon)
                .font(.system(size: 47 * widthRatio))
                .frame(width: 47 * widthRatio, height: 47 * heightRatio)
            
            Spacer().frame(width: 21 * widthRatio)
            
            Text(relationship.nickname)
                .font(.system(size: widthRatio * 20))
                .foregroundColor(Color.black)
            
            Spacer()
            
            ForEach(relationship.hashtags, id: \.self) { hashtag in
                Text("#" + hashtag)
                    .font(.system(size: 15 * widthRatio))
                    .foregroundColor(Color("Redemphasis"))
            }
            
            Spacer().frame(width: 21 * widthRatio)
        }
        .padding(.vertical, 19 * heightRatio)
        
        
    }
}

#Preview {
    RelationshipListView()
}
