import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sujian_select/flutter_select.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/pages/person/shareshop/selected_address.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_from_cache_vo.dart';
import 'package:oktoast/oktoast.dart';

class ShareShopPageAdd extends StatefulWidget {
  final ShareShopPageBloc bloc;
  ShareShopPageAdd(
    this.bloc
  );
  _ShareShopPageAddState createState() => _ShareShopPageAddState();
}

class _ShareShopPageAddState extends State<ShareShopPageAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<StoreIndustryListFromCacheVo> _industryList = [];
  /// 省市区控制器
  final TextEditingController _provinceAndCityController = TextEditingController();
  /// 行业控制器
  final TextEditingController _industryConroller = TextEditingController();
  /// 行业临时控制器
  final TextEditingController _industryTempConroller = TextEditingController();
  /// 共享星级控制器
  final TextEditingController _starCodeConroller = TextEditingController();
  /// 共享星级临时控制器
  final TextEditingController _starCodeTempConroller = TextEditingController();
  String _photo, _address, _provinceName, _cityName, _areaName, _industryName, _legalPerson, _name, _area, _lat, _lng, _phone;
  int _industryId, _industryIndex = 0, _starCode, _starCodeIndex = 0;

  final _starCodeList = [
    {
      'id': 1,
      'title': '1星共享'
    },
    {
      'id': 2,
      'title': '2星共享'
    },
    {
      'id': 3,
      'title': '3星共享'
    },
    {
      'id': 4,
      'title': '4星共享'
    },
    {
      'id': 5,
      'title': '5星共享'
    },
    {
      'id': 6,
      'title': '6星共享'
    },
    {
      'id': 7,
      'title': '7星共享'
    },
    {
      'id': 8,
      'title': '8星共享'
    },
    {
      'id': 9,
      'title': '9星共享'
    },
    {
      'id': 10,
      'title': '10星共享'
    }
  ];

  @override
  void initState() { 
    super.initState();
    _initStoreIndustryListData();
  }

  _initStoreIndustryListData() async {
    await ShopPageBloc().getStoreIndustryListFromCache().then((data) {
      _industryList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _newBloc = BlocProvider.of<ShareShopPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('添加共享店'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildPhoto(_newBloc),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店名称'
                      ),
                      onSaved: (String value) {
                        _name = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店法人'
                      ),
                      onSaved: (String value) {
                        _legalPerson = value;
                      },
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(bloc: ShareShopPageBloc(), child: SelectedAddress()))).then((addressMsg) {
                          _provinceName = addressMsg['provinceName'];
                          _cityName = addressMsg['cityName'];
                          _areaName = addressMsg['adName'];
                          _address = addressMsg['snippet'];
                          _lat = addressMsg['lat'].toString();
                          _lng = addressMsg['lng'].toString();
                          _provinceAndCityController.text = '$_provinceName$_cityName$_areaName$_address';
                        });
                      },
                      child: TextFormField(
                        controller: _provinceAndCityController,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '仓店地址'
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '门牌号'
                      ),
                      onSaved: (String value) {
                        if (TextUtil.isEmpty(value)) {
                          showToast('请输入门牌号');
                        } else {
                          _address = '$_address$value';
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店面积',
                        suffixIcon: Container(
                          width: ScreenUtil().setWidth(100),
                          alignment: Alignment.centerRight,
                          child: Text('平方'),
                        ),
                      ),
                      onSaved: (String value) {
                        _area = value;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("^[0-9,.]*\$")),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '联系电话'
                      ),
                      onSaved: (String value) {
                        _phone = value;
                      },
                    ),
                    InkWell(
                      child: TextFormField(
                        controller: _industryConroller,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '行业类型',
                        ),
                      ),
                      onTap: () async {
                        _industryConroller.text = _industryList[_industryIndex].name;
                        _industryTempConroller.text = '{"id": "${_industryList[_industryIndex].id}", "name": "${_industryList[_industryIndex].name}"}';
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return _buildSelectedIndustry();
                          }
                        );
                      },
                    ),
                    InkWell(
                      child: TextFormField(
                        controller: _starCodeConroller,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '共享星级',
                        ),
                      ),
                      onTap: () async {
                        _starCodeConroller.text = _starCodeList[_starCodeIndex]['title'];
                        _starCodeTempConroller.text = _starCodeList[_starCodeIndex]['id'].toString();
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return _buildSelectedStarCode();
                          }
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(100)),
              _buildButtom(widget.bloc)
            ],
          ),
        ),
      ),
    );
  }

  // 门头照
  Widget _buildPhoto(ShareShopPageBloc bloc) {
    return InkWell(
      child: StreamBuilder(
        stream: bloc.shorePhotoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            _photo = sanpshop.data;
            return Image.network(
              sanpshop.data, 
              fit: BoxFit.fill,
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(200),
            );
          } else {
            return ImageIcon(
              AssetImage(
                'assets/image_icon/icon_camera.png',
              ),
              color: Colors.blue,
              size: 113,
            );
          }
        },
      ),
      onTap: () async {
        await bloc.addCommodityGetShorePhoto();
      },
    );
  }

  // 行业选择器
  Widget _buildSelectedIndustry() {
    return Container(
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setHeight(450),
      child: SingleChildScrollView(
        child: SelectGroup<int>(
          index: _industryIndex,
          direction: SelectDirection.vertical,
          space: EdgeInsets.all(10),
          selectColor: Colors.blue,
          items: _industryList.map((item) {
            return SelectItem(label: item.name, value: item.id);
          }).toList(),
          onSingleSelect: (int index){
            _industryIndex = index;
            _industryConroller.text = _industryList[_industryIndex].name;
            _industryTempConroller.text = '{"id": ${_industryList[_industryIndex].id}, "name": "${_industryList[_industryIndex].name}"}';
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // 星级选择器
  Widget _buildSelectedStarCode() {
    return Container(
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setHeight(450),
      child: SingleChildScrollView(
        child: SelectGroup<int>(
          index: _starCodeIndex,
          direction: SelectDirection.vertical,
          space: EdgeInsets.all(10),
          selectColor: Colors.blue,
          items: _starCodeList.map((item) {
            return SelectItem(label: item['title'], value: int.parse(item['id'].toString()));
          }).toList(),
          onSingleSelect: (int index){
            _starCodeIndex = index;
            _starCodeConroller.text = _starCodeList[_starCodeIndex]['title'];
            _starCodeTempConroller.text = _starCodeList[_starCodeIndex]['id'].toString();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // 提交，添加认证按钮
  Widget _buildButtom(ShareShopPageBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          splashColor: Colors.white,
          highlightColor: Colors.white,
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setHeight(80),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Text(
              '提交',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(32)
              ),
            ),
          ),
          onPressed: () {
            // 行业
            if (TextUtil.isEmpty(_industryTempConroller.text)) {
              showToast('请选择行业');
            } else if (TextUtil.isEmpty(_starCodeTempConroller.text)) {
              showToast('请选择共享星级');
            } else {
              StoreIndustryListFromCacheVo storeIndustryListFromCacheVo = StoreIndustryListFromCacheVo.fromJson(json.decode(_industryTempConroller.text));
              _industryId = storeIndustryListFromCacheVo.id;
              _industryName = storeIndustryListFromCacheVo.name;
              _starCode = int.parse(_starCodeTempConroller.text);
              _formKey.currentState.save();
              bloc.submitEssentialMsg(
                          context: context,
                          photo: _photo, 
                          address: _address, 
                          provinceName: _provinceName, 
                          cityName: _cityName, 
                          areaName: _areaName, 
                          industryName: _industryName, 
                          legalPerson: _legalPerson,
                          name: _name, 
                          area: _area, 
                          industryId: _industryId,
                          lat: _lat,
                          lng: _lng,
                          starCode: _starCode,
                          phone: _phone);
            }
          },
        ),
      ],
    );
  }
}