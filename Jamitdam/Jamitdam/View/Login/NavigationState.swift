import SwiftUI
import Combine

class NavigationState: ObservableObject {
    
    @Published var navigateToLogin = false

    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @Published var navigateToHome = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @Published var navigateToRegister = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @Published var navigateToSearchID = false
    
    // 화면 전환을 위한 boolean
    // 시작하기가 선택되면 true가 된다.
    @Published var navigateToSearchPW = false
    
    @Published var navigateToNickname = false
    
    @Published var isLoggedIn = false

    
}
