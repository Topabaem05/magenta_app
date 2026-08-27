import SwiftUI

@main
struct MotifGridApp: App {
  @State private var model = StudioModel()

  var body: some Scene {
    WindowGroup {
      StudioRootView(model: model)
        .preferredColorScheme(.dark)
        .persistentSystemOverlays(.hidden)
    }
  }
}
