import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('르탄동'),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.bell),
              onPressed: () {
                // 아이콘 클릭 시 동작
              },
            ),
          ],
          backgroundColor: Colors.grey[200],
        ),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(child: Text('image')),
                        Container(
                            child: Column(
                          children: [
                            Text('김치냉장고'),
                            Text('인천 서구 가정로'),
                            Text('3,000원'),
                            Row(
                              children: [
                                Icon(CupertinoIcons.chat_bubble_2),
                                Text('3'),
                                Icon(CupertinoIcons.heart),
                                Text('3'),
                              ],
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
