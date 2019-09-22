import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/vo/shop/commodity_page_by_commodity_type_vo.dart';

class ShareShopPageCommodityAdminAddEdit extends StatefulWidget {
  final int commodityTypeId;
  final String commodityTypeName;
  final ShopPagesBloc bloc;
  final CommodityList item;
  final bool isAdd;
  ShareShopPageCommodityAdminAddEdit(
    this.commodityTypeId,
    this.commodityTypeName,
    this.bloc,
    this.isAdd,
    {this.item}
  );
  _ShareShopPageCommodityAdminAddEditState createState() => _ShareShopPageCommodityAdminAddEditState();
}

class _ShareShopPageCommodityAdminAddEditState extends State<ShareShopPageCommodityAdminAddEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _cover, _name, _specs;
  double _price;
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _shareShopPageBloc = BlocProvider.of<ShareShopPageBloc>(context);
    _cover = widget.item == null ? '' : widget.item.cover;
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
                      initialValue: widget.item == null ? '' : widget.item.name,
                      decoration: InputDecoration(
                        labelText: '商品名称',
                      ),
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.item == null ? '' : widget.item.specs,
                      decoration: InputDecoration(
                        labelText: '规格',
                      ),
                      onSaved: (value) {
                        _specs = value;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.item == null ? '' : '${widget.item.price}',
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
                        switch (widget.isAdd) {
                          case true:
                            _shareShopPageBloc.addCommodity(context, _cover, _name, _price, _specs, widget.commodityTypeId, widget.bloc);
                            break;
                          default:
                            _shareShopPageBloc.editCommodity(context, _cover, widget.item.id, _name, _price, _specs, widget.commodityTypeId, widget.bloc);
                        }
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
              _cover, 
              fit: BoxFit.fill,
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(200),
            );
          } else {
            return widget.item == null ?
              Column(
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
              ) :
              Image.network(
                _cover, 
                fit: BoxFit.fill,
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setWidth(200),
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