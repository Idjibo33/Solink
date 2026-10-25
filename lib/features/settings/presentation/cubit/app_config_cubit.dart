import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/constants/app_constants.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';
import 'package:so_link/features/settings/domain/repositories/app_config_repository.dart';

class AppConfigState extends Equatable {
  const AppConfigState({this.isLoading = true, this.config, this.errorMessage});

  final bool isLoading;
  final AppConfig? config;
  final String? errorMessage;

  bool get maintenance => config?.maintenance ?? false;

  bool get updateRequired => config?.updateRequired ?? false;

  bool get forceUpdate => config?.forceUpdate ?? false;

  Color get themeColor {
    final index = (config?.themeIndex ?? 0).clamp(
      0,
      AppConstants.seedColors.length - 1,
    );
    return AppConstants.seedColors[index];
  }

  AppConfigState copyWith({
    bool? isLoading,
    AppConfig? config,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppConfigState(
      isLoading: isLoading ?? this.isLoading,
      config: config ?? this.config,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, config, errorMessage];
}

class AppConfigCubit extends Cubit<AppConfigState> {
  AppConfigCubit(this._repository) : super(const AppConfigState());

  final AppConfigRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.load();
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(
        AppConfigState(
          isLoading: false,
          config: AppConfig.defaults(),
          errorMessage: failure.message,
        ),
      ),
      (config) => emit(AppConfigState(isLoading: false, config: config)),
    );
  }
}
