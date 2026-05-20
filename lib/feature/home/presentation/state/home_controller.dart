import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
final appCategorySelected = StateProvider<int>((ref) => 0);
final appBarTitleProvider = StateProvider<String>((ref) => "Home");
final shellBodyProvider = StateProvider<Widget Function()?>((_) => null);
final searchShowingProvider = StateProvider<bool>((ref) => false);