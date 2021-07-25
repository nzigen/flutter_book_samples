import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class OpenContainerImages {
  static const List<String> titles = [
    'Bear',
    'Tiger',
    'Turtle',
    'Hedgehog',
    'Dolphin',
    'Butterfly',
    'Rose',
    'Sunflower',
    'Rabbit',
    'Dogs',
    'HighMountain',
    'Lake'
  ];

  static const List<String> urls = [
    'https://images.pexels.com/photos/65289/polar-bear-bear-teddy-sleep-65289.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/145939/pexels-photo-145939.jpeg?cs=srgb&dl=pexels-flickr-145939.jpg&fm=jpg',
    'https://images.pexels.com/photos/847393/pexels-photo-847393.jpeg?cs=srgb&dl=pexels-belle-co-847393.jpg&fm=jpg',
    'https://images.pexels.com/photos/50577/hedgehog-animal-baby-cute-50577.jpeg?cs=srgb&dl=pexels-pixabay-50577.jpg&fm=jpg',
    'https://images.pexels.com/photos/64219/dolphin-marine-mammals-water-sea-64219.jpeg?cs=srgb&dl=pexels-pixabay-64219.jpg&fm=jpg',
    'https://images.pexels.com/photos/672142/pexels-photo-672142.jpeg?cs=srgb&dl=pexels-zaw-win-tun-672142.jpg&fm=jpg',
    'https://images.pexels.com/photos/39517/rose-flower-blossom-bloom-39517.jpeg?cs=srgb&dl=pexels-pixabay-39517.jpg&fm=jpg',
    'https://images.pexels.com/photos/46216/sunflower-flowers-bright-yellow-46216.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://images.pexels.com/photos/372166/pexels-photo-372166.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/1612371/pexels-photo-1612371.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/2286895/pexels-photo-2286895.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];
}

class OpenContainerPage extends StatelessWidget {
  const OpenContainerPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenContainer'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        children: [
          for (var index = 0;
              index < OpenContainerImages.titles.length;
              index++)
            OpenContainer(
              closedBuilder: (_, openContainer) {
                return GestureDetector(
                  onTap: openContainer,
                  child: ImageItem(
                    url: OpenContainerImages.urls[index],
                  ),
                );
              },
              openBuilder: (_, closeContainer) {
                return LargeImagePage(
                  index: index,
                  onPressed: closeContainer,
                );
              },
              openColor: Colors.black87,
              closedColor: Colors.black87,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            )
        ],
      ),
    );
  }
}

class LargeImagePage extends StatelessWidget {
  const LargeImagePage({
    required this.index,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final int index;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text(OpenContainerImages.titles[index]),
          leading: IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: ImageItem(
              url: OpenContainerImages.urls[index],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageItem extends StatelessWidget {
  const ImageItem({
    required this.url,
    Key? key,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      fit: BoxFit.cover,
    );
  }
}
