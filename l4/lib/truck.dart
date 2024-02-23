import 'package:flutter/material.dart';

class Truck extends StatefulWidget {
  const Truck({super.key});

  @override
  State<Truck> createState() => _TruckState();
}

class _TruckState extends State<Truck>
    with AutomaticKeepAliveClientMixin<Truck> {
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
    print('creating truck');
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
          Icons.fire_truck,
          size: 60,
          color: colors[_colorIndex],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
