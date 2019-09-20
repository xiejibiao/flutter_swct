import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';

class ShareShopPageAuthentication extends StatefulWidget {
  final int id;
  final ShareShopPageBloc bloc;
  ShareShopPageAuthentication({
    @required this.id,
    @required this.bloc,
  });
  _ShareShopPageAuthenticationState createState() => _ShareShopPageAuthenticationState();
}

class _ShareShopPageAuthenticationState extends State<ShareShopPageAuthentication> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _licenseCode;
  String _licensePhoto;

  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _newBloc = BlocProvider.of<ShareShopPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('共享店认证'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildPhoto(_newBloc),
                  Text('请上传营业执照')
                ],
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '执照代码'
                  ),
                  onSaved: (value) {
                    _licenseCode = value;
                  },
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(100)),
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
                  _formKey.currentState.save();
                  widget.bloc.submitAuthenticationMsg(context: context, id: widget.id, licenseCode: _licenseCode, licensePhoto: _licensePhoto);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // 营业执照
  Widget _buildPhoto(ShareShopPageBloc newBloc) {
    return InkWell(
      child: StreamBuilder(
        stream: newBloc.shorePhotoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            _licensePhoto = sanpshop.data;
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
        FocusScope.of(context).requestFocus(FocusNode());
        await newBloc.getShorePhoto();
      },
    );
  }
}