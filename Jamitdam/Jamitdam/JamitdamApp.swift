import SwiftUI

@main
struct JamitdamApp: App {
    @StateObject private var relationshipStore = RelationshipStore()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(relationshipStore)
        }
    }
}
