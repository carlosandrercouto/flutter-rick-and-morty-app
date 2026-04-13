import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/snackbar_utils.dart';

class LoadUtils {
  /// Exemplo de uso:
  /// onScrollLoadControl(
  ///       scrollController: _scrollController,
  ///       isLastPage: _isLastPage,
  ///       isLoadingInProgress: _isLoadingInProgress,
  ///       isLoadingInProgressUpdate: (bool value) {
  ///         _isLoadingMoreItens = value;
  ///       },
  ///       onLoad: () {
  ///         _permissionsBloc.add(LoadPermissionsListEvent(
  ///           eventId: widget.eventId,
  ///         ));
  ///       },
  ///     )
  static void onScrollLoadControl({
    /// ScrollController associado ao widget 'scrollável'
    required ScrollController scrollController,

    /// Utilizado para impedir chamadas simultâneas
    required bool isLoadingInProgress,

    /// Utilizado para impedir chamadas após após chegar no final da lista
    required bool isLastPage,

    /// Utilizado para atualizar o valor da variável passado no 'isLoadingInProgress'
    required Function(bool) isLoadingInProgressUpdate,

    /// Método disparado para carregar novos itens
    required Function() onLoad,
  }) {
    if (isLoadingInProgress || isLastPage) return;

    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      onLoad();

      isLoadingInProgressUpdate(true);
    }
  }

  static void onClickLoadControl({
    /// Utilizado para impedir chamadas simultâneas
    required bool isLoadingInProgress,

    /// Utilizado para impedir chamadas após após chegar no final da lista
    required bool isLastPage,

    /// Utilizado para atualizar o valor da variável passado no 'isLoadingInProgress'
    required Function(bool) isLoadingInProgressUpdate,

    /// Método disparado para carregar novos itens
    required Function() onLoad,
  }) {
    if (!isLoadingInProgress || !isLastPage) {
      onLoad();

      isLoadingInProgressUpdate(true);
    }
  }

  static Future<void> onPreventMultipleRequests({
    required BuildContext context,
    required Function reloadFunction,
    required Function updateLastRefresh,
    required DateTime lastRefresh,
  }) async {
    final currentTime = DateTime.now();
    const int secondsAwait = 10;
    final int secondsDifference = currentTime.difference(lastRefresh).inSeconds;
    final int secondsRemaining = secondsAwait - secondsDifference;
    final bool canReload = secondsRemaining <= 0;

    if (canReload) {
      await updateLastRefresh();
      await reloadFunction();
    } else {
      SnackBarUtils.showSnackBarBlack(
        context: context,
        message:
            'Aguarde mais $secondsRemaining segundos antes de atualizar novamente.',
      );

      await Future.delayed(const Duration(seconds: 3));
    }
  }
}
