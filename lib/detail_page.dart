import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applemarket_app/product_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends StatefulWidget {
  final List csvRow;
  final int index;
  const DetailPage({super.key, required this.csvRow, required this.index});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isClicked = false;

  void clickedHeart() {
    setState(() {
      isClicked = !isClicked;
    });
  }

//상수처리하기!
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                ),
            title: Text('상품 상세'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/${widget.csvRow[1]}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.person_circle_fill,
                            color: Colors.orange,
                            size: 60,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.csvRow[4],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(widget.csvRow[6]),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                '39.3 °C',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              Text(
                                '매너온도',
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          widget.csvRow[2],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: Text(
                          widget.csvRow[3],
                          softWrap: true, // 자동 줄바꿈 활성화
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: isClicked == false
                      ? Icon(CupertinoIcons.heart)
                      : Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.red,
                        ),
                  onPressed: () {
                    clickedHeart();
                    ref.read(productViewModelProvider.notifier).updateLike(widget.index);
                    print(widget.csvRow[0]);
                  },
                ),
                Text(
                  widget.csvRow[5],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {},
                    child: Text(
                      '채팅하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
          ),
        );
      }
    );
  }
}
