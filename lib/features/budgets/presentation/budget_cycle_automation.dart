import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'budgets_providers.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkDueCycles(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDueCycles());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkDueCycles();
  }

  Future<void> _checkDueCycles() async {
    if (_checking || !mounted) return;
    _checking = true;
    try {
      await ref
          .read(budgetRepositoryProvider)
          .closeDueCycles(now: DateTime.now());
    } catch (_) {
      // A later periodic tick or app resume retries an automatic close.
    } finally {
      _checking = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
