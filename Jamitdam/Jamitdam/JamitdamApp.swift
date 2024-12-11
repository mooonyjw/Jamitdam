import SwiftUI

@main
struct JamitdamApp: App {
    @StateObject private var relationshipStore = RelationshipStore()
    @StateObject private var navigationState = NavigationState()
    @StateObject private var ddayDataStore = DdayDataStore()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(relationshipStore)
                .environmentObject(navigationState)
                .environmentObject(ddayDataStore)

        }
    }
}
