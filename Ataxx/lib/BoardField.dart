import 'package:flutter/material.dart';

class BoardField extends StatelessWidget {
  BoardField(
      {Key? key,
      required this.gridState,
      required this.index,
      required this.onButtonPressed})
      : super(key: key);

  final List<List<int>> gridState;
  final int index;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    int x, y = 0;
    x = (index / gridState.first.length).floor();
    y = (index % gridState.first.length);
    bool dark = gridState[x][y] == -1;

    return Column(children: <Widget>[
      Expanded(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5),
                  color: dark ? Colors.black : Colors.white),
              child: Center(
                child: BoardItem(
                  gridState: gridState,
                  itemIdentifier: gridState[x][y],
                  onButtonPressed: onButtonPressed,
                ),
              ))),
    ]);
  }
}

class BoardItem extends StatelessWidget {
  BoardItem(
      {Key? key,
      required this.gridState,
      required this.itemIdentifier,
      required this.onButtonPressed})
      : super(key: key);

  final List<List<int>> gridState;
  final int itemIdentifier;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    switch (itemIdentifier) {
      case 1:
        return GestureDetector(
            onTap: onButtonPressed,
            child: Image.asset(
              'images/Red Sphere.jpg',
              fit: BoxFit.fill,
            ));

      case 2:
        return GestureDetector(
            onTap: onButtonPressed,
            child: Image.asset(
              'images/Blue Sphere.jpg',
              fit: BoxFit.fill,
            ));

      case 3:
        return GestureDetector(
            onTap: () {},
            child: Image.asset(
              'images/Red Sphere_highlight.jpg',
              fit: BoxFit.fill,
            ));

      case 4:
        return GestureDetector(
            onTap: () {},
            child: Image.asset(
              'images/Blue Sphere_highlight.jpg',
              fit: BoxFit.fill,
            ));

      case 0:
        return GestureDetector(
          onTap: onButtonPressed,
        );

      default:
        return Container(width: 0.0, height: 0.0);
    }
  }
}
