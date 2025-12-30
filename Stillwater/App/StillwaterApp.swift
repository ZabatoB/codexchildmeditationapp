import SwiftUI

@main
struct StillwaterApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .task {
                    appState.loadContent()
                }
        }
    }
}
