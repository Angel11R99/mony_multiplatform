import SwiftUI
import WidgetKit

private let widgetAppGroup = "group.com.example.monyMultiplatform.widgets"
private let snapshotKey = "finance_widget_snapshot_v1"

private enum FinanceWidgetKind: String {
  case finance = "FinanceWidget"
  case incomeExpense = "IncomeExpenseWidget"
  case budgetProgress = "BudgetProgressWidget"
  case statistics = "StatisticsWidget"
  case recentMovements = "RecentMovementsWidget"
  case pendingReminders = "PendingRemindersWidget"
  case savingsGoals = "SavingsGoalsWidget"
  case fixedCommitments = "FixedCommitmentsWidget"
  case quickAccess = "QuickAccessWidget"
  case dailySpending = "DailySpendingWidget"
  case categoryLimits = "CategoryLimitsWidget"

  var title: String {
    switch self {
    case .finance: "Balance y registro rápido"
    case .incomeExpense: "Ingresos vs gastos"
    case .budgetProgress: "Uso del presupuesto"
    case .statistics: "Estadísticas"
    case .recentMovements: "Movimientos recientes"
    case .pendingReminders: "Pagos y cobros pendientes"
    case .savingsGoals: "Metas de ahorro"
    case .fixedCommitments: "Compromisos fijos"
    case .quickAccess: "Accesos rápidos"
    case .dailySpending: "Gasto de hoy"
    case .categoryLimits: "Límites por categoría"
    }
  }

  var destination: URL {
    let path: String
    switch self {
    case .finance, .quickAccess: path = "/transactions/new?type=expense"
    case .budgetProgress: path = "/budgets"
    case .statistics: path = "/statistics"
    case .recentMovements: path = "/transactions"
    case .pendingReminders: path = "/obligations"
    case .savingsGoals: path = "/savings-goals"
    case .fixedCommitments: path = "/recurring"
    case .incomeExpense, .dailySpending, .categoryLimits: path = "/"
    }
    let marker = path.contains("?") ? "&homeWidget" : "?homeWidget"
    return URL(string: "mony://\(path)\(marker)")!
  }
}

private struct FinanceWidgetEntry: TimelineEntry {
  let date: Date
  let snapshot: [String: Any]?
}

private struct FinanceWidgetProvider: TimelineProvider {
  func placeholder(in context: Context) -> FinanceWidgetEntry {
    FinanceWidgetEntry(date: Date(), snapshot: nil)
  }

  func getSnapshot(in context: Context, completion: @escaping (FinanceWidgetEntry) -> Void) {
    completion(readEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<FinanceWidgetEntry>) -> Void) {
    let entry = readEntry()
    completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(30 * 60))))
  }

  private func readEntry() -> FinanceWidgetEntry {
    let json = UserDefaults(suiteName: widgetAppGroup)?.string(forKey: snapshotKey)
    let snapshot = json.flatMap { value -> [String: Any]? in
      guard let data = value.data(using: .utf8) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
    return FinanceWidgetEntry(date: Date(), snapshot: snapshot)
  }
}

private struct FinanceWidgetView: View {
  let entry: FinanceWidgetEntry
  let kind: FinanceWidgetKind

  @Environment(\.colorScheme) private var systemColorScheme
  @Environment(\.widgetFamily) private var family

  private var data: [String: Any] { entry.snapshot ?? [:] }
  private var isDark: Bool {
    switch data["themeMode"] as? String {
    case "dark": true
    case "light": false
    default: systemColorScheme == .dark
    }
  }
  private var background: Color { isDark ? Color(red: 0.12, green: 0.11, blue: 0.14) : Color.white }
  private var foreground: Color { isDark ? Color(red: 0.96, green: 0.94, blue: 0.97) : Color(red: 0.13, green: 0.11, blue: 0.15) }
  private var secondary: Color { isDark ? Color(red: 0.78, green: 0.76, blue: 0.80) : Color(red: 0.42, green: 0.39, blue: 0.44) }
  private var primary: Color { Color(argb: integer("primaryColorArgb", fallback: 0xff6750a4)) }
  private var accent: Color { Color(argb: integer("accentColorArgb", fallback: 0xffe57269)) }
  private var compact: Bool { family == .systemSmall }

  var body: some View {
    widgetContent.widgetBackground(background)
  }

  private var widgetContent: some View {
    VStack(alignment: .leading, spacing: compact ? 5 : 8) {
      Text(kind.title.uppercased())
        .font(.system(size: 10, weight: .bold))
        .foregroundStyle(primary)
        .lineLimit(1)
      if entry.snapshot == nil {
        Text("Abre Mony para sincronizar tus datos.")
          .font(.caption)
          .foregroundStyle(secondary)
      } else {
        content
      }
      Spacer(minLength: 0)
    }
    .padding(compact ? 12 : 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(background)
    .widgetURL(kind.destination)
    .privacySensitive()
  }

  @ViewBuilder
  private var content: some View {
    switch kind {
    case .finance:
      amountBlock("Disponible", money(integer("availableInCents")), size: compact ? 19 : 24)
      Text("Balance del ciclo: \(money(integer("balanceInCents")))")
        .font(.system(size: 10)).foregroundStyle(secondary).lineLimit(1)
      quickButtons
    case .incomeExpense:
      amountBlock("Ingresos", money(integer("incomeInCents")), color: primary)
      amountBlock("Gastos", money(integer("expenseInCents")), color: accent)
      Text("Ciclo actual").font(.system(size: 10)).foregroundStyle(secondary)
    case .budgetProgress:
      if integer("budgetInCents", fallback: -1) <= 0 {
        empty("Configura un presupuesto en Mony.")
      } else {
        Text("\(integer("usagePercent"))% usado · \(integer("daysLeft")) días restantes")
          .font(.system(size: 12, weight: .medium)).foregroundStyle(foreground)
        ProgressView(value: min(max(Double(integer("usagePercent")) / 100, 0), 1))
          .tint(primary)
        Text("\(money(integer("expenseInCents"))) de \(money(integer("budgetInCents")))")
          .font(.system(size: 10)).foregroundStyle(secondary)
      }
    case .statistics:
      amountBlock("Balance del ciclo", money(integer("balanceInCents")), size: compact ? 18 : 22)
      Text(expenseComparison)
        .font(.system(size: 10)).foregroundStyle(secondary).lineLimit(2)
      Text("\(money(integer("incomeInCents"))) ingresos · \(money(integer("expenseInCents"))) gastos")
        .font(.system(size: 9)).foregroundStyle(primary).lineLimit(1)
    case .recentMovements:
      let items = objects("recentMovements").prefix(compact ? 2 : family == .systemMedium ? 3 : 5)
      if items.isEmpty { empty("Todavía no hay movimientos") }
      ForEach(Array(items.enumerated()), id: \.offset) { element in
        let item = element.element
        line(item["title"] as? String ?? "Movimiento", signedMoney(item))
      }
    case .pendingReminders:
      Text("Por pagar  \(money(integer("pendingToPayInCents")))")
        .font(.system(size: 12, weight: .medium)).foregroundStyle(accent)
      Text("Por cobrar  \(money(integer("pendingToCollectInCents")))")
        .font(.system(size: 12, weight: .medium)).foregroundStyle(primary)
      let items = objects("pendingItems").prefix(compact ? 1 : family == .systemMedium ? 2 : 4)
      if items.isEmpty { empty("No tienes pendientes activos") }
      ForEach(Array(items.enumerated()), id: \.offset) { element in
        let item = element.element
        line(item["title"] as? String ?? "Pendiente", money(item["amountInCents"] as? Int ?? 0))
      }
    case .savingsGoals:
      let goals = objects("savingsGoals")
      if let goal = goals.first {
        Text(goal["name"] as? String ?? "Meta de ahorro")
          .font(.system(size: 13, weight: .medium)).foregroundStyle(foreground).lineLimit(1)
        ProgressView(value: min(max(Double(goal["percent"] as? Int ?? 0) / 100, 0), 1)).tint(primary)
        Text("\(money(integer("savedInCents"))) ahorrados de \(money(integer("savingsTargetInCents")))")
          .font(.system(size: 10)).foregroundStyle(secondary).lineLimit(1)
      } else { empty("Crea una meta para ver tu progreso.") }
    case .fixedCommitments:
      Text("\(money(integer("fixedExpenseInCents"))) gastos · \(money(integer("fixedIncomeInCents"))) ingresos")
        .font(.system(size: 10, weight: .medium)).foregroundStyle(foreground).lineLimit(1)
      let items = objects("fixedEntries").prefix(compact ? 1 : family == .systemMedium ? 2 : 4)
      if items.isEmpty { empty("No tienes movimientos recurrentes activos.") }
      ForEach(Array(items.enumerated()), id: \.offset) { element in
        let item = element.element
        line(item["title"] as? String ?? "Movimiento", signedMoney(item))
      }
    case .quickAccess:
      quickButtons
    case .dailySpending:
      amountBlock("Gastado hoy", money(todayExpense), size: compact ? 19 : 22)
      if let allowance = dailyAllowance {
        Text("Ritmo diario  \(money(allowance))")
          .font(.system(size: 11, weight: .medium)).foregroundStyle(todayExpense > allowance ? accent : primary)
        ProgressView(value: allowance <= 0 ? 1 : min(Double(todayExpense) / Double(allowance), 1))
          .tint(primary)
      } else { empty("Configura un presupuesto para ver tu ritmo diario.") }
    case .categoryLimits:
      let categories = objects("categoryLimits").prefix(compact ? 1 : family == .systemMedium ? 2 : 4)
      if categories.isEmpty { empty("Agrega límites a tus categorías de gasto.") }
      ForEach(Array(categories.enumerated()), id: \.offset) { element in
        let category = element.element
        let spent = category["spentInCents"] as? Int ?? 0
        let limit = category["limitInCents"] as? Int ?? 0
        VStack(alignment: .leading, spacing: 2) {
          line(category["name"] as? String ?? "Categoría", "\(money(spent)) de \(money(limit))")
          ProgressView(value: limit <= 0 ? 0 : min(Double(spent) / Double(limit), 1))
            .tint(spent > limit ? accent : primary)
        }
      }
    }
  }

  private var quickButtons: some View {
    HStack(spacing: 6) {
      Link(destination: URL(string: "mony:///transactions/new?type=expense&homeWidget")!) {
        Text("+ Gasto").font(.system(size: 11, weight: .semibold))
          .frame(maxWidth: .infinity).padding(.vertical, 7)
          .background(primary, in: Capsule()).foregroundStyle(.white)
      }
      Link(destination: URL(string: "mony:///transactions/new?type=income&homeWidget")!) {
        Text("+ Ingreso").font(.system(size: 11, weight: .semibold))
          .frame(maxWidth: .infinity).padding(.vertical, 7)
          .background(isDark ? Color.white.opacity(0.12) : Color.black.opacity(0.06), in: Capsule())
          .foregroundStyle(foreground)
      }
    }
  }

  private func amountBlock(_ label: String, _ value: String, color: Color? = nil, size: CGFloat = 20) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(label).font(.system(size: 10)).foregroundStyle(secondary)
      Text(value).font(.system(size: size, weight: .bold)).foregroundStyle(color ?? foreground).lineLimit(1).minimumScaleFactor(0.75)
    }
  }

  private func line(_ label: String, _ value: String) -> some View {
    HStack(spacing: 6) {
      Text(label).font(.system(size: 10)).foregroundStyle(foreground).lineLimit(1)
      Spacer(minLength: 3)
      Text(value).font(.system(size: 10, weight: .medium)).foregroundStyle(secondary).lineLimit(1)
    }
  }

  private func empty(_ message: String) -> some View {
    Text(message).font(.system(size: 11)).foregroundStyle(secondary).lineLimit(2)
  }

  private func objects(_ key: String) -> [[String: Any]] { data[key] as? [[String: Any]] ?? [] }
  private func integer(_ key: String, fallback: Int = 0) -> Int { data[key] as? Int ?? fallback }
  private func money(_ cents: Int) -> String {
    let absolute = cents.magnitude
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    let whole = formatter.string(from: NSNumber(value: absolute / 100)) ?? "0"
    let fraction = String(format: "%02llu", UInt64(absolute % 100))
    let prefix = data["currencyStyle"] as? String == "code" ? "DOP " : "RD$"
    return (cents < 0 ? "−" : "") + prefix + whole + "." + fraction
  }
  private func signedMoney(_ item: [String: Any]) -> String {
    let amount = item["amountInCents"] as? Int ?? 0
    return ((item["isIncome"] as? Bool ?? false) ? "+" : "−") + money(amount)
  }
  private var todayExpense: Int {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd"
    let today = formatter.string(from: Date())
    return String(data["createdAt"] as? String ?? "").prefix(10) == today ? integer("todayExpenseInCents") : 0
  }
  private var dailyAllowance: Int? {
    let budget = integer("budgetInCents", fallback: -1)
    guard budget > 0, let periodEnd = data["periodEnd"] as? String else { return nil }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd"
    guard let end = formatter.date(from: periodEnd) else { return nil }
    let today = Calendar.current.startOfDay(for: Date())
    let endDay = Calendar.current.startOfDay(for: end)
    let days = max(Calendar.current.dateComponents([.day], from: today, to: endDay).day ?? 0, 0) + 1
    return (budget - integer("expenseInCents")) / days
  }
  private var expenseComparison: String {
    let previous = integer("previousExpenseInCents", fallback: -1)
    guard previous > 0 else { return "Sin comparación con el ciclo anterior" }
    let percent = (integer("expenseInCents") - previous) * 100 / previous
    let arrow = percent > 0 ? "↑" : percent < 0 ? "↓" : "="
    return "\(arrow) \(abs(percent))% en gastos frente al ciclo anterior"
  }
}

private extension View {
  @ViewBuilder
  func widgetBackground(_ color: Color) -> some View {
    if #available(iOS 17.0, *) {
      containerBackground(for: .widget) { color }
    } else {
      background(color)
    }
  }
}

private extension Color {
  init(argb: Int) {
    self.init(
      .sRGB,
      red: Double((argb >> 16) & 0xff) / 255,
      green: Double((argb >> 8) & 0xff) / 255,
      blue: Double(argb & 0xff) / 255,
      opacity: Double((argb >> 24) & 0xff) / 255,
    )
  }
}

private struct FinanceWidget: Widget {
  let kind: FinanceWidgetKind

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind.rawValue, provider: FinanceWidgetProvider()) { entry in
      FinanceWidgetView(entry: entry, kind: kind)
    }
    .configurationDisplayName(kind.title)
    .description("Consulta tus datos financieros y accede a Mony.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

@main
struct MonyWidgetsBundle: WidgetBundle {
  var body: some Widget {
    FinanceWidget(kind: .finance)
    FinanceWidget(kind: .incomeExpense)
    FinanceWidget(kind: .budgetProgress)
    FinanceWidget(kind: .statistics)
    FinanceWidget(kind: .recentMovements)
    FinanceWidget(kind: .pendingReminders)
    FinanceWidget(kind: .savingsGoals)
    FinanceWidget(kind: .fixedCommitments)
    FinanceWidget(kind: .quickAccess)
    FinanceWidget(kind: .dailySpending)
    FinanceWidget(kind: .categoryLimits)
  }
}
