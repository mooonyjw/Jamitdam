import SwiftUI

public struct RedButton: View {
    let title: String
    // 외부에서 버튼을 활성화시키기 위한 조건을 만족 시킬 시 true를 전달
    @Binding var isEnabled: Bool
    // 외부에서 버튼을 누를 시 일어날 action 전달
    let action: () -> Void
    // 버튼 크기
    let height: CGFloat
    
    public init(title: String, isEnabled: Binding<Bool>, height: CGFloat, action: @escaping () -> Void) {
        self.title = title
        self._isEnabled = isEnabled
        self.action = action
        self.height = height
    }
    
    public var body: some View {
        Button(action: {
            // 버튼이 활성화 상태일 때만 action 수행
            if isEnabled {
                action()
            }
        }) {
            Text(title)
                .font(.system(.title3, weight: .semibold))
                .padding(.leading)
                .padding(.trailing)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(isEnabled ? Color("Redlogo") : Color("Grayunselected"))
                .foregroundColor(Color("Whitebackground"))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 0)
        }
        .disabled(!isEnabled)
        .padding(.horizontal)
    }
}