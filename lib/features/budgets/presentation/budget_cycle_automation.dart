import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'budgets_providers.dart';
import '../domain/budget.dart';
import '../../recurring/presentation/recurring_providers.dart';

/// Checks for due budget cycles while the app is running and when it resumes.
/// If the OS suspends the app, overdue cycles are caught up on the next resume.
class BudgetCycleAutomation extends ConsumerStatefulWidget {
  const BudgetCycleAutomation({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<BudgetCycleAutomation> createState() =>
      _BudgetCycleAutomationState();
}

class _BudgetCycleAutomationState extends ConsumerState<BudgetCycleAutomation>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _checking = false;
  bool _checkRequested = false;
  int _scheduleGeneration = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDueCycles());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkDueCycles();
  }

  Future<void> _checkDueCycles() async {
    if (!mounted) return;
    if (_checking) {
      _checkRequested = true;
      return;
    }
    _checking = true;
    var failed = false;
    do {
      _checkRequested = false;
      try {
        await ref
            .read(budgetRepositoryProvider)
            .closeDueCycles(now: DateTime.now());
      } catch (_) {
        failed = true;
      }
      try {
        await ref
            .read(recurringRepositoryProvider)
            .processDue(now: DateTime.now());
      } catch (_) {
        failed = true;
      }
    } while (_checkRequested && mounted);
    _checking = false;
    if (mounted) {
      await _scheduleNextCheck(retryAfterFailure: failed);
    }
  }

  Future<void> _scheduleNextCheck({bool retryAfterFailure = false}) async {
    if (!mounted) return;
    final generation = ++_scheduleGeneration;
    _timer?.cancel();
    if (retryAfterFailure) {
      _timer = Timer(const Duration(minutes: 5), _checkDueCycles);
      return;
    }

    final now = DateTime.now();
    var nextCheck = nextBudgetAutomationCheckAt(null, now);
    try {
      final budget = await ref.read(budgetRepositoryProvider).getConfig();
      final budgetCheck = nextBudgetAutomationCheckAt(budget, now);
      if (budgetCheck.isBefore(nextCheck)) nextCheck = budgetCheck;
    } catch (_) {
      nextCheck = now.add(const Duration(minutes: 5));
    }
    if (!mounted || generation != _scheduleGeneration) return;

    final delay = nextCheck.difference(DateTime.now());
    _timer = Timer(
      delay.isNegative || delay == Duration.zero
          ? const Duration(seconds: 1)
          : delay,
      _checkDueCycles,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(budgetConfigProvider, (previous, next) {
      if (next.hasValue) _scheduleNextCheck();
    });
    ref.listen(recurringEntriesProvider, (previous, next) {
      if (next.hasValue) _checkDueCycles();
    });
    return widget.child;
  }
}
