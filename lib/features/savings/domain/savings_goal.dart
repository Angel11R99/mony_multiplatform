class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmountInCents,
    required this.createdAt,
    required this.completedAt,
  });

  final int id;
  final String name;
  final int targetAmountInCents;
  final DateTime createdAt;
  final DateTime? completedAt;
}

class SavingsGoalProgress {
  const SavingsGoalProgress({required this.goal, required this.savedInCents});

  final SavingsGoal goal;
  final int savedInCents;

  int get percent =>
      savingsProgressPercent(savedInCents, goal.targetAmountInCents);
  bool get isActive => goal.completedAt == null;
  bool get isCompleted =>
      goal.completedAt != null || savedInCents >= goal.targetAmountInCents;
  bool get canComplete =>
      goal.completedAt == null && savedInCents >= goal.targetAmountInCents;
  int get excessInCents => savedInCents > goal.targetAmountInCents
      ? savedInCents - goal.targetAmountInCents
      : 0;
  int get savedForGoalInCents => (savedInCents < 0
      ? 0
      : savedInCents > goal.targetAmountInCents
      ? goal.targetAmountInCents
      : savedInCents);
  int get remainingInCents => (savedInCents >= goal.targetAmountInCents
      ? 0
      : goal.targetAmountInCents - savedInCents);
}

int savingsProgressPercent(int savedInCents, int targetInCents) {
  if (targetInCents <= 0) return 0;
  return (savedInCents * 100) ~/ targetInCents;
}

class SavingsContribution {
  const SavingsContribution({
    required this.transactionId,
    required this.amountInCents,
    required this.date,
    required this.description,
  });

  final int transactionId;
  final int amountInCents;
  final DateTime date;
  final String? description;
}
