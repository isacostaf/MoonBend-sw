import SwiftUI
import SwiftData

/// Tela de detalhes de uma sequência: mostra a foto de capa, lista ordenada
/// de poses/descansos e o botão para iniciar a prática.
struct SequenceDetailView: View {
    let sequence: YogaSequence
    @State private var startPractice = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PoseImageView(imageData: sequence.imageData, cornerRadius: 28)
                    .frame(height: 220)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 6) {
                    Text(sequence.name)
                        .font(.moonRounded(24, weight: .bold))
                        .foregroundStyle(MoonbendTheme.deepPurple)
                    Text("\(sequence.poseCount) poses")
                        .font(.moonRounded(14))
                        .foregroundStyle(MoonbendTheme.softGray)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    ForEach(Array(sequence.sortedItems.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: 14) {
                            Text("\(index + 1)")
                                .font(.moonRounded(13, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 26, height: 26)
                                .background(Circle().fill(MoonbendTheme.heroGradient))

                            if item.itemType == .pose, let pose = item.pose {
                                PoseImageView(imageData: pose.imageData, cornerRadius: 12)
                                    .frame(width: 44, height: 44)
                                Text(pose.name)
                                    .font(.moonRounded(15, weight: .medium))
                                    .foregroundStyle(MoonbendTheme.deepPurple)
                            } else {
                                Image(systemName: "wind")
                                    .frame(width: 44, height: 44)
                                    .foregroundStyle(MoonbendTheme.softGray)
                                Text("Descanso / transição")
                                    .font(.moonRounded(15, weight: .medium))
                                    .foregroundStyle(MoonbendTheme.softGray)
                            }

                            Spacer()

                            Text(item.hasTimer ? "\(item.durationSeconds)s" : "Livre")
                                .font(.moonRounded(13, weight: .semibold))
                                .foregroundStyle(MoonbendTheme.lavender)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 16).fill(.white))
                    }
                }
                .padding(.horizontal, 20)

                PrimaryButton(title: "Praticar sequência", icon: "play.fill") {
                    startPractice = true
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
        .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $startPractice) {
            PracticeSequenceView(sequence: sequence)
        }
    }
}
