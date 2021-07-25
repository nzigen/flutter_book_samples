import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class HomeScreenModel extends ChangeNotifier {
  HomeScreenModel() {
    textController.text = '';
  }

  final textController = TextEditingController();
  File? _image;
  File? get image => _image;

  String _uploadedFileUrl = '';
  String _todoText = '';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void createPost() {
    FirebaseFirestore.instance.collection('to-dos').add({
      'name': _todoText,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'imagePath': _uploadedFileUrl.isNotEmpty ? _uploadedFileUrl : '',
      'isCompleted': false,
    });
  }

  void updateTodoIsCompleted({
    required String documentId,
    required bool isCompleted,
  }) {
    FirebaseFirestore.instance
        .collection('to-dos')
        .doc(documentId)
        .update({'isCompleted': isCompleted});
  }

  void updateTodoName({
    required String documentId,
    required String editingText,
  }) {
    FirebaseFirestore.instance
        .collection('to-dos')
        .doc(documentId)
        .update({'name': _todoText.isEmpty ? editingText : _todoText});

    // 編集後空文字を代入することで、再編集時に正しく表示されます
    _todoText = '';
  }

  // 単一のTodoを指定されたFireStore Collectionから削除します
  void deleteTodo(String documentId) {
    FirebaseFirestore.instance.collection('to-dos').doc(documentId).delete();
  }

  void onNameChange(String text) {
    _todoText = text;
  }

  /// 画像ファイルをストレージにアップロードする関数です
  Future uploadFile() async {
    final _picker = ImagePicker();
    final _pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 800,
    );
    _image = File(_pickedFile!.path);

    final _storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${path.basename(_image!.path)}}');
    await _storageReference.putFile(_image!);

    await _storageReference.getDownloadURL().then((fileURL) {
      _uploadedFileUrl = fileURL;
    });
  }
}
