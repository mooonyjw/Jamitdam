import SwiftUI
import Foundation

struct RelationshipListView: View {
    
    @State private var user1Relationships: [Relationship] = getRelationships()
    @State private var isShowDeleteAlert = false
    @State private var selectedRelationship: Relationship?
    
    var screenWidth: CGFloat = 390
    var screenHeight: CGFloat = 844
    
    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            VStack(spacing: 0) {
                
                TopBar(
                    title: "인연",
                    backButtonFunc: { print("뒤로 가기 클릭") },
                    rightButton: "편집",
                    rightButtonDisabled: false
                )
                
                Spacer().frame(height: 9 * heightRatio)
                
                // 인연 리스트
                List {
                    ForEach(user1Relationships) { relationship in
                        RelationshipRow(relationship: relationship, widthRatio: widthRatio, heightRatio: heightRatio)
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
            .navigationBarItems(trailing: EditButton())
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
