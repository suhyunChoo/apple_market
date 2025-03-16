import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applemarket_app/pages/detail_page.dart';
import 'package:flutter_applemarket_app/view_model/product_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 리스너 (스크롤이 최상단에 위치하는지 확인)
  void _scrollListener() {
    if (_scrollController.offset > 1 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 1 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: Consumer(builder: (context, ref, child) {
        // csv 데이터를 읽어오기
        final csvData = ref.watch(productViewModelProvider);
        // 리스트뷰로 표시
        return listviewWidget(csvData, ref);
      }),
      // 최상단으로 스크롤하는 플로팅 버튼 (최상단이 아닐 경우 null)
      floatingActionButton: _isScrolled ? floatingButton() : null,
    );
  }

  //앱바 영역
  AppBar appbar(BuildContext context) {
    return AppBar(
      //타이틀 왼쪽에 배치
      title: Align(alignment: Alignment.centerLeft, child: Text('르탄동')),
      actions: [
        //아이콘 버튼 터치시 스낵바 알림
        IconButton(
          icon: Icon(CupertinoIcons.bell),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('이 메시지는 SnackBar로 표시됩니다!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
      backgroundColor: Colors.grey[200],
    );
  }

  // 스크롤 최상단으로 위치시키는 플로팅 버튼
  FloatingActionButton floatingButton() {
    return FloatingActionButton(
        backgroundColor: _isButtonPressed == false ? Colors.white : Colors.blue,
        onPressed: () {
          setState(() {
            _isButtonPressed = !_isButtonPressed; // 버튼 눌림 상태 변경
          });
          _scrollController.animateTo(
            0.0, // 최상단으로 이동
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
        //버튼이 눌러지면 아이콘 변경
        child: _isButtonPressed == false
            ? Icon(
                Icons.arrow_upward_rounded,
              )
            : Icon(
                Icons.keyboard_arrow_up,
              ));
  }

  //상품 데이터 보여주는 리스트 뷰
  ListView listviewWidget(List<List<dynamic>> csvData, WidgetRef ref) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: csvData.length,
        itemBuilder: (context, index) {
          final csvRow = csvData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // 상품 길게 누를 경우 삭제
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              csvRow: csvRow,
                              index: index,
                            )));
              },
              onLongPress: () {
                dialogWidget(context, ref, index);
              },
              // 상품 리스트
              child: productBox(csvRow),
            ),
          );
        });
  }

  // 상품 사진, 소개등을 보여주는 박스
  Container productBox(List<dynamic> csvRow) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          // 상품 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              width: 100,
              height: double.infinity,
              'assets/images/${csvRow[1]}.png',
              fit: BoxFit.cover,
            ),
          ),
          // 소개, 가격, 주소 등을 보여주는 디테일 박스
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: productDetail(csvRow),
            ),
          ),
        ],
      ),
    );
  }

  // 상품 소개, 가격, 주소 등을 보여주는 디테일 박스
  Column productDetail(List<dynamic> csvRow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //상품명
        Text(
          csvRow[2],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        //주소
        Text(
          csvRow[6],
          style: TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        //가격
        Text(
          csvRow[5],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        //채팅 수, 좋아요 수 표시
        chatLikeBox(csvRow)
      ],
    );
  }

  // 채팅 수, 좋아요 수 표시 박스
  Row chatLikeBox(List<dynamic> csvRow) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //채팅 수
        Icon(CupertinoIcons.chat_bubble_2),
        Text(csvRow[8].toString()),
        SizedBox(width: 4),
        //하트 수
        //사용자가 하트 눌렀는지 체크해서 로직 분기
        csvRow.length >= 10
            ? Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
              )
            : Icon(CupertinoIcons.heart),
        Text(csvRow[7].toString()),
      ],
    );
  }

  // 상품 삭제할 지 묻는 다이얼로그
  Future<dynamic> dialogWidget(BuildContext context, WidgetRef ref, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('해당 상품을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(productViewModelProvider.notifier)
                    .deleteProduct(index);
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
