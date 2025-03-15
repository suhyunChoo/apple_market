import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:riverpod/riverpod.dart';

class ProductViewModel extends StateNotifier<List<List<dynamic>>> {
  ProductViewModel() : super([]) {
    _loadCSV();  // 생성자에서 초기화 작업 수행
  }

  Future<void> _loadCSV() async {
    try {
      NumberFormat numberFormat = NumberFormat('#,###');
      final rawData = await rootBundle.loadString('assets/data/dummydata.csv');
      List<List<dynamic>> listData =
          const CsvToListConverter().convert(rawData);

      // 리스트에서 금액을 나타내는 부분을 #,### 형식으로 포매팅
      // 개행문자 인식시키고, 불필요한 '+', '"' 삭제
      for (var row in listData) {
        if (row[5].runtimeType == int) {
          row[3] = row[3].replaceAll('"', '');
          row[3] = row[3].replaceAll('+', '');
          row[3] = row[3].replaceAll('\\n', '\n');
          row[5] = '${numberFormat.format(row[5]).toString()}원';
        }
      }

      state = listData.sublist(2);  // 첫 두 개의 헤더를 제외하고 상태 업데이트
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  // 상품 삭제 메서드
  Future<void> deleteProduct(int index) async {
    List<List<dynamic>> updatedState = List.from(state);  
    updatedState.removeAt(index); 
    state = updatedState;  
  }
  //상품 좋아요 기능
  Future<void> updateLike(int index)async{
    List<List<dynamic>> updatedState = List.from(state);  
    updatedState[index][8] ++;
    state = updatedState;  
  }
}

// ProductViewModel을 제공하는 Provider
final productViewModelProvider = StateNotifierProvider<ProductViewModel, List<List<dynamic>>>((ref) {
  return ProductViewModel();
});
