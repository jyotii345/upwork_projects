import 'dart:async';

import 'package:flutter/cupertino.dart';

class PinchToZoom extends StatefulWidget {
  PinchToZoom(this.childObject);

  final Widget childObject;

  @override
  State<StatefulWidget> createState() => new PinchToZoomState();
}

class PinchToZoomState extends State<PinchToZoom>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> animationReset;
  AnimationController controllerReset;
  Timer timer;

  @override
  void initState() {
    super.initState();
    controllerReset = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getPinchToZoom(widget.childObject);
  }

  Widget getPinchToZoom(Widget childWidget) {
    return InteractiveViewer(
        constrained: true,
        alignPanAxis: false,
        boundaryMargin: EdgeInsets.all(20),
        transformationController: _transformationController,
        scaleEnabled: true,
        minScale: 1.0,
        maxScale: 2.5,
        onInteractionStart: _onInteractionStart,
        onInteractionEnd: _onInteractionEnd,
        child: childWidget);
  }

  void _animateResetInitialize() async {
    //animation reset for pnich to zoom

    timer = Timer(Duration(seconds: 5), () {
      controllerReset.reset();
      animationReset = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(controllerReset);
      animationReset.addListener(_onAnimateReset);
      controllerReset.forward();
    });

  }

  void _onAnimateReset() {
    //notifies when the animation is resetting on pinch to zoom
    try {
      _transformationController.value = animationReset.value;
      if (!controllerReset.isAnimating) {
        animationReset?.removeListener(_onAnimateReset);
        animationReset = null;
        controllerReset.reset();
      }
    } catch (e) {
    }
  }

  void _onInteractionStart(ScaleStartDetails details) {
    //cancels the reset if a user clicks again

    if(timer != null ){
      if(timer.isActive){
        timer.cancel();
        timer = null;
      }
    }

    if (controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _animateResetStop() {
    //cancel the reset for the pinch to zoom
    controllerReset.stop();
    animationReset?.removeListener(_onAnimateReset);
    animationReset = null;
    controllerReset.reset();
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    //called when zoom ends for pinch to zoom
    _animateResetInitialize();
  }
}
