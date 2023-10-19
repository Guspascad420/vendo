import 'package:flutter/material.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;

  const ScrollToHideWidget({super.key, required this.child,
    required this.isVisible, this.duration = const Duration(milliseconds: 300)});

  @override
  State<StatefulWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: widget.duration,
      height: widget.isVisible ? 80 : 0,
      child: Wrap(children: [widget.child]),
  );

}