import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_applemarket_app/detail_page.dart';
import 'package:flutter_applemarket_app/product_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
//**Q3. FloatingActionButton을 누르면 아이콘이 바뀌어야 하는데, 계속 눌린 상태로 유지됩니다.**

// A3. 버튼이 눌렸을 때와 떼었을 때의 상태를 구분해야 합니다. 
//**사용자의 인터랙션에 따라 UI가 어떻게 변경되는지** 생각해 보고, 
//눌림과 해제 상태를 다르게 처리할 수 있는 방법을 고민해 보세요.
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
      appBar: AppBar(
        title: Align(alignment: Alignment.centerLeft, child: Text('르탄동')),
        actions: [
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
      ),
      body: Consumer(
        builder: (context,ref,child) {

        final csvData = ref.watch(productViewModelProvider);
          return ListView.builder(
              controller: _scrollController,
              itemCount: csvData.length,
              itemBuilder: (context, index) {
                final csvRow = csvData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    csvRow: csvRow,index: index,
                                  )));
                    },
                    onLongPress: () {
                      showDialog(
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
                                  ref.read(productViewModelProvider.notifier).deleteProduct(index);
                                  Navigator.of(context).pop(); 
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              width: 100,
                              height: double.infinity,
                              'assets/images/${csvRow[1]}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    csvRow[2],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    csvRow[6],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    csvRow[5],
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(CupertinoIcons.chat_bubble_2),
                                      Text(csvRow[8].toString()),
                                      SizedBox(width: 4),
                                      csvRow.length >= 10 ?
                                      Icon(CupertinoIcons.heart_fill,
                                      color: Colors.red,)
                                      :Icon(CupertinoIcons.heart),
                                      Text(csvRow[7].toString()),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
      ),
      floatingActionButton: _isScrolled
          ? FloatingActionButton(
              backgroundColor:
                  _isButtonPressed == false ? Colors.white : Colors.blue,
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
              child: _isButtonPressed == false
                  ? Icon(
                      Icons.arrow_upward_rounded,
                    )
                  : Icon(
                      Icons.keyboard_arrow_up,
                    ))
          : null,
    );
  }
}
