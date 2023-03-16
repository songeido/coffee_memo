//項目の作成
import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  String id;
  String title;
  String detail;
  double? richValue;
  double? bitterValue;
  String? imgUrl;
  Timestamp createdDate;
  Timestamp? updatedDate;

  Memo({
    required this.id,
    required this.title,
    required this.detail,
    this.richValue,
    this.bitterValue,
    this.imgUrl,
    required this.createdDate,
    this.updatedDate,
  });
}

//上記の使い方例
// void test() {
//   Memo newMemo =
//       Memo(title: '新規メモ', detail: '買い出しに行く必要あり', createdDate: DateTime.now());
// }
