import SwiftUI

struct WriteJamView: View {
    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    

    var body: some View {
        GeometryReader { geometry in
            let widthRatio = geometry.size.width / screenWidth
            let heightRatio = geometry.size.height / screenHeight
            
            NavigationStack {
                
            }
            .navigationTitle("글 작성하기")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone")
    }
}
