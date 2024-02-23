import 'package:flutter/material.dart';

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> with AutomaticKeepAliveClientMixin<Bike> {
  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    print('creating bike');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          setState(() {
            _colorIndex++;
            _colorIndex %= colors.length;
          });
        },
        icon: Icon(
          Icons.directions_bike_sharp,
          size: 60,
          color: colors[_colorIndex],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
