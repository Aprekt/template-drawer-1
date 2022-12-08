import 'package:flutter/material.dart';
import 'dart:math' show pi, min;

class SideDrawer extends StatefulWidget {
  final int inverse;
  final Widget child;
  final Color? background;
  final BorderRadius? radius;
  final Icon? closeIcon;
  final Widget menu;
  final double maxDrawerWidth;
  final void Function(bool isOpened)? onChange;

  const SideDrawer({
    Key? key,
    required this.child,
    this.background,
    this.radius,
    this.closeIcon = const Icon(
      Icons.close,
      color: Color(0xFFFFFFFF),
    ),
    required this.menu,
    this.maxDrawerWidth = 275.0,
    bool inverse = false,
    this.onChange,
  })  : assert(maxDrawerWidth > 0),
        inverse = inverse ? -1 : 1,
        super(key: key);

  static SideDrawerState? of(BuildContext? context) {
    assert(context != null);
    return context?.findAncestorStateOfType<SideDrawerState>();
  }

  double degToRad(double deg) => (pi / 180) * deg;

  bool get getInverse => inverse == -1;

  @override
  State<SideDrawer> createState() => SideDrawerState();
}

class SideDrawerState extends State<SideDrawer> {
  late bool _isOpen;

  void openSideDrawer() {
    setState(() => _isOpen = true);

    if (widget.onChange != null) {
      widget.onChange!(true);
    }
  }

  void closeSideDrawer() {
    setState(() => _isOpen = false);

    if (widget.onChange != null) {
      widget.onChange!(false);
    }
  }

  bool get isOpened => _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = false;
  }

  Widget _getCloseButton(double statusBarHeight) {
    return widget.closeIcon != null
        ? Positioned(
            top: statusBarHeight,
            left: widget.getInverse ? null : 0,
            right: widget.getInverse ? 0 : null,
            child: IconButton(
              icon: widget.closeIcon!,
              onPressed: closeSideDrawer,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color.fromARGB(255, 16, 16, 16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: statusBarHeight + (widget.closeIcon?.size ?? 25.0) * 2,
            width: min(size.width * 0.70, widget.maxDrawerWidth),
            right: widget.inverse == 1 ? null : 0,
            child: widget.menu,
          ),
          _getCloseButton(statusBarHeight),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: widget.inverse.toDouble()),
              duration: const Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return AnimatedContainer(
                  transformAlignment: Alignment.center,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.slowMiddle,
                  alignment: Alignment.center,
                  transform: _getMatrix4(size, val),
                  child: widget.child,
                );
              })
        ],
      ),
    );
  }
  Matrix4 _getMatrix4(Size size, double val) {
    if (_isOpen) {
      return Matrix4.identity()
        ..translate(
            min(size.width * 0.70, widget.maxDrawerWidth) *val);
        // ..setEntry(3, 2, 0.001)
        // ..setEntry(0, 3, 200 * val)
        // ..rotateY((pi / 6) * val);
    }
    return Matrix4.identity();
  }
}
