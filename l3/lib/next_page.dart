import 'dart:html';

import 'package:flutter/material.dart';
import 'package:l3/product.dart';
import 'package:l3/product_list.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final List<String> _choices = [
    'cakes',
    'pastries',
    'biscuits',
    'paper box',
    'candles',
    'plastic bags',
    'cup cakes',
    'pizza'
  ];
  int _selected = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _choices
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(e),
                        selected: (_choices.indexOf(e) == _selected),
                        onSelected: (bool result) {
                          if (true == result) {
                            setState(() {
                              _selected = _choices.indexOf(e);
                            });
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(
            child: ProductList(
              key: Key(_selected.toString()),
              index: _selected,
            ),
          ),
        ],
      ),
    );
  }
}
