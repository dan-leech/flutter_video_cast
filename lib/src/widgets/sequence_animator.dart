import 'package:flutter/widgets.dart';

class SequenceAnimator extends StatefulWidget {
  SequenceAnimator(
      {Key key,
      @required this.childrenSequence,
      this.delayDuration = const Duration(milliseconds: 150),
      this.switchDuration = const Duration(milliseconds: 50)})
      : super(key: key);

  final Duration delayDuration;
  final Duration switchDuration;
  final List<Widget> childrenSequence;

  @override
  _SequenceAnimatorState createState() => _SequenceAnimatorState();
}

class _SequenceAnimatorState extends State<SequenceAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int _index;

  @override
  void initState() {
    _index = 0;
    _controller =
        AnimationController(vsync: this, duration: widget.delayDuration);
    _controller.repeat(reverse: true);
    _controller.addStatusListener((status) {
          if(status == AnimationStatus.forward) {
            setState(() {
              final next = _index + 1;
              _index = next < widget.childrenSequence.length ? next : 0;
            });
          }
        });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: widget.switchDuration,
        child: widget.childrenSequence[_index],
      );
}
