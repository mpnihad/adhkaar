
import 'dart:async';

import 'package:adhkaar/utils/cliprect.dart';
import 'package:flutter/cupertino.dart';

class Digit<T> extends StatefulWidget {


  final String id;

  final TextStyle textStyle;
  final BoxDecoration decoration;

  final EdgeInsets padding;

  Digit({


    @required this.id,
    @required this.textStyle,
    @required this.decoration,

    @required this.padding,
  });

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> with SingleTickerProviderStateMixin {
   String previd;
  int _currentValue = 1;
  int _nextValue = 1;
  AnimationController _controller;

  bool haveData = false;

  Animatable<Offset> _slideDownDetails = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  );
  Animation<Offset> _slideDownAnimation;

  Animatable<Offset> _slideDownDetails2 = Tween<Offset>(
    begin: const Offset(0.0, 0.0),
    end: Offset(0.0, 1.0),
  );
  Animation<Offset> _slideDownAnimation2;

  @override
  void initState() {
    super.initState();
    previd="0";
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _slideDownAnimation = _controller.drive(_slideDownDetails);
    _slideDownAnimation2 = _controller.drive(_slideDownDetails2);

     _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
      if (status == AnimationStatus.dismissed) {
        _currentValue = _nextValue;
      }
    });

  }

  void animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reset();
    }

    if (status == AnimationStatus.dismissed) {
      _currentValue = _nextValue;
    }
  }

  @override
  void didUpdateWidget(Digit oldWidget) {
    super.didUpdateWidget(oldWidget);
    try {
      _controller.removeStatusListener(animationListener);

    } catch (ex) {

    }

    if(widget.id==previd)
      {

      }
    else {
      previd=widget.id;
      haveData = true;
      if (_currentValue == null) {
        _currentValue = (int.parse(widget.id));
      } else if (int.parse(widget.id) != _currentValue) {
        _nextValue = (int.parse(widget.id));
        _controller.forward();
        _controller.addStatusListener(animationListener);
      }


      haveData = true;
    }

  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fakeWidget = Opacity(
      opacity: 0.0,
      child: Text(
        '9',
        style: widget.textStyle,
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
      ),
    );

    return Container(
      padding: widget.padding,
      alignment: Alignment.center,
//      decoration: widget.decoration ?? BoxDecoration(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, w) {
          return Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.clip,
            children: <Widget>[
              haveData
                  ? FractionalTranslation(
                translation: _slideDownAnimation.value,
                child: ClipRect(
                  clipper: ClipHalfRect(
                    percentage: _slideDownAnimation.value.dy,
                    isUp: true,

                  ),
                  child: Text(
                    '$_nextValue',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                    style: widget.textStyle,
                  ),
                ),
              )
                  : SizedBox(),
              FractionalTranslation(
                translation:  _slideDownAnimation2.value,
                child: ClipRect(
                  clipper: ClipHalfRect(
                    percentage: _slideDownAnimation2.value.dy,
                    isUp: false,

                  ),
                  child: Text(
                    '$_currentValue',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                    style: widget.textStyle,
                  ),
                ),
              ),
              fakeWidget,
            ],
          );
        },
      ),
    );
  }
}
