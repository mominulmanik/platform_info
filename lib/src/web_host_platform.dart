import 'dart:html' as html show window;

import 'base_host_platform.dart';
import 'constants.dart';
import 'enums.dart';

/// Get host platform if dart.library.html available
HostPlatform getHostPlatform() => _WebHostPlatform._();

/// Web based host platform
class _WebHostPlatform implements HostPlatform {
  _WebHostPlatform._();

  @override
  final HostPlatformType type = HostPlatformType.web;

  @override
  final OperatingSystem operatingSystem = _getOS();

  @override
  final String version = _getVersion();

  @override
  final String locale = _getLocale();

  @override
  int numberOfProcessors = _numberOfProcessors();

  static OperatingSystem _getOS() {
    final appVersion = _getVersion().toLowerCase();
    if (appVersion.contains('fuchsia')) {
      return OperatingSystem.fuchsia;
    } else if (appVersion.contains('mac')) {
      return OperatingSystem.macOS;
    } else if (appVersion.contains('win')) {
      return OperatingSystem.windows;
    } else if (appVersion.contains('android')) {
      return OperatingSystem.android;
    } else if (appVersion.contains('iphone')) {
      return OperatingSystem.iOS;
    } else if (appVersion.contains('ios')) {
      return OperatingSystem.iOS;
    } else if (appVersion.contains('linux')) {
      return OperatingSystem.linux;
    }
    return kDefaultHostPlatform.operatingSystem;
  }

  static String _getVersion() => [
        html.window?.navigator?.userAgent,
        html.window?.navigator?.appVersion,
        html.window?.navigator?.platform,
      ].firstWhere((v) => v is String && v.isNotEmpty,
          orElse: () => kDefaultHostPlatform.version);

  static int _numberOfProcessors() =>
      html.window?.navigator?.hardwareConcurrency ??
      kDefaultHostPlatform.numberOfProcessors;

  static String _getLocale() {
    final lang = html.window.navigator.language
        ?.split('-')
        ?.first
        ?.split('_')
        ?.first
        ?.trim()
        ?.toLowerCase();
    if (lang is! String || lang.length != 2) return kDefaultHostPlatform.locale;
    return lang;
  }
}
