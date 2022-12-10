import 'package:flutter/material.dart';
import 'dart:math' show pi, min;

import 'package:template_drawer_1/core/constants/enums.dart';

class SideDrawer extends StatefulWidget {
  final int inverse;
  final Widget child;
  final Color? background;
  final BorderRadius? radius;
  final Icon? closeIcon;
  final Widget menu;
  final double maxDrawerWidth;
  final SideDrawerType type;
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
    this.type = SideDrawerType.slide,
    this.maxDrawerWidth = 275.0,
    bool isAlignmentRight = false,      //Right or Left Drawer 
    this.onChange,
  })  : assert(maxDrawerWidth > 0),
        inverse = isAlignmentRight ? -1 : 1,
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
  late bool _isOpen;    // open/close flag for drawer

  //to open drawer
  void openSideDrawer() {
    setState(() => _isOpen = true);

    if (widget.onChange != null) {
      widget.onChange!(true);
    }
  }

  //to close drawer
  void closeSideDrawer() {
    setState(() => _isOpen = false);

    if (widget.onChange != null) {
      widget.onChange!(false);
    }
  }

  //get drawer visible state
  bool get isOpened => _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = false;
  }

  //create close button for drawer
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

          //Drawer Animation Builder
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: widget.inverse.toDouble()),
              duration: const Duration(milliseconds: 500),
              builder: (_, double value, __) {
                if(widget.type == SideDrawerType.slideWithPerspective) return animatedDrawer( Alignment.center,_slideWithPerspective(size, value));
                if(widget.type == SideDrawerType.slideWithShrink) return animatedDrawer(Alignment.topLeft,_slideWithShrink(size));
                if(widget.type == SideDrawerType.slideWithRotation) return animatedDrawer(Alignment.topLeft,_slideWithRotation(size));
                if(widget.type == SideDrawerType.slideShrinkWithRotation) return animatedDrawer(Alignment.center,_slideShrinkWithRotation(size));
                return animatedDrawer(Alignment.topLeft, _slide(size, value));
              })
        ],
      ),
    );
  }

  //Custom AnimatedContainer for Drawer
  Widget animatedDrawer(Alignment alignment ,Matrix4 matrix4) {
    return AnimatedContainer(
      transformAlignment: alignment,
      duration: const Duration(milliseconds: 350),
      curve: Curves.slowMiddle,
      // alignment: Alignment.center,
      transform: matrix4,
      child: widget.child,
    );
  }

  //Matrix4 for Slide
  Matrix4 _slide(Size size, double val) {
    if (_isOpen) {
      return Matrix4.identity()
        ..translate(
            min(size.width * 0.70, widget.maxDrawerWidth) * widget.inverse);
    }
    return Matrix4.identity();
  }
  
  //Matrix4 for Slide and Perspective
  Matrix4 _slideWithPerspective(Size size, double value) {
    if (_isOpen) {
      return Matrix4.identity()
        ..translate(
            min(size.width * 0.70, widget.maxDrawerWidth) * widget.inverse)
      ..setEntry(3, 2, 0.001)
      ..setEntry(0, 3, 200 * value)
      ..rotateY((pi / 6) * value);
    }
    return Matrix4.identity();
  }

  //Matrix4 for Slide and Shrink
  Matrix4 _slideWithShrink(Size size) {
    if (_isOpen) {
      return Matrix4.identity()
        ..translate(
            min(size.width, widget.maxDrawerWidth) *
                widget.inverse *
                (widget.getInverse ? 0.6 : 0.9),
            (size.height * 0.1))
        ..scale(widget.maxDrawerWidth / size.width, 0.8);
    }
    return Matrix4.identity();
  }

  //Matrix4 for Slide and Rotate
  Matrix4 _slideWithRotation(Size size) {
    if (_isOpen) {
      return Matrix4.identity()
        ..rotateZ(widget.degToRad(5.0 * widget.inverse))
        ..translate(min(size.width, widget.maxDrawerWidth) * widget.inverse,
            (size.height * 0.15))
        ..invertRotation()
        ;
    }
    return Matrix4.identity();
  }

  //Matrix4 for Slide Shrink and Rotate
  Matrix4 _slideShrinkWithRotation(Size size) {
    if (_isOpen) {
      return Matrix4.identity()
        ..rotateZ(widget.degToRad(5.0 * widget.inverse))
        ..invertRotation()
        ..translate(
            min(size.width, widget.maxDrawerWidth) *
                widget.inverse *
                (widget.getInverse ? 0.6 : 0.9),
            (size.height * 0.1))
        ..scale(widget.maxDrawerWidth / size.width, 0.8);
    }
    return Matrix4.identity();
  }

}
