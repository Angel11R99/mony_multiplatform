import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/core/theme/mony_finance_colors.dart';
import 'package:mony_multiplatform/core/widgets/mony_finance_widgets.dart';

void main() {
  const financeColors = MonyFinanceColors(
    income: Color(0xFF62DDA9),
    onIncome: Colors.black,
    expense: Color(0xFFFF6B6B),
    onExpense: Colors.black,
    warning: Colors.orange,
    onWarning: Colors.black,
  );

  testWidgets('renders as native text without inherited background fill', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [financeColors],
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        home: const Scaffold(
          body: DefaultTextStyle(
            style: TextStyle(backgroundColor: Colors.white),
            child: AmountText(
              'RD\$0.00',
              emphasis: AmountEmphasis.income,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AmountText), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsNothing);
    expect(find.text('RD\$0.00'), findsOneWidget);

    final paragraph = tester.renderObject<RenderParagraph>(
      find.byType(RichText),
    );
    expect(paragraph.text.style?.backgroundColor, Colors.transparent);
    expect(paragraph.text.style?.color, financeColors.income);
    expect(paragraph.text.style?.fontSize, 28);
    expect(paragraph.text.style?.fontWeight, FontWeight.bold);
  });

  testWidgets(
    'expense amount keeps semantic color and transparent background',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [financeColors]),
          home: const Scaffold(
            body: AmountText('RD\$0.00', emphasis: AmountEmphasis.expense),
          ),
        ),
      );

      final paragraph = tester.renderObject<RenderParagraph>(
        find.byType(RichText),
      );
      expect(paragraph.text.style?.backgroundColor, Colors.transparent);
      expect(paragraph.text.style?.color, financeColors.expense);
    },
  );
}
