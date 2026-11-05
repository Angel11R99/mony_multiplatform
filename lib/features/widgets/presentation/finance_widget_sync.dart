import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import '../../../core/logging/app_log.dart';
import '../domain/finance_widget_snapshot.dart';
import 'widgets_providers.dart';

class FinanceWidgetSync extends ConsumerStatefulWidget {
  const FinanceWidgetSync({
    required this.child,
    required this.router,
    super.key,
  });

  final Widget child;
  final GoRouter router;

  @override
  ConsumerState<FinanceWidgetSync> createState() => _FinanceWidgetSyncState();
}

class _FinanceWidgetSyncState extends ConsumerState<FinanceWidgetSync> {
  final _publisher = FinanceWidgetPublisher();
  Future<void> _writeQueue = Future<void>.value();
  StreamSubscription<Uri?>? _tapSubscription;

  @override
  void initState() {
    super.initState();
    if (kIsWeb ||
        !const {
          TargetPlatform.android,
          TargetPlatform.iOS,
        }.contains(defaultTargetPlatform)) {
      return;
    }
    ref.listenManual<AsyncValue<FinanceWidgetSnapshot>>(
      financeWidgetSnapshotProvider,
      (previous, next) => _publishWhenReady(next),
      fireImmediately: true,
    );
    _tapSubscription = HomeWidget.widgetClicked.listen(_openWidgetDestination);
    unawaited(_openInitialWidgetDestination());
  }

  Future<void> _openInitialWidgetDestination() async {
    try {
      final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (uri != null) _openWidgetDestination(uri);
    } catch (error) {
      AppLog.error('finance_widget_initial_link_failed', error);
    }
  }

  void _openWidgetDestination(Uri? uri) {
    if (uri == null || !uri.hasScheme) return;
    final path = uri.path.isEmpty ? '/' : uri.path;
    final query = Map<String, String>.of(uri.queryParameters)
      ..remove('homeWidget');
    final location = Uri(path: path, queryParameters: query).toString();
    widget.router.go(location);
  }

  void _publishWhenReady(AsyncValue<FinanceWidgetSnapshot> state) {
    final snapshot = state.asData?.value;
    if (snapshot == null) return;
    _writeQueue = _writeQueue
        .then((_) => _publisher.publish(snapshot))
        .catchError((Object error, StackTrace stackTrace) {
          AppLog.error('finance_widget_sync_failed', error);
        });
  }

  @override
  void dispose() {
    unawaited(_tapSubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
