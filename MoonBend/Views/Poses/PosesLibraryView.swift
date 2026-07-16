import SwiftUI
import SwiftData

/// Aba "Poses": mostra a grade de poses cadastradas (do sistema + criadas
/// pela usuária) e permite adicionar novas.
struct PosesLibraryView: View {
    @Query(sort: \Pose.createdAt) private var poses: [Pose]
    @State private var showAddPose = false

    private let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                if poses.isEmpty {
                    EmptyStateView(
                        icon: "figure.yoga",
                        title: "Nenhuma pose ainda",
                        message: "Adicione sua primeira postura de ioga para começar sua biblioteca."
                    )
                    .padding(.top, 60)
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(poses) { pose in
                            PoseCard(pose: pose)
                        }
                    }
                    .padding(20)
                }
            }
            .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Poses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddPose = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(MoonbendTheme.deepPurple)
                    }
                }
            }
            .sheet(isPresented: $showAddPose) {
                AddPoseView()
            }
        }
    }
}
