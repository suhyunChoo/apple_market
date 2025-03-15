import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final List csvRow;
  const DetailPage({super.key, required this.csvRow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 상세'),
      ),
      body: Expanded(
          child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${csvRow[1]}.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_circle_fill,
                      color: Colors.orange,
                      size: 60,
                    ),
                    Column(
                      children: [
                        Text('data'),
                        Text('data'),
                      ],
                    ),Column(
                      children: [
                        Text('39.3 °C'),
                        Text('매너온도'),
                      ],
                    ),

                  ],
                ),
                Text('data'),
                Text('data'),
              ],
              
            ),
          )
        ],
      )),
    );
  }
}
