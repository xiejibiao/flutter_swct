import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_qiniu/flutter_qiniu.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/qiniu_token_vo.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';

class ImageUpload {
  static const String QI_NIU_URI = 'http://qncdn.gdsdec.com/';

  /// 上传多个图片
  Future<List<String>> uploadImages({@required int maxImages, @required String selectionLimitReachedText}) async {
    List<Asset> list = [];
    List<String> resultKeys = [];
    await _getListAsset(maxImages: maxImages, selectionLimitReachedText: selectionLimitReachedText).then((val) {
      list = val;
    });
    if (list.length <= 0) {
      return resultKeys;
    }
    var qiNiuTokenData = await _getQiNiuToken();
    QiNiuTokenVo qiNiuTokenVo = QiNiuTokenVo.fromJson(qiNiuTokenData);
    List<FilePathEntity> entities = [];
    for (var temp in list) {
      var filePatht = await temp.filePath;
      String key = DateTime.now().millisecondsSinceEpoch.toString() + '.' + filePatht.split('.').last;
      FilePathEntity filePathEntity = FilePathEntity(
        token: qiNiuTokenVo.data.token,
        key: key,
        filePath: filePatht
      );
      entities.add(filePathEntity);
    }
    final qiniu = FlutterQiniu(zone: QNFixedZone.zone2);
    List<String> tempKeys = await qiniu.uploadFiles(entities);
    tempKeys.forEach((item) {
      resultKeys.add('$QI_NIU_URI$item');
    });
    return resultKeys;
  }

  /// 先裁剪再上传（仅限单张图片）
  Future<String> tailoringUploadImage() async {
    List<Asset> list = [];
    await _getListAsset(maxImages: 1, selectionLimitReachedText: '请勿选择多张图片').then((val) {
      list = val;
    });
    if (list.length <= 0) {
      return '';
    }
    String filePath = await list[0].filePath;
    // 裁剪图片
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: filePath,
      ratioX: 3.0,
      ratioY: 1.5,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 300,
      // maxHeight: 512,
    );
    if (croppedFile != null) {
      var qiNiuTokenData = await _getQiNiuToken();
      QiNiuTokenVo qiNiuTokenVo = QiNiuTokenVo.fromJson(qiNiuTokenData);
      String key = DateTime.now().millisecondsSinceEpoch.toString() + '.' + croppedFile.path.split('.').last;
      final qiniu = FlutterQiniu(zone: QNFixedZone.zone2);
      String resultKey = await qiniu.uploadFile(croppedFile.path.toString(), key, qiNiuTokenVo.data.token);
      return '$QI_NIU_URI$resultKey';
    }
    return '';
  }
  

  /// 上传一张图片
  Future<String> uploadImage() async {
    List<Asset> list = [];
    await _getListAsset(maxImages: 1, selectionLimitReachedText: '请勿选择多张图片').then((val) {
      list = val;
    });
    if (list.length <= 0) {
      return '';
    }
    var qiNiuTokenData = await _getQiNiuToken();
    QiNiuTokenVo qiNiuTokenVo = QiNiuTokenVo.fromJson(qiNiuTokenData);
    var filePath = await list[0].filePath;
    String key = DateTime.now().millisecondsSinceEpoch.toString() + '.' + filePath.split('.').last;
    final qiniu = FlutterQiniu(zone: QNFixedZone.zone2);
    String resultKey = await qiniu.uploadFile(filePath.toString(), key, qiNiuTokenVo.data.token);
    return '$QI_NIU_URI$resultKey';
  }

  /// 获取图库
  Future<List<Asset>> _getListAsset ({@required int maxImages, @required String selectionLimitReachedText}) async {
    List<Asset> images = List<Asset>();
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: maxImages,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: "#1E90FF",
          statusBarColor: "#1E90FF",
          actionBarTitle: "三维创业",
          allViewTitle: "全部图片",
          selectionLimitReachedText: selectionLimitReachedText,
          useDetailsView: true,
          selectCircleStrokeColor: "#1E90FF",
          textOnNothingSelected: 'textOnNothingSelected',
        ),
      );
    } on Exception catch (e) {
      showToast(e.toString());
    }
    return resultList;
  }

  // 获取七牛云上传token
  Future _getQiNiuToken() async {
    return await requestPost('getQiNiuToken');
  }
}