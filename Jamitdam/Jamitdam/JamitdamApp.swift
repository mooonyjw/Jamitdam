import SwiftUI

@main
struct JamitdamApp: App {
    @StateObject private var navigationState = NavigationState()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(navigationState)
        }
    }
}
