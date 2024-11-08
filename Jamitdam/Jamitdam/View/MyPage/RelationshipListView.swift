import SwiftUI
import Foundation

struct RelationshipListView: View {
    
    @State private var user1Relationships: [Relationship] = getRelationships()
    @State private var isShowDeleteAlert = false
    @State private var selectedRelationship: Relationship?
    // 편집 모드 상태
    @State private var isEditing = false
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "인연",
                    backButtonFunc: { print("뒤로 가기 클릭") }
                    //rightButton: "편집",
//                    rightButtonFunc: {
//                        isEditing.toggle()
//                        print("편집 버튼 클릭")
//                    }, rightButtonDisabled: false
                )
                .overlay(
                    HStack {
                        Spacer()
                        
                        Menu {
                            Button("수정") {
                                isEditing.toggle()
                            }
                            Button("삭제") {
                                if let relationship = selectedRelationship {
                                    deleteRelationship(relationship)
                                }
                            }
                        } label: {
                            Text("편집")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.trailing, 21)
                )

                Spacer().frame(height: 9 * heightRatio)
                
                // 인연 리스트
                List {
                    ForEach(user1Relationships) { relationship in
                        RelationshipRow(relationship: relationship, widthRatio: widthRatio, heightRatio: heightRatio)
                            .contextMenu {
                                if isEditing { // 편집 모드일 때만 메뉴 표시
                                    Button(action: {
                                        // 수정 버튼 눌렀을 때 동작
                                        print("수정 \(relationship.nickname)")
                                    }) {
                                        Label("수정", systemImage: "pencil")
                                    }
                                    Button(action: {
                                        // 삭제 버튼 눌렀을 때 동작
                                        selectedRelationship = relationship
                                        isShowDeleteAlert.toggle()
                                    }) {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            // 왼쪽으로 스와이프하여 삭제
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    selectedRelationship = relationship
                                    isShowDeleteAlert.toggle()
                                } label: {
                                    Label("Delete", systemImage: "trash.circle")
                                }
                            }
                    }
                    .onDelete { indexSet in
                        user1Relationships.remove(atOffsets: indexSet)
                    }
                }
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                // 삭제 시 경고창
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

        }
    }

    func deleteRelationship(_ relationship: Relationship) {
        if let index = user1Relationships.firstIndex(where: { $0.id == relationship.id }) {
            user1Relationships.remove(at: index)
        }
    }
}

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
