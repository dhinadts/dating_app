import 'package:flutter/material.dart';
import 'package:hooks_riverpod/legacy.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // default
});
