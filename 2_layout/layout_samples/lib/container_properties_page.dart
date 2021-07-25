import 'dart:math' as math;

import 'package:flutter/material.dart';

class ContainerPropertiesPage extends StatefulWidget {
  const ContainerPropertiesPage({
    Key? key,
  }) : super(key: key);
  @override
  _ContainerPropertiesPageState createState() =>
      _ContainerPropertiesPageState();
}

double _height = 50;
double _width = 50;
double _red = 0;
double _green = 0;
double _blue = 0;
double _opacity = 1;
double _radius = 0;
double _rotationZ = 0;

class _ContainerPropertiesPageState extends State<ContainerPropertiesPage> {
  @override
  Widget build(BuildContext context) {
    final radian = (_rotationZ / math.pi).toStringAsFixed(2);
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Container',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                      ),
                      Container(
                        height: _height,
                        width: _width,
                        transform: Matrix4.rotationZ(_rotationZ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(_red.toInt(), _green.toInt(),
                              _blue.toInt(), _opacity),
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('縦幅（height）'),
                  Slider(
                    value: _height,
                    onChanged: (valueHeight) {
                      setState(() => _height = valueHeight);
                    },
                    max: 100,
                    min: 0,
                    divisions: 100,
                    label: '${_height.toInt()}',
                  ),
                  const Text('横幅（width）'),
                  Slider(
                    value: _width,
                    onChanged: (valueWidth) {
                      setState(() => _width = valueWidth);
                    },
                    max: 100,
                    min: 0,
                    divisions: 100,
                    label: '${_width.toInt()}',
                  ),
                  const Text('赤（Red）'),
                  Slider(
                    value: _red,
                    onChanged: (valueRed) {
                      setState(() => _red = valueRed);
                    },
                    max: 255,
                    min: 0,
                    divisions: 255,
                    label: '${_red.toInt()}',
                  ),
                  const Text('緑（Green）'),
                  Slider(
                    value: _green,
                    onChanged: (value) {
                      setState(() => _green = value);
                    },
                    max: 255,
                    min: 0,
                    divisions: 255,
                    label: '${_green.toInt()}',
                  ),
                  const Text('青（Blue）'),
                  Slider(
                    value: _blue,
                    onChanged: (value) {
                      setState(() => _blue = value);
                    },
                    max: 255,
                    min: 0,
                    divisions: 255,
                    label: '${_blue.toInt()}',
                  ),
                  const Text('不透明度（Opacity）'),
                  Slider(
                    value: _opacity,
                    onChanged: (value) {
                      setState(() => _opacity = value);
                    },
                    max: 1,
                    min: 0,
                    divisions: 100,
                    label: '$_opacity',
                  ),
                  const Text('角丸半径（Radius）'),
                  Slider(
                    value: _radius,
                    onChanged: (valueRadius) {
                      setState(() => _radius = valueRadius);
                    },
                    max: 30,
                    min: 0,
                    divisions: 100,
                    label: '${_radius.toInt()}',
                  ),
                  const Text('回転（Transform）'),
                  Slider(
                    value: _rotationZ,
                    onChanged: (value) {
                      setState(() => _rotationZ = value);
                    },
                    max: math.pi * 2,
                    min: 0,
                    divisions: 100,
                    label: '$radian π',
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
