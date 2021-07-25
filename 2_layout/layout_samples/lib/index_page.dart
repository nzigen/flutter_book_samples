import 'package:flutter/material.dart';

import 'container_properties_page.dart';
import 'grid_view_page.dart';
import 'responsive_design_page.dart';
import 'shrinkable_footer_page.dart';
import 'sliver_app_bar_page.dart';

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
                    return const ContainerPropertiesPage();
                  }),
                );
              },
              child: const Text('ContainerPropertiesPage'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const GridViewPage();
                  }),
                );
              },
              child: const Text('GridView'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const SliverAppBarPage();
                  }),
                );
              },
              child: const Text('SliverAppBar'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const ShrinkableFooterPage();
                  }),
                );
              },
              child: const Text('スクロールで縮むフッター'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const ResponsiveDesignPage();
                  }),
                );
              },
              child: const Text('レスポンシブデザイン'),
            ),
          ),
        ],
      ),
    );
  }
}
