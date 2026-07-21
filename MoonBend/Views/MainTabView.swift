import SwiftUI

/// Tab bar principal do app. A barra nativa do sistema fica escondida —
/// usamos só a pill de navegação clara (réplica da referência visual),
/// fixa e global, para que todas as abas tenham exatamente o mesmo padrão
/// visual de navegação, sem duplicar barras.
struct MainTabView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tag(0)

                PosesLibraryView()
                    .tag(1)

                SequencesListView()
                    .tag(2)

                PracticeCalendarView()
                    .tag(3)
            }
            .toolbar(.hidden, for: .tabBar)

            LightFloatingNavBar(
                active: selectedTab,
                onHome: { selectedTab = 0 },
                onPoses: { selectedTab = 1 },
                onCalendar: { selectedTab = 3 },
                onSequences: { selectedTab = 2 }
            )
            .padding(.horizontal, 40)
            .padding(.bottom, 14)
        }
        .tint(MoonbendTheme.inkPrimary)
    }
}
