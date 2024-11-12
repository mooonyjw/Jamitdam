import SwiftUI

struct SplashView: View {
    
    // 하단의 다음 버튼을 활성화시키기 위한 boolean
    // 해당 화면에서는 항상 true로 유지된다.
    @State private var isEnabled: Bool = true
    
    // 애니메이션 시작을 위한 boolean
    // onAppear가 호출되면서 true로 변경된다.
    @State private var isAnimating = false
    
    // 타 애니메이션 시작을 위한 boolean
    // 2초 지연 후 true로 변경되며 다른 UI 요소에 애니메이션이 적용된다.
    @State private var isVisible = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @State private var navigateToLogin = false

    // 반응형 레이아웃을 위해 아이폰14의 너비, 높이를 나누어주기 위해 변수 사용
    let screenWidth: CGFloat = 390
    let screenHeight: CGFloat = 844
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                                
                let width = geometry.size.width
                let height = geometry.size.height

                let heightRatio = geometry.size.height / screenHeight

                let heartSize : CGFloat = isAnimating ? 280 : 245
                
                ZStack {
                    Color("Whitebackground").ignoresSafeArea()
                    
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .blur(radius: 15)
                        .frame(width: heartSize, height: heartSize)
                        .foregroundColor(Color("Redbase"))
                        .position(x: width / 2, y: height / 2)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatCount(5),
                            value: isAnimating
                        )
                    
                    Text("지금 가장\n잇한 이야기")
                        .font(.title.bold())
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 1.2), value: isVisible)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: width / 2 - heartSize / 2, y: -(heartSize / 2) - 50)
                    
                    Text("잼잇담")
                        .font(.system(size: 40, weight: .bold))
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 1.2), value: isVisible)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(x: width / 2 + 30, y: +(heartSize / 2) + 30)
                    
                    VStack {
                        Image("Logo_word")
                            .opacity(isVisible ? 1 : 0)
                            .animation(.easeOut(duration: 1.2), value: isVisible)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                        Spacer()
                        
                        // 시작하기 버튼이 눌리면 Login 화면으로 이동한다.
                        RedButton(title: "시작하기", isEnabled: $isEnabled, height: 55) {
                            navigateToLogin = true
                        }
                        .opacity(isVisible ? 1 : 0)
                        .animation(.easeOut(duration: 1.2), value: isVisible)
                        .padding(.bottom, 70 * heightRatio)
                    }
                }
                .onAppear {
                    isAnimating = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isVisible = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLogin){
                Login()
            }
        }
    }
}

#Preview {
    SplashView()
}
