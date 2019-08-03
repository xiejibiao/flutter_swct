import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/service/service_url.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
            return Center(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: QrImage(
                      data: '$serviceBaseUrl/' + personInfoVo.data.id,
                      size: 350,
                    ),
                  ),
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                        personInfoVo.data.avatar,
                        width: ScreenUtil().setHeight(160),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return showLoading();
          }
        },
      )
    );
  }
}