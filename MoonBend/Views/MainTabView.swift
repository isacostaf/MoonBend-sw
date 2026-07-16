import SwiftUI

/// Tab bar principal do app com as 3 abas pedidas no briefing.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Início", systemImage: "house.fill") }

            PosesLibraryView()
                .tabItem { Label("Poses", systemImage: "figure.yoga") }

            SequencesListView()
                .tabItem { Label("Sequências", systemImage: "list.bullet.rectangle") }
        }
        .tint(MoonbendTheme.deepPurple)
    }
}
