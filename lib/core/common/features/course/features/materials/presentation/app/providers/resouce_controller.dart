import 'dart:io';

import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceController extends ChangeNotifier{

  ResourceController(
  {required SharedPreferences prefs,
    required FirebaseStorage storage,}
      ):
    _firebaseStorage = storage,
    _sharedPreferences = prefs;


  final SharedPreferences _sharedPreferences;
  final FirebaseStorage _firebaseStorage;

  Resources? _resources;
  bool _loading = false;
  bool _downloading = false;

  double _percentage = 0;

  Resources? get getResource => _resources;
  bool get getLoading => _loading;
  bool get getDownloading => _downloading;
  double get getPercentage => _percentage;
  String get _pathKey => 'material_file_path${_resources!.id}';

  void init(Resources resources){
    if(_resources == resources) return;
    _resources = resources;
  }


  bool get fileExists {
    final cachedFilePath = _sharedPreferences.getString(_pathKey);
    if (cachedFilePath == null) return false;
    final file = File(cachedFilePath);
    final fileExists = file.existsSync();
    if (!fileExists) _sharedPreferences.remove(_pathKey);
    return fileExists;
  }

  Future<File> _getFileFromCache() async {
    final cachedFilePath = _sharedPreferences.getString(_pathKey);
    return File(cachedFilePath!);
  }

  Future<File?> downloadAndSave()async{
    _loading = true;
    _downloading = true;
    notifyListeners();
    final cacheDir = await getTemporaryDirectory();
    final file = File(
      '${cacheDir.path}/${_resources!.id}.${_resources!.fileExtension}',);
    if(file.existsSync()) return file;

    try{
      final fileRef = _firebaseStorage.refFromURL(_resources!.url);
      var successful = false;
      final downloadTask = fileRef.writeToFile(file);
      downloadTask.snapshotEvents.listen((taskSnapShot) async{
        switch(taskSnapShot.state){
          case TaskState.running:
            _percentage = taskSnapShot.bytesTransferred
                / taskSnapShot.totalBytes;
            notifyListeners();
          case TaskState.paused:
            break;
          case TaskState.success:
            _downloading = false;
            await _sharedPreferences.setString(_pathKey, file.path);
            successful = true;
          case TaskState.canceled:
            successful = false;
          case TaskState.error:
            successful = false;
        }
      });
      await downloadTask;
      return successful? file:null;
    }catch(e){
      return null;
    }finally{
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await file.delete();
      await _sharedPreferences.remove(_pathKey);
    }
  }

  Future<void> openFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await OpenFile.open(file.path);
    }
  }

}
