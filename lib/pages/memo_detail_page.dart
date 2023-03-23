import 'package:coffee_memo/model/memo.dart';
import 'package:flutter/material.dart';

class MemoDetailPage extends StatelessWidget {
  final Memo memo;
  const MemoDetailPage(this.memo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(memo.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.brown[300],
        ),
        child: Center(
          child: Column(
            //中心に持ってくる処理
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              //画像
              SizedBox(
                height: 200,
                width: 200,
                child: memo.imgUrl != null
                    ? Image.network(memo.imgUrl!)
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                            child: Text(
                          '画像なし',
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
              ),
              // const Text(
              //   "感想",
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                decoration: BoxDecoration(
                  //border: Border.all(width: 5, color: Colors.brown),
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  //真ん中に寄せる
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "コク：${memo.richValue?.toInt()}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Text(
                      "苦味：${memo.bitterValue?.toInt()}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //感想
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 150, //最小の高さ
                  minWidth: 250,
                ),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    //border: Border.all(width: 5, color: Colors.brown),
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    memo.detail,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
