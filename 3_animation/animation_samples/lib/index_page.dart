import 'package:flutter/material.dart';

import 'animation_controller_page.dart';
import 'hero_page.dart';
import 'open_container_page.dart';
import 'tween_staggered_page.dart';
import 'shared_axis_transition_page.dart';
import 'transition_page.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const TransitionPage();
                  }),
                );
              },
              child: const Text('Transition'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const HeroFromPage();
                  }),
                );
              },
              child: const Text('Hero'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const OpenContainerPage();
                  }),
                );
              },
              child: const Text('OpenContainer'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const SharedAxisTransitionPage();
                  }),
                );
              },
              child: const Text('SharedAxisTransition'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const AnimationControllerPage();
                  }),
                );
              },
              child: const Text('AnimationController'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const TweenStaggeredPage();
                  }),
                );
              },
              child: const Text('TweenStaggeredPage'),
            ),
          ),
        ],
      ),
    );
  }
}
