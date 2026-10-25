import 'package:equatable/equatable.dart';
import 'package:so_link/core/constants/app_constants.dart';

class AppConfig extends Equatable {
  const AppConfig({
    required this.maintenance,
    required this.updateRequired,
    required this.forceUpdate,
    required this.minVersion,
    required this.currentVersion,
    required this.themeIndex,
    this.latestVersion,
  });

  factory AppConfig.defaults() {
    return const AppConfig(
      maintenance: false,
      updateRequired: false,
      forceUpdate: false,
      minVersion: AppConstants.currentVersion,
      currentVersion: AppConstants.currentVersion,
      themeIndex: 0,
    );
  }

  final bool maintenance;
  final bool updateRequired;
  final bool forceUpdate;
  final int minVersion;
  final int currentVersion;
  final int themeIndex;
  final String? latestVersion;

  AppConfig copyWith({
    bool? maintenance,
    bool? updateRequired,
    bool? forceUpdate,
    int? minVersion,
    int? currentVersion,
    int? themeIndex,
    String? latestVersion,
  }) {
    return AppConfig(
      maintenance: maintenance ?? this.maintenance,
      updateRequired: updateRequired ?? this.updateRequired,
      forceUpdate: forceUpdate ?? this.forceUpdate,
      minVersion: minVersion ?? this.minVersion,
      currentVersion: currentVersion ?? this.currentVersion,
      themeIndex: themeIndex ?? this.themeIndex,
      latestVersion: latestVersion ?? this.latestVersion,
    );
  }

  @override
  List<Object?> get props => [
    maintenance,
    updateRequired,
    forceUpdate,
    minVersion,
    currentVersion,
    themeIndex,
    latestVersion,
  ];
}
