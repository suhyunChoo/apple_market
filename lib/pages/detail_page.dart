import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applemarket_app/view_model/product_view_model.dart';
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

  void clickedLike() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
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
        body: detailView(),
        bottomNavigationBar: bottomBar(ref),
      );
    });
  }

  // 상품 디테일 정보 보여주는 디테일 뷰
  SingleChildScrollView detailView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DetailImage(widget: widget),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //사용자 닉네임, 상품 가격, 주소 등의 정보
                ProductDetailBox(widget: widget),
                Divider(),
                //상품 이름, 소개 정보
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
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 바텀 앱 바 (좋아요, 가격, 채팅하기)
  BottomAppBar bottomBar(WidgetRef ref) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          widget.csvRow.length >= 10
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    clickedLike();
                    ref
                        .read(productViewModelProvider.notifier)
                        .updateUnlike(widget.index);
                  },
                )
              : IconButton(
                  icon: Icon(CupertinoIcons.heart),
                  onPressed: () {
                    clickedLike();
                    ref
                        .read(productViewModelProvider.notifier)
                        .updateLike(widget.index);
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
    );
  }
}

// 사용자 닉네임, 주소, 매너온도 표시
class ProductDetailBox extends StatelessWidget {
  const ProductDetailBox({
    super.key,
    required this.widget,
  });

  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}

// 디테일 페이지 상품 이미지 표시 부분
class DetailImage extends StatelessWidget {
  const DetailImage({
    super.key,
    required this.widget,
  });

  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/${widget.csvRow[1]}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
