import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
// import 'package:flutter_swcy/service/service_url.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:transparent_image/transparent_image.dart';

class PersonSharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的分享码'),
      ),
      body: StreamBuilder(
        stream: _bloc.personInfoVoStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            PersonInfoVo personInfoVo = sanpshop.data;
            _bloc.commendQrcode(personInfoVo.data.id);
            return StreamBuilder(
              stream: _bloc.commendQrcodeStrStream,
              builder: (context, commendQrcodeStrSanpshop) {
                if (commendQrcodeStrSanpshop.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[                      
                      Container(
                        child: Stack(
                          children: <Widget>[
//                            FadeInImage.memoryNetwork(
//                              placeholder: kTransparentImage,
//                              image: 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQEe8TwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyaHFNTmNQQXlmQ0YxMDAwME0wN3EAAgTjPqVfAwQAAAAA',
//                            ),
//                            FadeInImage.memoryNetwork(
//                              placeholder: kTransparentImage,
//                              image: commendQrcodeStrSanpshop.data,
//                            ),
                            QrImage(data: commendQrcodeStrSanpshop.data),
                            Center(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                  personInfoVo.data.avatar,
                                  width: ScreenUtil().setHeight(100),
                                  height: ScreenUtil().setHeight(100),
                                ),
                              ),
                            )
                          ],
                        ),
                        width: ScreenUtil().setWidth(750),
                        height: ScreenUtil().setWidth(750),
                      ),
                      Text(
                        '扫一扫或长按二维码 ~ 关注公众号下载三维创业',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ScreenUtil().setSp(32)
                        ),
                      )
                    ],
                  );
                } else {
                  return showLoading();
                }
              },
            );
          } else {
            return showLoading();
          }
        },
      )
    );
  }
}