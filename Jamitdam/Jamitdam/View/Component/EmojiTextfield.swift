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
            if string.isEmpty {
                // 삭제를 허용
                parent.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                return true
            } else if string.isSingleEmoji && (textField.text?.count ?? 0) == 0 {
                // 첫 번째 문자로 이모지를 허용
                parent.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                return true
            } else if string.isSingleEmoji && (textField.text?.count ?? 0) > 0 {
                // 두 번째 문자로도 이모지가 입력될 경우 입력을 차단
                return false
            } else {
                // 이모지가 아닌 경우 alert를 띄운다.
                parent.isShowingAlert = true
                return false
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
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
