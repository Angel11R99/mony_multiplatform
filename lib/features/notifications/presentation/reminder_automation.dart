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
  Timer? _retryTimer;
  bool _syncing = false;
  bool _syncRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    _retryTimer?.cancel();
    _retryTimer = null;
    _syncing = true;
    do {
      _syncRequested = false;
      try {
        final preferences = await ref.read(appPreferencesProvider.future);
        await ref
            .read(localReminderSchedulerProvider)
            .reconcile(enabled: preferences.notificationsEnabled);
      } catch (_) {
        _retryTimer?.cancel();
        _retryTimer = Timer(const Duration(minutes: 5), () {
          _retryTimer = null;
          _sync();
        });
      }
    } while (_syncRequested && mounted);
    _syncing = false;
  }

  @override
  Widget build(BuildContext context) {
    final remindersEnabled =
        ref.watch(appPreferencesProvider).value?.notificationsEnabled ?? false;
    ref.listen(appPreferencesProvider, (previous, next) {
      if (next.hasValue) _sync();
    });
    if (remindersEnabled) {
      ref.listen(obligationsProvider, (previous, next) {
        if (next.hasValue) _sync();
      });
      ref.listen(recurringEntriesProvider, (previous, next) {
        if (next.hasValue) _sync();
      });
    }
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _retryTimer?.cancel();
    super.dispose();
  }
}
