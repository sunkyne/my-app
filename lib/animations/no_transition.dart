import 'package:flutter/material.dart';

class NoTransitionPageRoute extends MaterialPageRoute {
  NoTransitionPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}