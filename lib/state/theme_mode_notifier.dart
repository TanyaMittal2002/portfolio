import 'package:flutter/material.dart';

/// Shared theme mode notifier so multiple widgets can toggle the app theme.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
