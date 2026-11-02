package com.example.mony_multiplatform.widgets

import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.LocalSize
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.appwidget.cornerRadius
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.state.GlanceStateDefinition
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver
import com.example.mony_multiplatform.MainActivity
import org.json.JSONArray
import org.json.JSONObject
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.time.LocalDate
import java.util.Locale

private const val SNAPSHOT_KEY = "finance_widget_snapshot_v1"

enum class FinanceWidgetType {
    FINANCE,
    INCOME_EXPENSE,
    BUDGET_PROGRESS,
    STATISTICS,
    RECENT_MOVEMENTS,
    PENDING_REMINDERS,
    SAVINGS_GOALS,
    FIXED_COMMITMENTS,
    QUICK_ACCESS,
    DAILY_SPENDING,
    CATEGORY_LIMITS,
}

class FinanceGlanceWidget(private val type: FinanceWidgetType) : GlanceAppWidget() {
    override val stateDefinition: GlanceStateDefinition<*> = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val state = currentState<HomeWidgetGlanceState>()
            FinanceWidgetContent(context, type, parseSnapshot(state.preferences.getString(SNAPSHOT_KEY, null)))
        }
    }
}

private data class WidgetPalette(
    val surface: ColorProvider,
    val ink: ColorProvider,
    val muted: ColorProvider,
    val primary: ColorProvider,
    val accent: ColorProvider,
    val track: ColorProvider,
)

@Composable
private fun FinanceWidgetContent(context: Context, type: FinanceWidgetType, snapshot: JSONObject?) {
    val size = LocalSize.current
    val systemDark = context.resources.configuration.uiMode and
        android.content.res.Configuration.UI_MODE_NIGHT_MASK ==
        android.content.res.Configuration.UI_MODE_NIGHT_YES
    val dark = when (snapshot?.optString("themeMode")) {
        "dark" -> true
        "light" -> false
        else -> systemDark
    }
    val fallbackSurface = if (dark) 0xFF211F24.toInt() else 0xFFFFFBFF.toInt()
    val fallbackInk = if (dark) 0xFFF3EFF4.toInt() else 0xFF201B20.toInt()
    val fallbackMuted = if (dark) 0xFFCAC4D0.toInt() else 0xFF625D66.toInt()
    val primaryArgb = snapshot?.optInt("primaryColorArgb", 0xFF6750A4.toInt()) ?: 0xFF6750A4.toInt()
    val accentArgb = snapshot?.optInt("accentColorArgb", 0xFFE57269.toInt()) ?: 0xFFE57269.toInt()
    val palette = WidgetPalette(
        surface = ColorProvider(Color(if (dark) fallbackSurface else 0xFFFFFFFF.toInt())),
        ink = ColorProvider(Color(fallbackInk)),
        muted = ColorProvider(Color(fallbackMuted)),
        primary = ColorProvider(Color(primaryArgb)),
        accent = ColorProvider(Color(accentArgb)),
        track = ColorProvider(Color(if (dark) 0xFF45414A.toInt() else 0xFFE9E4EC.toInt())),
    )

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .cornerRadius(20.dp)
            .background(palette.surface)
            .padding(14.dp),
    ) {
        Text(
            text = type.title,
            style = TextStyle(color = palette.primary, fontSize = 11.sp, fontWeight = FontWeight.Bold),
            maxLines = 1,
        )
        Spacer(GlanceModifier.height(5.dp))
        if (snapshot == null) {
            Text("Abre Mony para sincronizar tus datos.", style = TextStyle(color = palette.muted, fontSize = 12.sp), maxLines = 2)
        } else {
            when (type) {
                FinanceWidgetType.FINANCE -> financeContent(context, snapshot, palette)
                FinanceWidgetType.INCOME_EXPENSE -> incomeExpenseContent(snapshot, palette)
                FinanceWidgetType.BUDGET_PROGRESS -> budgetContent(snapshot, palette, size.width - 28.dp)
                FinanceWidgetType.STATISTICS -> statisticsContent(snapshot, palette)
                FinanceWidgetType.RECENT_MOVEMENTS -> movementsContent(snapshot, palette, size.height)
                FinanceWidgetType.PENDING_REMINDERS -> pendingContent(snapshot, palette, size.height)
                FinanceWidgetType.SAVINGS_GOALS -> savingsContent(snapshot, palette, size.width - 28.dp)
                FinanceWidgetType.FIXED_COMMITMENTS -> fixedContent(snapshot, palette, size.height)
                FinanceWidgetType.QUICK_ACCESS -> quickAccessContent(context, palette)
                FinanceWidgetType.DAILY_SPENDING -> dailyContent(snapshot, palette, size.width - 28.dp)
                FinanceWidgetType.CATEGORY_LIMITS -> categoryLimitContent(snapshot, palette, size.height)
            }
        }
    }
}

@Composable
private fun financeContent(context: Context, data: JSONObject, palette: WidgetPalette) {
    WidgetAmount("Disponible", available(data), palette.ink, 20)
    Text("Balance del ciclo: ${money(data, "balanceInCents")}", style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 1)
    Spacer(GlanceModifier.height(8.dp))
    quickButtons(context, palette)
}

@Composable
private fun incomeExpenseContent(data: JSONObject, palette: WidgetPalette) {
    WidgetAmount("Ingresos", money(data, "incomeInCents"), palette.primary, 17)
    WidgetAmount("Gastos", money(data, "expenseInCents"), palette.accent, 17)
    Text("Ciclo ${date(data.optString("periodStart"))} – ${date(data.optString("periodEnd"))}", style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 1)
}

@Composable
private fun budgetContent(data: JSONObject, palette: WidgetPalette, width: androidx.compose.ui.unit.Dp) {
    val budget = data.optLong("budgetInCents", -1L)
    if (budget <= 0L) {
        Text("Configura un presupuesto en Mony.", style = TextStyle(color = palette.muted, fontSize = 12.sp), maxLines = 2)
        return
    }
    val usage = data.optInt("usagePercent", 0)
    Text("$usage% usado · ${data.optInt("daysLeft")} días restantes", style = TextStyle(color = palette.ink, fontSize = 13.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    WidgetProgress(usage / 100f, width, palette.primary, palette.track)
    Text("${money(data, "expenseInCents")} de ${money(data, "budgetInCents")}", style = TextStyle(color = palette.muted, fontSize = 11.sp), maxLines = 1)
}

@Composable
private fun statisticsContent(data: JSONObject, palette: WidgetPalette) {
    WidgetAmount("Balance del ciclo", money(data, "balanceInCents"), palette.ink, 19)
    val previous = data.optLong("previousExpenseInCents", -1L)
    val current = data.optLong("expenseInCents", 0L)
    val comparison = if (previous <= 0L) "Sin comparación anterior" else {
        val percent = ((current - previous) * 100 / previous).toInt()
        val direction = when {
            percent > 0 -> "↑"
            percent < 0 -> "↓"
            else -> "="
        }
        "$direction ${kotlin.math.abs(percent)}% en gastos frente al ciclo anterior"
    }
    Text(comparison, style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 2)
    Text("${money(data, "incomeInCents")} ingresos · ${money(data, "expenseInCents")} gastos", style = TextStyle(color = palette.primary, fontSize = 10.sp), maxLines = 1)
}

@Composable
private fun movementsContent(data: JSONObject, palette: WidgetPalette, height: androidx.compose.ui.unit.Dp) {
    val items = data.optJSONArray("recentMovements") ?: JSONArray()
    if (items.length() == 0) return WidgetEmpty("Todavía no hay movimientos", palette.muted)
    val count = if (height > 150.dp) 4 else 2
    for (index in 0 until minOf(items.length(), count)) {
        val item = items.optJSONObject(index) ?: continue
        WidgetLine(
            label = item.optString("title"),
            value = signedMoney(data, item.optBoolean("isIncome"), item.optLong("amountInCents")),
            palette = palette,
            valueColor = if (item.optBoolean("isIncome")) palette.primary else palette.ink,
        )
    }
}

@Composable
private fun pendingContent(data: JSONObject, palette: WidgetPalette, height: androidx.compose.ui.unit.Dp) {
    Text("Por pagar ${money(data, "pendingToPayInCents")}", style = TextStyle(color = palette.accent, fontSize = 13.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    Text("Por cobrar ${money(data, "pendingToCollectInCents")}", style = TextStyle(color = palette.primary, fontSize = 13.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    val items = data.optJSONArray("pendingItems") ?: JSONArray()
    if (items.length() == 0) return WidgetEmpty("No tienes pendientes activos", palette.muted)
    val count = if (height > 150.dp) 3 else 1
    for (index in 0 until minOf(items.length(), count)) {
        val item = items.optJSONObject(index) ?: continue
        val due = item.optString("dueDate").takeIf(String::isNotBlank)?.let(::date) ?: "Sin fecha"
        Text("${item.optString("title")} · $due", style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 1)
    }
}

@Composable
private fun savingsContent(data: JSONObject, palette: WidgetPalette, width: androidx.compose.ui.unit.Dp) {
    val goals = data.optJSONArray("savingsGoals") ?: JSONArray()
    if (goals.length() == 0) return WidgetEmpty("Crea una meta para ver tu progreso.", palette.muted)
    val goal = goals.optJSONObject(0) ?: return
    Text(goal.optString("name"), style = TextStyle(color = palette.ink, fontSize = 14.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    WidgetProgress(goal.optInt("percent") / 100f, width, palette.primary, palette.track)
    Text("${money(data, "savedInCents")} ahorrados de ${money(data, "savingsTargetInCents")}", style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 1)
}

@Composable
private fun fixedContent(data: JSONObject, palette: WidgetPalette, height: androidx.compose.ui.unit.Dp) {
    Text("${money(data, "fixedExpenseInCents")} gastos · ${money(data, "fixedIncomeInCents")} ingresos", style = TextStyle(color = palette.ink, fontSize = 11.sp), maxLines = 1)
    val entries = data.optJSONArray("fixedEntries") ?: JSONArray()
    if (entries.length() == 0) return WidgetEmpty("No tienes movimientos recurrentes activos.", palette.muted)
    val count = if (height > 150.dp) 3 else 1
    for (index in 0 until minOf(entries.length(), count)) {
        val item = entries.optJSONObject(index) ?: continue
        WidgetLine(item.optString("title"), signedMoney(data, item.optBoolean("isIncome"), item.optLong("amountInCents")), palette, palette.ink)
    }
}

@Composable
private fun quickAccessContent(context: Context, palette: WidgetPalette) = quickButtons(context, palette)

@Composable
private fun dailyContent(data: JSONObject, palette: WidgetPalette, width: androidx.compose.ui.unit.Dp) {
    val spent = todayExpense(data)
    val allowance = todayAllowance(data)
    WidgetAmount("Gastado hoy", money(data, spent), palette.ink, 19)
    if (allowance == null) {
        Text("Ritmo diario disponible al configurar un presupuesto.", style = TextStyle(color = palette.muted, fontSize = 10.sp), maxLines = 2)
    } else {
        Text("Ritmo diario ${money(data, allowance)}", style = TextStyle(color = if (spent > allowance) palette.accent else palette.primary, fontSize = 11.sp), maxLines = 1)
        WidgetProgress(if (allowance <= 0L) 1f else spent.toFloat() / allowance, width, palette.primary, palette.track)
    }
}

@Composable
private fun categoryLimitContent(data: JSONObject, palette: WidgetPalette, height: androidx.compose.ui.unit.Dp) {
    val categories = data.optJSONArray("categoryLimits") ?: JSONArray()
    if (categories.length() == 0) return WidgetEmpty("Agrega límites a tus categorías de gasto.", palette.muted)
    val count = if (height > 150.dp) 4 else 2
    for (index in 0 until minOf(categories.length(), count)) {
        val category = categories.optJSONObject(index) ?: continue
        Column {
            Text(category.optString("name"), style = TextStyle(color = palette.ink, fontSize = 11.sp, fontWeight = FontWeight.Medium), maxLines = 1)
            Text("${money(data, category.optLong("spentInCents"))} de ${money(data, category.optLong("limitInCents"))}", style = TextStyle(color = palette.muted, fontSize = 9.sp), maxLines = 1)
        }
        WidgetProgress(
            category.optLong("spentInCents").toFloat() / category.optLong("limitInCents", 1L).coerceAtLeast(1L),
            LocalSize.current.width - 28.dp,
            if (category.optLong("spentInCents") > category.optLong("limitInCents")) palette.accent else palette.primary,
            palette.track,
        )
    }
}

@Composable
private fun quickButtons(context: Context, palette: WidgetPalette) {
    Row(modifier = GlanceModifier.fillMaxWidth(), verticalAlignment = Alignment.Vertical.CenterVertically) {
        WidgetAction("+ Gasto", "mony:///transactions/new?type=expense&homeWidget", palette, true, GlanceModifier.defaultWeight(), context)
        Spacer(GlanceModifier.width(8.dp))
        WidgetAction("+ Ingreso", "mony:///transactions/new?type=income&homeWidget", palette, false, GlanceModifier.defaultWeight(), context)
    }
}

@Composable
private fun WidgetAction(label: String, uri: String, palette: WidgetPalette, emphasize: Boolean, modifier: GlanceModifier, context: Context) {
    val background = if (emphasize) palette.primary else palette.track
    val foreground = if (emphasize) palette.surface else palette.ink
    Box(
        modifier = modifier.height(34.dp).cornerRadius(17.dp).background(background)
            .clickable(actionStartActivity<MainActivity>(context, Uri.parse(uri))),
        contentAlignment = Alignment.Center,
    ) {
        Text(label, style = TextStyle(color = foreground, fontSize = 12.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    }
}

@Composable
private fun WidgetAmount(label: String, value: String, color: ColorProvider, size: Int) {
    Text(label, style = TextStyle(color = color, fontSize = 10.sp), maxLines = 1)
    Text(value, style = TextStyle(color = color, fontSize = size.sp, fontWeight = FontWeight.Bold), maxLines = 1)
}

@Composable
private fun WidgetLine(label: String, value: String, palette: WidgetPalette, valueColor: ColorProvider) {
    Row(modifier = GlanceModifier.fillMaxWidth(), horizontalAlignment = Alignment.Horizontal.SpaceBetween) {
        Text(label, style = TextStyle(color = palette.ink, fontSize = 10.sp), maxLines = 1, modifier = GlanceModifier.defaultWeight())
        Text(value, style = TextStyle(color = valueColor, fontSize = 10.sp, fontWeight = FontWeight.Medium), maxLines = 1)
    }
}

@Composable
private fun WidgetProgress(fraction: Float, width: androidx.compose.ui.unit.Dp, fill: ColorProvider, track: ColorProvider) {
    val safeWidth = width.coerceAtLeast(40.dp)
    Box(
        modifier = GlanceModifier.padding(vertical = 5.dp).width(safeWidth).height(7.dp).cornerRadius(4.dp).background(track),
        contentAlignment = Alignment.CenterStart,
    ) {
        Spacer(GlanceModifier.width(safeWidth * fraction.coerceIn(0f, 1f)).height(7.dp).cornerRadius(4.dp).background(fill))
    }
}

@Composable
private fun WidgetEmpty(message: String, color: ColorProvider) {
    Text(message, style = TextStyle(color = color, fontSize = 11.sp), maxLines = 2)
}

private fun parseSnapshot(value: String?): JSONObject? = try {
    value?.let(::JSONObject)
} catch (_: Exception) {
    null
}

private fun money(data: JSONObject, amount: Long): String {
    val symbols = DecimalFormatSymbols(Locale.US)
    val absolute = kotlin.math.abs(amount)
    val whole = DecimalFormat("#,##0", symbols).format(absolute / 100L)
    val fraction = (absolute % 100L).toString().padStart(2, '0')
    val number = "$whole.$fraction"
    val currency = if (data.optString("currencyStyle") == "code") "DOP " else "RD\$"
    return (if (amount < 0) "−" else "") + currency + number
}

private fun money(data: JSONObject, key: String): String = money(data, data.optLong(key))
private fun signedMoney(data: JSONObject, income: Boolean, amount: Long): String =
    (if (income) "+" else "−") + money(data, amount)

private fun available(data: JSONObject): String = money(data, data.optLong("availableInCents"))

private fun todayExpense(data: JSONObject): Long =
    if (data.optString("createdAt").take(10) == LocalDate.now().toString()) data.optLong("todayExpenseInCents") else 0L

private fun todayAllowance(data: JSONObject): Long? {
    val budget = data.optLong("budgetInCents", -1L)
    if (budget <= 0L) return null
    val end = runCatching { LocalDate.parse(data.optString("periodEnd")) }.getOrNull() ?: return null
    val days = (end.toEpochDay() - LocalDate.now().toEpochDay() + 1).coerceAtLeast(1L)
    val remaining = budget - data.optLong("expenseInCents")
    return remaining / days
}

private fun date(value: String): String = runCatching {
    val parsed = LocalDate.parse(value)
    "${parsed.dayOfMonth.toString().padStart(2, '0')}/${parsed.monthValue.toString().padStart(2, '0')}"
}.getOrDefault(value)

private val FinanceWidgetType.title: String
    get() = when (this) {
        FinanceWidgetType.FINANCE -> "MONY · DISPONIBLE"
        FinanceWidgetType.INCOME_EXPENSE -> "INGRESOS VS GASTOS"
        FinanceWidgetType.BUDGET_PROGRESS -> "PRESUPUESTO"
        FinanceWidgetType.STATISTICS -> "RESUMEN DEL CICLO"
        FinanceWidgetType.RECENT_MOVEMENTS -> "MOVIMIENTOS RECIENTES"
        FinanceWidgetType.PENDING_REMINDERS -> "PAGOS Y COBROS"
        FinanceWidgetType.SAVINGS_GOALS -> "METAS DE AHORRO"
        FinanceWidgetType.FIXED_COMMITMENTS -> "COMPROMISOS FIJOS"
        FinanceWidgetType.QUICK_ACCESS -> "REGISTRO RÁPIDO"
        FinanceWidgetType.DAILY_SPENDING -> "GASTO DE HOY"
        FinanceWidgetType.CATEGORY_LIMITS -> "LÍMITES POR CATEGORÍA"
    }

class FinanceWidgetReceiver : FinanceReceiver(FinanceWidgetType.FINANCE)
class IncomeExpenseWidgetReceiver : FinanceReceiver(FinanceWidgetType.INCOME_EXPENSE)
class BudgetProgressWidgetReceiver : FinanceReceiver(FinanceWidgetType.BUDGET_PROGRESS)
class StatisticsWidgetReceiver : FinanceReceiver(FinanceWidgetType.STATISTICS)
class RecentMovementsWidgetReceiver : FinanceReceiver(FinanceWidgetType.RECENT_MOVEMENTS)
class PendingRemindersWidgetReceiver : FinanceReceiver(FinanceWidgetType.PENDING_REMINDERS)
class SavingsGoalsWidgetReceiver : FinanceReceiver(FinanceWidgetType.SAVINGS_GOALS)
class FixedCommitmentsWidgetReceiver : FinanceReceiver(FinanceWidgetType.FIXED_COMMITMENTS)
class QuickAccessWidgetReceiver : FinanceReceiver(FinanceWidgetType.QUICK_ACCESS)
class DailySpendingWidgetReceiver : FinanceReceiver(FinanceWidgetType.DAILY_SPENDING)
class CategoryLimitsWidgetReceiver : FinanceReceiver(FinanceWidgetType.CATEGORY_LIMITS)

open class FinanceReceiver(type: FinanceWidgetType) : HomeWidgetGlanceWidgetReceiver<FinanceGlanceWidget>() {
    override val glanceAppWidget = FinanceGlanceWidget(type)
}
