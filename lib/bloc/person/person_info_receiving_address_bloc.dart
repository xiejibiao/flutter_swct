import 'package:flutter/material.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/common/shared_preferences.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/commen_vo.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';
import 'package:flutter_swcy/vo/person/save_receiving_address_vo.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxdart/rxdart.dart';

class PersonInfoReceivingAddressBloc extends BlocBase {

  ReceivingAddressVo _receivingAddressVo;
  BehaviorSubject<ReceivingAddressVo> _receivingAddressVoController = BehaviorSubject<ReceivingAddressVo>();
  Sink<ReceivingAddressVo> get _receivingAddressVoSink => _receivingAddressVoController.sink;
  Stream<ReceivingAddressVo> get receivingAddressVoStream => _receivingAddressVoController.stream;

  BehaviorSubject<int> _receivingAddressIndexController = BehaviorSubject<int>();
  Sink<int> get _receivingAddressIndexSink => _receivingAddressIndexController.sink;
  Stream<int> get receivingAddressIndexStream => _receivingAddressIndexController.stream;

  String _receiverName, _receiverPhone, _address, _zipCode, _provinceName, _cityName, _areaName;

  setReceiverName(String receiverName) {
    _receiverName = receiverName;
  }

  setReceiverPhone(String receiverPhone) {
    _receiverPhone = receiverPhone;
  }

  setAddress(String address) {
    _address = address;
  }

  setZipCode(String zipCode) {
    _zipCode = zipCode;
  }

  setProvinceName(String provinceName) {
    _provinceName = provinceName;
  }

  setCityName(String cityName) {
    _cityName = cityName;
  }

  setAreaName(String areaName) {
    _areaName = areaName;
  }

  // 添加收货地址
  saveReceivingAddress({@required BuildContext context}) async {
    await getToken().then((token) async {
      var formData = {
        'address': _address,
        'receiverName': _receiverName,
        'receiverPhone': _receiverPhone,
        'zipCode': _zipCode,
        'provinceName': _provinceName,
        'cityName': _cityName,
        'areaName': _areaName,
      };
      await requestPost('saveReceivingAddress', formData: formData, context: context, token: token).then((val) {
        SaveReceivingAddressVo saveReceivingAddressVo = SaveReceivingAddressVo.fromJson(val);
        if (saveReceivingAddressVo.code == '200') {
          showToast('添加收货地址成功');
          Navigator.pop(context, saveReceivingAddressVo.data);
        } else {
          showToast(saveReceivingAddressVo.message);
        }
      });
    });
  }

  /// 获取用户收货地址列表
  getReceivingAddressListByUId(BuildContext context) async {
    await getToken().then((token) {
      requestPost('getReceivingAddressListByUId', token: token, context: context).then((val) {
        _receivingAddressVo = ReceivingAddressVo.fromJson(val);
        _receivingAddressVoSink.add(_receivingAddressVo);
      });
    });
  }

  /// 删除收货地址
  deleteReceivingAddressById({@required int id, @required BuildContext context}) async {
    var formData = {
      'id': id
    };
    await getToken().then((token) async {
      await requestPost('deleteReceivingAddressById', formData: formData, token: token, context: context).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        showToast(commenVo.message);
        if (commenVo.code == '200') {
          getReceivingAddressListByUId(context);
        }
      });
    });
  }

  updateReceivingAddress({@required BuildContext context, @required int id}) async {
    await getToken().then((token) async {
      var formData = {
        'address': _address,
        'receiverName': _receiverName,
        'receiverPhone': _receiverPhone,
        'zipCode': _zipCode,
        'provinceName': _provinceName,
        'cityName': _cityName,
        'areaName': _areaName,
        'id': id
      };
      await requestPost('updateReceivingAddress', formData: formData, context: context, token: token).then((val) {
        CommenVo commenVo = CommenVo.fromJson(val);
        if (commenVo.code == '200') {
          showToast('修改收货地址成功');
          Navigator.pop(context);
        } else {
          showToast(commenVo.message);
        }
      });
    });
  }

  /// 更新收货地址列表
  updateReceivingAddressList(SaveReceivingAddressData saveReceivingAddressData) async {
    ReceivingAddress receivingAddress = ReceivingAddress(
      id: saveReceivingAddressData.id,
      uid: saveReceivingAddressData.uid,
      receiverName: saveReceivingAddressData.receiverName,
      receiverPhone: saveReceivingAddressData.receiverPhone,
      address: saveReceivingAddressData.address,
      zipCode: saveReceivingAddressData.zipCode,
      delFlag: saveReceivingAddressData.delFlag,
      provinceName: saveReceivingAddressData.provinceName,
      cityName: saveReceivingAddressData.cityName,
      areaName: saveReceivingAddressData.areaName
    );
    _receivingAddressVo.data.insert(0, receivingAddress);
    _receivingAddressVoSink.add(_receivingAddressVo);
  }

  /// 修改收货地址下标
  updateReceivingAddressIndex(int index) {
    _receivingAddressIndexSink.add(index);
  }

  @override
  void dispose() {
    _receivingAddressVoController.close();
    _receivingAddressIndexController.close();
  }
}