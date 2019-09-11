import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sujian_select/flutter_select.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/vo/shop/store_industry_list_from_cache_vo.dart';

class ShareShopPageAdd extends StatefulWidget {
  _ShareShopPageAddState createState() => _ShareShopPageAddState();
}

class _ShareShopPageAddState extends State<ShareShopPageAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<StoreIndustryListFromCacheVo> _industryList = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();

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
    final ShareShopPageBloc _bloc = BlocProvider.of<ShareShopPageBloc>(context);
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
                    _buildPhoto(_bloc),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店名称'
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店法人'
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '仓店地址'
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _bloc.initAMapLocation();
                            _bloc.getLocation(_controller, _controller1);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setHeight(60),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(40)
                            ),
                            child: Text(
                              '获取当前定位',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: _controller1,
                      decoration: InputDecoration(
                        labelText: '街道',
                        counterText: '定位不准确？请手动输入就近地址'
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '仓店面积'
                      ),
                    ),
                    InkWell(
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: '行业类型',
                        ),
                      ),
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return _buildSelectedIndustry();
                          }
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(100)),
              Row(
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
                      print('提交');
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 192, 159, 1),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text(
                        '添加认证',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(32)
                        ),
                      ),
                    ),
                    onPressed: () {
                      print('添加认证');
                    },
                  )
                ],
              )
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
        await bloc.getShorePhoto();
      },
    );
  }

  Widget _buildSelectedIndustry() {
    return Container(
      alignment: Alignment.centerLeft,
      height: ScreenUtil().setHeight(450),
      child: SingleChildScrollView(
        child: SelectGroup<int>(
          index:0,
          direction: SelectDirection.vertical,
          space: EdgeInsets.all(10),
          selectColor: Colors.blue,
          items: _industryList.map((item) {
            return SelectItem(label: item.name, value: item.id);
          }).toList(),
          onSingleSelect: (int value){
            print(value);
          },
        ),
      ),
    );
  }
}