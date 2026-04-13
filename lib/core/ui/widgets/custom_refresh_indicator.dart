import 'package:flutter/material.dart';

import '../../utils/load_utils.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Function updateLastRefresh;
  final DateTime lastRefresh;
  final Widget child;
  final double edgeOffset;
  final double displacement;

  const CustomRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.updateLastRefresh,
    required this.lastRefresh,
    required this.child,
    this.edgeOffset = 20,
    this.displacement = 10,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await LoadUtils.onPreventMultipleRequests(
        context: context,
        lastRefresh: lastRefresh,
        reloadFunction: onRefresh,
        updateLastRefresh: updateLastRefresh,
      ),
      color: Theme.of(context).colorScheme.primary,
      edgeOffset: edgeOffset,
      displacement: displacement,
      child: child,
    );
  }
}
