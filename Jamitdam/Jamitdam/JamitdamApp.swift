import SwiftUI

@main
struct JamitdamApp: App {
    @StateObject private var relationshipStore = RelationshipStore()
    @StateObject private var postStore = PostStore()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(relationshipStore)
                .environmentObject(postStore)
        }
    }
}
