import SwiftUI

@main
struct JamitdamApp: App {
    @StateObject private var relationshipStore = RelationshipStore()
    var body: some Scene {
        WindowGroup {
            CreateJamView()
                .environmentObject(relationshipStore)
        }
    }
}
