import 'package:citizencentric/presentation/common/state_renderer/state_renderer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../data/mapper/mappper.dart';
import '../../resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// 🔹 Loading State
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading.tr();

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// 🔹 Error State
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// 🔹 Content State

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => EMPTY;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.CONTENT_SCREEN_STATE;
}

// 🔹 Empty State
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

// 🔹 Success State
class SuccessState extends FlowState {
  String message;
  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.POPUP_SUCCESS;
}

// 🔹 Extension for FlowState to handle UI rendering

extension FlowStateExtension on FlowState {
  static StateRendererType? _currentPopup;

  Widget getScreenWidget(
      BuildContext context,
      Widget contentScreenWidget,
      VoidCallback retryActionFunction,
      ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePopup(context);
    });

    return contentScreenWidget;
  }

  void _handlePopup(BuildContext context) {
    switch (runtimeType) {

    /// 🔹 LOADING
      case LoadingState:
        if (getStateRendererType() ==
            StateRendererType.POPUP_LOADING_STATE &&
            _currentPopup != StateRendererType.POPUP_LOADING_STATE) {
          _currentPopup = StateRendererType.POPUP_LOADING_STATE;
          _showDialog(
            context,
            type: StateRendererType.POPUP_LOADING_STATE,
            message: getMessage(),
          );
        }
        break;

    /// 🔹 ERROR
      case ErrorState:
        _dismissIfNeeded(context);
        _currentPopup = StateRendererType.POPUP_ERROR_STATE;

        _showDialog(
          context,
          type: StateRendererType.POPUP_ERROR_STATE,
          message: getMessage(),
          onDismiss: () {
            _currentPopup = null;
          },
        );
        break;

    /// 🔹 SUCCESS
      case SuccessState:
        _dismissIfNeeded(context);
        _currentPopup = StateRendererType.POPUP_SUCCESS;

        _showDialog(
          context,
          type: StateRendererType.POPUP_SUCCESS,
          message: getMessage(),
          title: AppStrings.success.tr(),
          onDismiss: () {
            _currentPopup = null;
          },
        );
        break;

    /// 🔹 CONTENT
      case ContentState:
        _dismissIfNeeded(context);
        break;

      default:
        break;
    }
  }

  void _dismissIfNeeded(BuildContext context) {
    if (_currentPopup != null && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
      _currentPopup = null;
    }
  }

  void _showDialog(
      BuildContext context, {
        required StateRendererType type,
        required String message,
        String title = EMPTY,
        VoidCallback? onDismiss,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: StateRenderer(
          stateRendererType: type,
          message: message,
          title: title,
          retryActionFunction: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
    ).then((_) {
      if (onDismiss != null) onDismiss();
    });
  }
}

