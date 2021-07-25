import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimationControllerPage extends StatefulWidget {
  const AnimationControllerPage({
    Key? key,
  }) : super(key: key);
  @override
  _AnimationControllerPageState createState() =>
      _AnimationControllerPageState();
}

class _AnimationControllerPageState extends State<AnimationControllerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _value = 0;
  int _seconds = 15;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _seconds),
    );
    _animationController.addListener(() {
      setState(() {
        _value = _animationController.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateSeconds(int newSeconds) {
    setState(() {
      _seconds = newSeconds;
    });
    _animationController.duration = Duration(seconds: _seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '_animationController\n.value =',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: _animationController.value,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  _value.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 64,
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                onPressed: _animationController.forward,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.play_arrow),
                    Text(
                      '再生',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                onPressed: _animationController.reverse,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.rotate(
                      angle: math.pi,
                      child: const Icon(Icons.play_arrow),
                    ),
                    const Text(
                      '逆再生',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                onPressed: _animationController.stop,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.rotate(
                      angle: math.pi,
                      child: const Icon(Icons.pause),
                    ),
                    const Text(
                      '一時停止',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                onPressed: _animationController.reset,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.stop),
                    Text(
                      '停止',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300],
                  onPrimary: Colors.black,
                ),
                onPressed: _animationController.repeat,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.repeat),
                    Text(
                      'リピート',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            const Text(
              'Duration',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<int>(
                  value: 15,
                  groupValue: _seconds,
                  onChanged: (int? newValue) {
                    _updateSeconds(newValue!);
                  },
                ),
                const Text('15秒'),
                Radio<int>(
                  value: 30,
                  groupValue: _seconds,
                  onChanged: (int? newValue) {
                    _updateSeconds(newValue!);
                  },
                ),
                const Text('30秒'),
                Radio<int>(
                  value: 60,
                  groupValue: _seconds,
                  onChanged: (int? newValue) {
                    _updateSeconds(newValue!);
                  },
                ),
                const Text('60秒'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
