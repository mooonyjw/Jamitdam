import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var color: Color = .black
    // 외부에서 버튼을 누를 시 일어날 action 전달
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.backward")
                .renderingMode(.template)
                .foregroundColor(Color("Black"))
                .shadow(radius: 2.0)
                .contentShape(Rectangle())
        }
    }
}
