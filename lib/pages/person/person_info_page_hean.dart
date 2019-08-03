import 'dart:io';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_info_page_bloc.dart';
import 'package:flutter_swcy/vo/person/person_info_vo.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PersonInfoPageHead extends StatelessWidget {
  final PersonInfoVo personInfoVo;
  PersonInfoPageHead(
    this.personInfoVo
  );
  @override
  Widget build(BuildContext context) {
    final PersonInfoPageBloc _bloc = BlocProvider.of<PersonInfoPageBloc>(context);
    return SliverAppBar(
        expandedHeight: ScreenUtil().setHeight(750),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(personInfoVo.data.nikeName),
          background: _avatar(context, _bloc),
        ),
        actions: <Widget>[
          _editNikeNameIcon(context)
        ],
      );
  }

  // 编辑头像
  Widget _avatar (BuildContext context, PersonInfoPageBloc bloc) {
    return InkWell(
      onTap: () {
        _getImage(context, bloc);
      },
      child: StreamBuilder(
        stream: bloc.fileStream,
        builder: (context, sanpshop) {
          if (sanpshop.data == null) {
            return Image.network(
              personInfoVo.data.avatar, 
              fit: BoxFit.fill
            );
          } else {
            return Image.file(
              bloc.file,
              fit: BoxFit.fill,
            );
          }
        },
      )
    );
  }

  // 编辑昵称
  Widget _editNikeNameIcon (BuildContext context) {
    return InkWell(
      onTap: () {
        // Application.router.navigateTo(context, '/personInfoEditNikeNamePage', transition: TransitionType.inFromRight);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Image.asset(
          'assets/image_icon/icon_edit.png',
          width: 22.0,
        ),
      ),
    );
  }

  // 获取手机图片
  Future _getImage(BuildContext context, PersonInfoPageBloc bloc) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _cropImage(image, context, bloc);
    }
  }

  // 裁剪图片
  Future<Null> _cropImage(File image, BuildContext context, PersonInfoPageBloc bloc) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    bloc.setFile(croppedFile);
    bloc.upDateAvatar(croppedFile, context);
  }
}