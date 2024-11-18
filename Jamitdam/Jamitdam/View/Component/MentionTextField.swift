import UIKit
import SwiftUI

struct MentionTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isMentioning: Bool
    @Binding var mentionQuery: String
    @Binding var mentionPosition: CGPoint
    @Binding var height: CGFloat
    var maxHeight: CGFloat
    var fontSize: CGFloat
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        DispatchQueue.main.async {
            let fittingSize = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.greatestFiniteMagnitude))
            let calculatedHeight = fittingSize.height
            // maxHeight 초과하는 것을 방지
            self.height = min(calculatedHeight, maxHeight)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MentionTextField
        
        init(_ parent: MentionTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            guard let cursorPosition = textView.selectedTextRange?.start else { return }
            
            // 커서의 CGRect 가져오기
             let caretRect = textView.caretRect(for: cursorPosition)

            // 전역 좌표로 변환
            if let superview = textView.superview {
                let globalCaretRect = textView.convert(caretRect, to: superview)

                // 스크롤 오프셋 및 텍스트 컨테이너 인셋 반영
                let contentOffsetY = textView.contentOffset.y
                let insetY = textView.textContainerInset.top

                // mentionPosition 계산
                self.parent.mentionPosition = CGPoint(
                    x: globalCaretRect.midX,
                    y: globalCaretRect.origin.y - contentOffsetY + insetY + caretRect.height + 5
                )
            }
            
            // 멘션 상태 및 쿼리 업데이트
            if let lastChar = textView.text.last {
                if lastChar == "@" {
                    // 마지막 입력이 "@"라면 멘션 시작
                    parent.isMentioning = true
                    parent.mentionQuery = ""
                } else if lastChar == " " {
                    // 마지막 입력이 띄어쓰기라면 멘션 종료
                    parent.isMentioning = false
                    parent.mentionQuery = ""
                } else if let range = textView.text.range(of: "@", options: .backwards) {
                    // 마지막 `@` 이후의 텍스트를 기반으로 `mentionQuery`를 업데이트
                    let queryAfterLastAt = String(textView.text[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                    parent.mentionQuery = queryAfterLastAt
                    parent.isMentioning = !queryAfterLastAt.isEmpty
                } else {
                    // `@`가 없으면 멘션 종료
                    parent.isMentioning = false
                    parent.mentionQuery = ""
                }
            } else {
                // 텍스트가 비어 있는 경우 멘션 종료
                parent.isMentioning = false
                parent.mentionQuery = ""
            }
        }

    }
    
}
