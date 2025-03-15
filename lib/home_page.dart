import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_applemarket_app/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final rawData = await rootBundle.loadString('assets/data/dummydata.csv');
      List<List<dynamic>> listData =
          const CsvToListConverter().convert(rawData);

      setState(() {
        csvData = listData.sublist(2);
      });
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('르탄동'),
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
        body: ListView.builder(
            itemCount: csvData.length,
            itemBuilder: (context, index) {
              final csvRow = csvData[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPage(csvRow: csvRow,)));
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('assets/images/${csvRow[1]}.png'),
                              fit: BoxFit.cover,
                            ),
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
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  csvRow[6],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  ' ${csvRow[5].toString()}원',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(CupertinoIcons.chat_bubble_2),
                                    Text(csvRow[8].toString()),
                                    Icon(CupertinoIcons.heart),
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
            }));
  }
}
