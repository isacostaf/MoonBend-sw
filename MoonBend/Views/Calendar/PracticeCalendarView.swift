import SwiftUI
import SwiftData

/// Aba "Calendário" (tema claro): mostra o mês atual com os dias praticados
/// marcados, navegação entre meses, sequência atual, e uma mensagem no
/// topo confirmando se a usuária já praticou hoje ou não. Toque em
/// qualquer dia marca/desmarca manualmente uma prática.
struct PracticeCalendarView: View {
    @Query private var logs: [PracticeLog]
    @Environment(\.modelContext) private var modelContext
    @State private var displayedMonth: Date = Date()

    private let calendar = Calendar.current
    private let weekdaySymbols = ["D", "S", "T", "Q", "Q", "S", "S"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Calendário")
                        .font(.moonRounded(30, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    VStack(spacing: 16) {
                        statusBanner
                        streakBanner
                        monthNavigator
                        calendarGrid
                        Text("Toque em qualquer dia para marcar ou desmarcar manualmente uma prática.")
                            .font(.moonRounded(12))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 110) // espaço para a pill de navegação não cobrir conteúdo
                }
            }
            .background(MoonbendTheme.creamBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Mensagem "Hoje você já praticou..." / "...ainda não praticou..."
    private var statusBanner: some View {
        Text(practicedToday
             ? "Hoje você já praticou sua aula, muito bem! 🌸"
             : "Hoje você ainda não praticou, vamos praticar! 🌙")
            .font(.moonRounded(19, weight: .bold))
            .foregroundStyle(MoonbendTheme.inkPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(MoonbendTheme.cardWhite)
                    .shadow(color: MoonbendTheme.paleShadow, radius: 12, y: 6)
                    .overlay(alignment: .topTrailing) {
                        if practicedToday {
                            PastelBlob(size: 80)
                                .offset(x: 16, y: -16)
                                .allowsHitTesting(false)
                        }
                    }
            )
    }

    // MARK: - Streak atual
    private var streakBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color(hex: "E7A93C"))
            Text("Sequência atual: \(StreakCalculator.currentStreak(logs: logs, calendar: calendar)) dias")
                .font(.moonRounded(15, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
            Spacer()
            Text("Recorde: \(StreakCalculator.longestStreak(logs: logs, calendar: calendar))")
                .font(.moonRounded(13, weight: .medium))
                .foregroundStyle(MoonbendTheme.inkSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 8, y: 4)
        )
    }

    // MARK: - Navegação entre meses
    private var monthNavigator: some View {
        HStack {
            Button { changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                    .frame(width: 32, height: 32)
            }
            Spacer()
            Text(monthTitle)
                .font(.moonRounded(17, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
            Spacer()
            Button { changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                    .frame(width: 32, height: 32)
            }
        }
    }

    // MARK: - Grade do calendário
    private var calendarGrid: some View {
        VStack(spacing: 14) {
            HStack {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .font(.moonRounded(12, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(Array(daysInGrid.enumerated()), id: \.offset) { _, date in
                    if let date {
                        dayCell(for: date)
                    } else {
                        Color.clear.frame(height: 38)
                    }
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 12, y: 6)
        )
    }

    private func dayCell(for date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let practiced = isPracticed(date)

        return Button {
            togglePractice(for: date)
        } label: {
            Text("\(calendar.component(.day, from: date))")
                .font(.moonRounded(14, weight: practiced ? .bold : .regular))
                .foregroundStyle(practiced ? .white : MoonbendTheme.inkPrimary)
                .frame(width: 38, height: 38)
                .background(
                    Circle().fill(practiced ? AnyShapeStyle(MoonbendTheme.pastelBlobGradient) : AnyShapeStyle(Color.clear))
                )
                .overlay(
                    Circle().stroke(isToday ? MoonbendTheme.inkPrimary.opacity(0.4) : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Helpers

    private var practicedToday: Bool {
        isPracticed(Date())
    }

    private func isPracticed(_ date: Date) -> Bool {
        logs.contains { calendar.isDate($0.day, inSameDayAs: date) }
    }

    /// Marca ou desmarca manualmente um dia como praticado.
    private func togglePractice(for date: Date) {
        if let existing = logs.first(where: { calendar.isDate($0.day, inSameDayAs: date) }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(PracticeLog(day: date))
        }
        try? modelContext.save()
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: displayedMonth).capitalized
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }

    /// Gera a grade completa do mês, incluindo espaços vazios no início
    /// para alinhar corretamente o primeiro dia com seu dia da semana.
    private var daysInGrid: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else {
            return []
        }
        let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth) // 1 = domingo
        let leadingEmptySlots = weekdayOfFirst - 1

        var days: [Date?] = Array(repeating: nil, count: leadingEmptySlots)
        for dayOffset in range {
            if let date = calendar.date(byAdding: .day, value: dayOffset - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }
}
