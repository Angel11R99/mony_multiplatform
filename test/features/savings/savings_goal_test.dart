import 'package:flutter_test/flutter_test.dart';
import 'package:mony_multiplatform/features/savings/domain/savings_goal.dart';
import 'package:mony_multiplatform/features/savings/domain/savings_goal_validator.dart';

void main() {
  test('trims names and validates required fields and limits', () {
    expect(SavingsGoalValidator.normalizeName('  Viaje  '), 'Viaje');
    expect(SavingsGoalValidator.validateName('  '), isNotNull);
    expect(SavingsGoalValidator.validateName('x' * 81), contains('80'));
    expect(SavingsGoalValidator.validateName('Fondo'), isNull);
  });

  test('requires positive target and contribution amounts in centavos', () {
    expect(SavingsGoalValidator.validateTarget(null), isNotNull);
    expect(SavingsGoalValidator.validateTarget(0), isNotNull);
    expect(SavingsGoalValidator.validateTarget(-1), isNotNull);
    expect(SavingsGoalValidator.validateTarget(1), isNull);
    expect(SavingsGoalValidator.validateContribution(0), isNotNull);
    expect(SavingsGoalValidator.validateContribution(1), isNull);
  });

  test('derives progress, completion, remaining amount and excess', () {
    final goal = SavingsGoal(
      id: 1,
      name: 'Laptop',
      targetAmountInCents: 10000,
      createdAt: DateTime(2026, 1),
      completedAt: null,
    );
    final half = SavingsGoalProgress(goal: goal, savedInCents: 5000);
    expect(half.percent, 50);
    expect(half.remainingInCents, 5000);
    expect(half.isActive, isTrue);
    expect(half.isCompleted, isFalse);
    expect(half.canComplete, isFalse);

    final reached = SavingsGoalProgress(goal: goal, savedInCents: 12500);
    expect(reached.percent, 125);
    expect(reached.isCompleted, isTrue);
    expect(reached.canComplete, isTrue);
    expect(reached.savedForGoalInCents, 10000);
    expect(reached.excessInCents, 2500);
    expect(reached.remainingInCents, 0);

    expect(savingsProgressPercent(100, 0), 0);
  });
}
