import 'package:amap_base/amap_base.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';

class SelectedAddress extends StatefulWidget {
  _SelectedAddressState createState() => _SelectedAddressState();
}

class _SelectedAddressState extends State<SelectedAddress> {
  List<dynamic> _list = [];
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _bloc = BlocProvider.of<ShareShopPageBloc>(context);
    _bloc.initAMapLocation();
    _bloc.getLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text('选择地址'),
      ),
      body: StreamBuilder(
        stream: _bloc.locationStream,
        builder: (context, sanpshop) {
          if (sanpshop.hasData) {
            Location location = sanpshop.data;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        icon: Text(location.city),
                        prefixIcon: Icon(Icons.search),
                        hintText: '请输入仓店地址'
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (String value) {
                        if (!TextUtil.isEmpty(value)) {
                          AMapSearch().searchPoiBound(PoiSearchQuery(city: location.city, query: value, location: LatLng(location.latitude, location.longitude))).then((poiResult) {
                            setState(() {
                              _list = poiResult.pois;
                            });
                          });
                        }
                      },
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil().setHeight(50),
                      child: Row(
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/image_icon/icon_gps.png'), size: 18),
                          Text('地址列表')
                        ],
                      ),
                    ),
                    _buildAddressList()
                  ],
                ),
              ),
            );
          } else {
            return showLoading();
          }
        },
      ),
    );
  }

  Widget _buildAddressList() {
    if (_list.length == 0) {
      return Center(
        child: Text('暂无地址'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              var _addressMsg = {
                'provinceName': _list[index].provinceName,
                'cityName': _list[index].cityName,
                'adName': _list[index].adName,
                'snippet': _list[index].snippet,
                'lat': _list[index].latLonPoint.latitude,
                'lng': _list[index].latLonPoint.longitude
              };
              Navigator.pop(context, _addressMsg);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]
                  )
                )
              ),
              child: ListTile(
                title: Text(_list[index].title),
                subtitle: Text(_list[index].snippet),
              ),
            ),
          );
        },
      );
    }
  }
}