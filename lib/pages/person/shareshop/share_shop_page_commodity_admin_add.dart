import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';

class ShareShopPageCommodityAdminAdd extends StatefulWidget {
  final int commodityTypeId;
  final String commodityTypeName;
  final ShopPagesBloc bloc;
  ShareShopPageCommodityAdminAdd(
    this.commodityTypeId,
    this.commodityTypeName,
    this.bloc
  );
  _ShareShopPageCommodityAdminAddState createState() => _ShareShopPageCommodityAdminAddState();
}

class _ShareShopPageCommodityAdminAddState extends State<ShareShopPageCommodityAdminAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _cover, _name, _specs;
  double _price;
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _shareShopPageBloc = BlocProvider.of<ShareShopPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('添加商品'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        width: ScreenUtil().setWidth(750),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildPhoto(_shareShopPageBloc),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '商品类型',
                      ),
                      initialValue: widget.commodityTypeName,
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '商品名称',
                      ),
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '规格',
                      ),
                      onSaved: (value) {
                        _specs = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '单价',
                      ),
                      onSaved: (value) {
                        if (!TextUtil.isEmpty(value)) {
                          _price = double.parse(value);
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("^[0-9,.]*\$")),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        width: ScreenUtil().setWidth(730),
                        height: ScreenUtil().setHeight(70),
                        alignment: Alignment.center,
                        child: Text(
                          '提交', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32)
                          )
                        ),
                      ),
                      onTap: () {
                        _formKey.currentState.save();
                        _shareShopPageBloc.addCommodity(context, _cover, _name, _price, _specs, widget.commodityTypeId, widget.bloc);
                      },
                    )
                  ],
                ),
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
            _cover = sanpshop.data;
            return Image.network(
              sanpshop.data, 
              fit: BoxFit.fill,
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(200),
            );
          } else {
            return Column(
              children: <Widget>[
                ImageIcon(
                  AssetImage(
                    'assets/image_icon/icon_camera.png',
                  ),
                  color: Colors.blue,
                  size: 113,
                ),
                Text('请上传封面图')
              ],
            );
          }
        },
      ),
      onTap: () async {
        await bloc.getShorePhoto();
      },
    );
  }
}