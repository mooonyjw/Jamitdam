import SwiftUI
import UIKit

struct EmojiTextfield: UIViewRepresentable {
    @Binding var text: String
    
    @Binding var isShowingAlert: Bool
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        // 특정 사이즈로 지정
        textField.font = UIFont.systemFont(ofSize: 60)
        textField.textAlignment = .center
        textField.delegate = context.coordinator
        textField.keyboardType = .default
        textField.returnKeyType = .done
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextfield

        init(_ parent: EmojiTextfield) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 이모지나 삭제를 허용하고, 이모지가 한 글자 이상 입력되지 않도록 설정
            if string.isEmpty || (string.isSingleEmoji && (textField.text?.count ?? 0) == 0) {
                parent.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                return true
            }
            // 한 글자 이상의 입력을 허용하지 않음
            // 이모지가 아닌 경우 alert를 띄운다.
            parent.isShowingAlert = true
            return false
        }
    }
}

extension String {
    // 문자열이 단일 이모지인지 확인
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    
    // 문자열이 이모지를 포함하고 있는지 확인
    var containsEmoji: Bool {
        return unicodeScalars.first(where: { $0.properties.isEmojiPresentation }) != nil
    }
}
