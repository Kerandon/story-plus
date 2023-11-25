import 'package:flutter/material.dart';

class ScaleRotateAnimation extends StatefulWidget {
  const ScaleRotateAnimation(
      {required this.animate, Key? key, required this.child})
      : super(key: key);

  final bool animate;
  final Widget child;

  @override
  State<ScaleRotateAnimation> createState() => _ScaleRotateAnimationState();
}

class _ScaleRotateAnimationState extends State<ScaleRotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake, _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.12), weight: 3),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.12, end: -0.08), weight: 5),
      TweenSequenceItem(
          tween: Tween<double>(begin: -0.08, end: 0.04), weight: 5),
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.04, end: 0.00), weight: 6),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.90), weight: 7),
      TweenSequenceItem(tween: Tween<double>(begin: 0.90, end: 1.0), weight: 3),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant ScaleRotateAnimation oldWidget) {
    if (widget.animate) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateZ(_shake.value)
          ..scale(_scale.value)
          ..setEntry(3, 2, 0.003),
        child: widget.child,
      ),
    );
  }
}
