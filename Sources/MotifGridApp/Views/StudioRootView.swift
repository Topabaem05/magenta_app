import MotifGridCore
import SwiftUI

struct StudioRootView: View {
  @Bindable var model: StudioModel

  var body: some View {
    VStack(spacing: 0) {
      windowBar
      Group {
        switch model.workspace {
        case .mrt:
          MRTWorkspaceView(model: model)
        case .collider:
          ColliderWorkspaceView(model: model)
        case .jam:
          JamWorkspaceView(model: model)
        }
      }
    }
    .background(MotifTheme.background)
    .fontDesign(.rounded)
    .tint(MotifTheme.mint)
  }

  private var windowBar: some View {
    HStack(spacing: 9) {
      Circle().fill(.red).frame(width: 13, height: 13)
      Circle().fill(.yellow).frame(width: 13, height: 13)
      Circle().fill(.green).frame(width: 13, height: 13)
      Menu {
        ForEach(StudioWorkspace.allCases) { workspace in
          Button(workspace.rawValue) { model.workspace = workspace }
        }
      } label: {
        HStack(spacing: 6) {
          Text(title)
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.white.opacity(0.58))
          Image(systemName: "chevron.down")
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(.white.opacity(0.4))
        }
      }
      Spacer()
      Text("LOCAL DEMO")
        .font(.system(size: 9, weight: .semibold))
        .tracking(1.1)
        .foregroundStyle(MotifTheme.mint.opacity(0.72))
    }
    .padding(.horizontal, 10)
    .frame(height: 32)
    .background(Color(red: 0.12, green: 0.13, blue: 0.14))
    .overlay(alignment: .bottom) { Rectangle().fill(MotifTheme.border).frame(height: 1) }
  }

  private var title: String {
    model.workspace == .mrt ? "MRT2" : "MRT2 - \(model.workspace.rawValue)"
  }
}
