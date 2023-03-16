import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_memo/model/memo.dart';
import 'package:coffee_memo/pages/add_edit_memo_page.dart';
import 'package:flutter/material.dart';

import 'memo_detail_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;
  @override
  State<TopPage> createState() => _TopPage();
}

class _TopPage extends State<TopPage> {
  final memoCollection = FirebaseFirestore.instance.collection('memo');

  Future<void> deleteMemo(String id) async {
    final doc = FirebaseFirestore.instance.collection('memo').doc(id);
    await doc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.brown[300],
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: StreamBuilder<QuerySnapshot>(
                //createdDateの降順（新しい順）
                stream: memoCollection
                    .orderBy('createdDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('データがありません'),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  //メモがない時表示する
                  if (docs.isEmpty) {
                    return const Center(
                      child:
                          Text('メモを作成してください', style: TextStyle(fontSize: 30)),
                    );
                  }
                  return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data =
                            docs[index].data() as Map<String, dynamic>;
                        final Memo fetchMemo = Memo(
                          id: docs[index].id,
                          title: data['title'],
                          detail: data['detail'],
                          richValue: data['richValue'] != null
                              ? data['richValue'].toDouble()
                              : 0.0,
                          bitterValue: data['bitterValue'] != null
                              ? data['bitterValue'].toDouble()
                              : 0.0,
                          imgUrl: data['imgUrl'],
                          createdDate: data['createdDate'],
                          updatedDate: data['updatedDate'],
                        );
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: const Border(),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          child: ListTile(
                            leading: fetchMemo.imgUrl != null
                                ? Image.network(fetchMemo.imgUrl!)
                                : null,
                            title: Center(child: Text(fetchMemo.title)),
                            trailing: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Column(
                                        //ホームボタンなどに重ならないようにするプロパティ
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddEditMemoPage(
                                                    currentMemo: fetchMemo,
                                                  ),
                                                ),
                                              );
                                            },
                                            leading: const Icon(Icons.edit),
                                            title: const Text('編集'),
                                          ),
                                          ListTile(
                                            onTap: () async {
                                              await deleteMemo(fetchMemo.id);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            leading: const Icon(Icons.delete),
                                            title: const Text('削除'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            onTap: () {
                              //確認画面に遷移する際の処理
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MemoDetailPage(fetchMemo),
                                ),
                              );
                            },
                          ),
                        );
                      });
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditMemoPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//class _TopPage extends State<TopPage> {
// firebaseの情報にアクセス
// List<Memo> memoList = [];
//
// //fireStoreにアクセス
// Future<void> fetchMemo() async {
//   final memoCollection =
//       await FirebaseFirestore.instance.collection('memo').get();
//   final docs = memoCollection.docs;
//   for (var doc in docs) {
//     Memo fetchMemo = Memo(
//       title: doc.data()["title"],
//       detail: doc.data()["detail"],
//       createdDate: doc.data()["createdDate"],
//     );
//     memoList.add(fetchMemo);
//   }
//   setState(() {});
// }
// @override
// void initState() {
//   super.initState();
//   fetchMemo();
// }
