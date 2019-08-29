import 'package:city_pickers/city_pickers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/person/person_info_receiving_address_bloc.dart';
import 'package:flutter_swcy/vo/person/receiving_address_vo.dart';
import 'package:oktoast/oktoast.dart';

class PersonInfoReceivingAddressTextFormFieldColumn extends StatefulWidget {
  final PersonInfoReceivingAddressBloc bloc;
  final TextEditingController controller;
  final ReceivingAddress receivingAddress;
  PersonInfoReceivingAddressTextFormFieldColumn(
    this.bloc,
    this.controller,
    this.receivingAddress
  );
  _PersonInfoReceivingAddressTextFormFieldColumnState createState() => _PersonInfoReceivingAddressTextFormFieldColumnState();
}

class _PersonInfoReceivingAddressTextFormFieldColumnState extends State<PersonInfoReceivingAddressTextFormFieldColumn> {
  String _provinceName, _cityName, _areaName;
  @override
  void initState() {
    super.initState();
    if (widget.receivingAddress == null) {
      widget.controller.text = '';
    } else {
      widget.controller.text = '${widget.receivingAddress.provinceName}${widget.receivingAddress.cityName}${widget.receivingAddress.areaName}';
      _provinceName = widget.receivingAddress.provinceName;
      _cityName = widget.receivingAddress.cityName;
      _areaName = widget.receivingAddress.areaName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: widget.receivingAddress == null ? '' : widget.receivingAddress.receiverName,
          decoration: InputDecoration(
            icon: Image.asset(
              'assets/image_icon/icon_person.png',
              width: ScreenUtil().setWidth(48),
              color: Colors.black38,
            ),
            labelText: '收货人',
            labelStyle: TextStyle(
              color: Colors.black38
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            errorStyle: TextStyle(
              color: Colors.black38
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            )
          ),
          validator: (val) {
            if(ObjectUtil.isEmptyString(val)) {
              showToast('请输入收货人');
              return '';
            }
          },
          onSaved: (val) {
            widget.bloc.setReceiverName(val);
          },
        ),
        InkWell(
          onTap: () async {
            await CityPickers.showCityPicker(
              context: context
            ).then((val) {
              if (!ObjectUtil.isEmpty(val)) {
                widget.controller.text = '${val.provinceName}${val.cityName}${val.areaName}';
                _provinceName = val.provinceName;
                _cityName = val.cityName;
                _areaName = val.areaName;
              }
            });
          },
          child: TextFormField(
            controller: widget.controller,
            enabled: false,
            decoration: InputDecoration(
              icon: Image.asset(
                'assets/image_icon/icon_region.png',
                width: ScreenUtil().setWidth(48),
                color: Colors.black38,
              ),
              labelText: '所在地区',
            ),
            onSaved: (val) {
              widget.bloc.setProvinceName(_provinceName);
              widget.bloc.setCityName(_cityName);
              widget.bloc.setAreaName(_areaName);
            },
            validator: (val) {
              if(ObjectUtil.isEmptyString(val)) {
                showToast('请选择所在地区');
                return '';
              }
            },
          ),
        ),
        TextFormField(
          initialValue: widget.receivingAddress == null ? '' : widget.receivingAddress.receiverPhone,          
          decoration: InputDecoration(
            icon: Image.asset(
              'assets/image_icon/icon_phone.png',
              width: ScreenUtil().setWidth(48),
              color: Colors.black38,
            ),
            labelText: '手机号码',
            labelStyle: TextStyle(
              color: Colors.black38
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            errorStyle: TextStyle(
              color: Colors.black38
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            )
          ),
          validator: (val) {
            var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
            if (!phoneRegExp.hasMatch(val)) {
              showToast('您的手机号码未输入或输入有误');
              return '';
            }
          },
          onSaved: (val) {
            widget.bloc.setReceiverPhone(val);
          },
        ),
        TextFormField(
          initialValue: widget.receivingAddress == null ? '' : widget.receivingAddress.address,          
          decoration: InputDecoration(
            icon: Image.asset(
              'assets/image_icon/icon_receiving_address.png',
              width: ScreenUtil().setWidth(48),
              color: Colors.black38,
            ),
            labelText: '详细地址',
            labelStyle: TextStyle(
              color: Colors.black38
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            errorStyle: TextStyle(
              color: Colors.black38
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            )
          ),
          validator: (val) {
            if(ObjectUtil.isEmptyString(val)) {
              showToast('请输入详细地址');
              return '';
            }
          },
          onSaved: (val) {
            widget.bloc.setAddress(val);
          },
        ),
        TextFormField(
          initialValue: widget.receivingAddress == null ? '' : widget.receivingAddress.zipCode,          
          decoration: InputDecoration(
            icon: Image.asset(
              'assets/image_icon/icon_zip_code.png',
              width: ScreenUtil().setWidth(48),
              color: Colors.black38,
            ),
            labelText: '邮政编码',
            labelStyle: TextStyle(
              color: Colors.black38
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            ),
            errorStyle: TextStyle(
              color: Colors.black38
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12
              )
            )
          ),
          onSaved: (val) {
            widget.bloc.setZipCode(val);
          },
        ),
      ],
    );
  }
}

// class PersonInfoReceivingAddressAddTextFormFieldColumn extends StatelessWidget {
//   final PersonInfoReceivingAddressBloc bloc;
//   final TextEditingController controller;
//   final ReceivingAddress receivingAddress;
//   PersonInfoReceivingAddressAddTextFormFieldColumn(
//     this.bloc,
//     this.controller,
//     this.receivingAddress
//   );
//   @override
//   Widget build(BuildContext context) {
//     if (receivingAddress == null) {
//       controller.text = '';
//     } else {
//       controller.text = '${receivingAddress.provinceName}${receivingAddress.cityName}${receivingAddress.areaName}';
//       bloc.setProvinceName(receivingAddress.provinceName);
//       bloc.setCityName(receivingAddress.cityName);
//       bloc.setAreaName(receivingAddress.areaName);
//     }
//     return Column(
//       children: <Widget>[
//         TextFormField(
//           initialValue: receivingAddress == null ? '' : receivingAddress.receiverName,
//           decoration: InputDecoration(
//             icon: Image.asset(
//               'assets/image_icon/icon_person.png',
//               width: ScreenUtil().setWidth(48),
//               color: Colors.black38,
//             ),
//             labelText: '收货人',
//             labelStyle: TextStyle(
//               color: Colors.black38
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             errorStyle: TextStyle(
//               color: Colors.black38
//             ),
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             )
//           ),
//           validator: (val) {
//             if(ObjectUtil.isEmptyString(val)) {
//               showToast('请输入收货人');
//               return '';
//             }
//           },
//           onSaved: (val) {
//             bloc.setReceiverName(val);
//           },
//         ),
//         InkWell(
//           onTap: () async {
//             await CityPickers.showCityPicker(
//               context: context
//             ).then((val) {
//               if (!ObjectUtil.isEmpty(val)) {
//                 controller.text = '${val.provinceName}${val.cityName}${val.areaName}';
//                 bloc.setProvinceName(val.provinceName);
//                 bloc.setCityName(val.cityName);
//                 bloc.setAreaName(val.areaName);
//               }
//             });
//           },
//           child: TextFormField(
//             controller: controller,
//             enabled: false,
//             decoration: InputDecoration(
//               icon: Image.asset(
//                 'assets/image_icon/icon_region.png',
//                 width: ScreenUtil().setWidth(48),
//                 color: Colors.black38,
//               ),
//               labelText: '所在地区',
//             ),
//             validator: (val) {
//             if(ObjectUtil.isEmptyString(val)) {
//               showToast('请选择所在地区');
//               return '';
//             }
//           },
//           ),
//         ),
//         TextFormField(
//           initialValue: receivingAddress == null ? '' : receivingAddress.receiverPhone,          
//           decoration: InputDecoration(
//             icon: Image.asset(
//               'assets/image_icon/icon_phone.png',
//               width: ScreenUtil().setWidth(48),
//               color: Colors.black38,
//             ),
//             labelText: '手机号码',
//             labelStyle: TextStyle(
//               color: Colors.black38
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             errorStyle: TextStyle(
//               color: Colors.black38
//             ),
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             )
//           ),
//           validator: (val) {
//             var phoneRegExp = RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
//             if (!phoneRegExp.hasMatch(val)) {
//               showToast('您的手机号码未输入或输入有误');
//               return '';
//             }
//           },
//           onSaved: (val) {
//             bloc.setReceiverPhone(val);
//           },
//         ),
//         TextFormField(
//           initialValue: receivingAddress == null ? '' : receivingAddress.address,          
//           decoration: InputDecoration(
//             icon: Image.asset(
//               'assets/image_icon/icon_receiving_address.png',
//               width: ScreenUtil().setWidth(48),
//               color: Colors.black38,
//             ),
//             labelText: '详细地址',
//             labelStyle: TextStyle(
//               color: Colors.black38
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             errorStyle: TextStyle(
//               color: Colors.black38
//             ),
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             )
//           ),
//           validator: (val) {
//             if(ObjectUtil.isEmptyString(val)) {
//               showToast('请输入详细地址');
//               return '';
//             }
//           },
//           onSaved: (val) {
//             bloc.setAddress(val);
//           },
//         ),
//         TextFormField(
//           initialValue: receivingAddress == null ? '' : receivingAddress.zipCode,          
//           decoration: InputDecoration(
//             icon: Image.asset(
//               'assets/image_icon/icon_zip_code.png',
//               width: ScreenUtil().setWidth(48),
//               color: Colors.black38,
//             ),
//             labelText: '邮政编码',
//             labelStyle: TextStyle(
//               color: Colors.black38
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             focusedErrorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             ),
//             errorStyle: TextStyle(
//               color: Colors.black38
//             ),
//             errorBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black12
//               )
//             )
//           ),
//           onSaved: (val) {
//             bloc.setZipCode(val);
//           },
//         ),
//       ],
//     );
//   }
// }