import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../obligations/presentation/obligations_providers.dart';
import '../../preferences/presentation/preferences_controller.dart';
import '../../recurring/presentation/recurring_providers.dart';
import 'notifications_providers.dart';

class ReminderAutomation extends ConsumerStatefulWidget {
  const ReminderAutomation({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ReminderAutomation> createState() => _ReminderAutomationState();
}

class _ReminderAutomationState extends ConsumerState<ReminderAutomation>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _syncing = false;
  bool _syncRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _sync());
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  Future<void> _sync() async {
    if (!mounted) return;
    if (_syncing) {
      _syncRequested = true;
      return;
    }
    _syncing = true;
    do {
      _syncRequested = false;
      try {
        final preferences = await ref.read(appPreferencesProvider.future);
        await ref
            .read(recurringRepositoryProvider)
            .processDue(now: DateTime.now());
        await ref
            .read(localReminderSchedulerProvider)
            .reconcile(enabled: preferences.notificationsEnabled);
      } catch (_) {
        // A later timer tick, database update, or app resume retries the sync.
      }
    } while (_syncRequested && mounted);
    _syncing = false;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(obligationsProvider, (previous, next) {
      if (next.hasValue) _sync();
    });
    ref.listen(recurringEntriesProvider, (previous, next) {
      if (next.hasValue) _sync();
    });
    ref.listen(appPreferencesProvider, (previous, next) {
      if (next.hasValue) _sync();
    });
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
