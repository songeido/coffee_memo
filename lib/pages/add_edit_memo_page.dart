import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_memo/model/memo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEditMemoPage extends StatefulWidget {
  final Memo? currentMemo;
  const AddEditMemoPage({Key? key, this.currentMemo}) : super(key: key);

  @override
  State<AddEditMemoPage> createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  //イメージファイルの格納変数
  File? imageFile;

  //イメージファイルfirebaseの格納URL
  String? imgUrl;

  //ローディング画面のフラグ
  bool isLoading = false;

  //苦味sliderの値
  double? _bitterValue;

  //苦味sliderの値変更関数
  void _changeBitterSlider(double e) => setState(() {
        _bitterValue = e;
      });

  //コクsliderの値
  double? _richValue;

  //コクsliderの値変更関数
  void _changeRichSlider(double e) => setState(() {
        _richValue = e;
      });

  //画像を取り出す処理
  final picker = ImagePicker();
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  //ローディングフラグの変更関数
  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }

  Future<void> createMemo() async {
    final doc = FirebaseFirestore.instance.collection('memo').doc();

    //imageをfirebaseのstorageにアップロード
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('memo/${doc.id}')
          .putFile(imageFile!);
      imgUrl = await task.ref.getDownloadURL();
    }

    await doc.set({
      'title': titleController.text,
      'detail': detailController.text,
      'richValue': _richValue,
      'bitterValue': _bitterValue,
      'imgUrl': imgUrl,
      'createdDate': Timestamp.now(),
    });
    //final memoCollection = FirebaseFirestore.instance.collection('memo');
    // await memoCollection.add({
    //   'title': titleController.text,
    //   'detail': detailController.text,
    //   'createdDate': Timestamp.now(),
    // });
  }

  Future<void> updateMemo() async {
    final doc = FirebaseFirestore.instance
        .collection('memo')
        .doc(widget.currentMemo!.id);
    await doc.update({
      'title': titleController.text,
      'detail': detailController.text,
      'richValue': _richValue,
      'bitterValue': _bitterValue,
      'imgUrl': imgUrl,
      'updatedDate': Timestamp.now(),
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentMemo != null) {
      titleController.text = widget.currentMemo!.title;
      detailController.text = widget.currentMemo!.detail;
      _richValue = widget.currentMemo!.richValue;
      _bitterValue = widget.currentMemo!.bitterValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //キーボードが出ても画面が動かないようにする、オーバーフロー対策
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.currentMemo == null ? 'Coffeeメモ作成' : 'Coffeeメモ編集'),
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.brown[300],
            ),
            child: SingleChildScrollView(
              child: Column(
                //タイトルを左端にする処理
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: imageFile != null
                          ? Image.file(imageFile!)
                          : Container(
                              color: Colors.brown[100],
                              child: const Center(
                                child: Text("画像",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                    ),
                    onTap: () async {
                      await pickImage();
                    },
                  ),
                  const SizedBox(height: 40),
                  // const Text(
                  //   "タイトル",
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //   ),
                  // ),
                  //const SizedBox(height: 20),
                  //slider実装、味のパラメータを設定できる
                  const Text(
                    "コク",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      label: '$_richValue',
                      min: 0,
                      max: 5,
                      value: _richValue ?? 0,
                      activeColor: Colors.orange,
                      inactiveColor: Colors.blueAccent,
                      divisions: 5,
                      onChanged: _changeRichSlider,
                      //onChangeStart: _startRichSlider,
                      //onChangeEnd: _endRichSlider,
                    ),
                  ),
                  const Text(
                    "苦味",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      label: '$_bitterValue',
                      min: 0,
                      max: 5,
                      value: _bitterValue ?? 0,
                      activeColor: Colors.orange,
                      inactiveColor: Colors.blueAccent,
                      divisions: 5,
                      onChanged: _changeBitterSlider,
                      //onChangeStart: _startBitterSlider,
                      //onChangeEnd: _endBitterSlider,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 3, color: const Color(0xFFD6D6D6)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 10,
                        ),
                        hintText: 'タイトル',
                      ),
                    ),
                  ),
                  //const SizedBox(height: 40),
                  // const Text(
                  //   "感想",
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 3, color: const Color(0xFFD6D6D6)),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      maxLines: null,
                      controller: detailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 10,
                        ),
                        hintText: 'メモ',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                      ),
                      onPressed: () async {
                        try {
                          //Loading開始
                          startLoading();
                          //メモを作成、更新する処理
                          if (widget.currentMemo == null) {
                            await createMemo();
                          } else {
                            await updateMemo();
                          }
                          //エラー
                        } catch (e) {
                          print(e);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //Loading終了
                        } finally {
                          endLoading();
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Text(widget.currentMemo == null ? "追加" : "更新"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
