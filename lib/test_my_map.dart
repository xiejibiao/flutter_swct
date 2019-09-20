import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';

class TestMyMap extends StatefulWidget {
  _TestMyMapState createState() => _TestMyMapState();
}

class _TestMyMapState extends State<TestMyMap> {
  Location _location;
  AMapController _controller;  
  // 初始化定位
  // final _amapLocation = AMapLocation();
  // _initAMapLocation() {
  //   _amapLocation.init();
  // }

  // //  获取定位
  // _getLocation() async {
  //   final options = LocationClientOptions(
  //                     isOnceLocation: true,
  //                     locatingWithReGeocode: true
  //                   );
  //     if (await Permissions().requestPermission()) {
  //       var location = _amapLocation.getLocation(options);
  //       location.then((val) {
  //         setState(() {
  //           _location = val;
  //         });
  //       });
  //     } else {
  //       showToast('权限不足');
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('显示地图0'),
      ),
      body: AMapView(
        onAMapViewCreated: (controller) {
          _controller = controller;
          _controller.setUiSettings(UiSettings(isMyLocationButtonEnabled: true));
          _controller.setMyLocationStyle(
            MyLocationStyle(
              showMyLocation: true,
              myLocationType: LOCATION_TYPE_SHOW,
              radiusFillColor: Colors.red,
            )
          );
          // LatLng latLng1 = LatLng(23.016429, 113.117573);
          // LatLng latLng1 = LatLng(22.966716, 113.008998);
          LatLng latLng1 = LatLng(_location.latitude, _location.longitude);
          _controller.changeLatLng(latLng1);
          // controller.addMarker(MarkerOptions(
          //   position: latLng1,
          //   icon: 'assets/image_icon/icon_receiving_address.png',
          // ));
          _controller.markerClickedEvent.listen((data) {
            print('\n\n');
            print(data);
            print('\n\n');
          });
          // var mapDragEvent = _controller.mapDragEvent;
          // mapDragEvent.skip(0);
          // mapDragEvent.listen((latLng) {
          //   print('\n\n');
          //   print('移动后中心点：${latLng.latitude}');
          //   print('\n\n');
          // });
        },
        amapOptions: AMapOptions(
          compassEnabled: false,
          zoomControlsEnabled: true,
          logoPosition: LOGO_POSITION_BOTTOM_CENTER,
          camera: CameraPosition(
            target: LatLng(_location.latitude, _location.longitude),
            zoom: 15,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _initAMapLocation();
    // _getLocation();
    _location = Location(latitude: 22.966716, longitude: 113.008998);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// import 'package:amap_base/amap_base.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_swcy/bloc/bloc_provider.dart';
// import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
// import 'package:flutter_swcy/common/loading.dart';

// class TestMyMap extends StatefulWidget {
//   _TestMyMapState createState() => _TestMyMapState();
// }

// class _TestMyMapState extends State<TestMyMap> {
//   List<dynamic> _list = [];

//   @override
//   Widget build(BuildContext context) {
//     final ShareShopPageBloc _bloc = BlocProvider.of<ShareShopPageBloc>(context);
//     _bloc.initAMapLocation();
//     _bloc.getLocation();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('选择地址'),
//       ),
//       body: StreamBuilder(
//         stream: _bloc.locationStream,
//         builder: (context, sanpshop) {
//           if (sanpshop.hasData) {
//             Location location = sanpshop.data;
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     TextField(
//                       decoration: InputDecoration(
//                         icon: Text(location.city),
//                         prefixIcon: Icon(Icons.search),
//                         hintText: '请输入仓店地址'
//                       ),
//                       textInputAction: TextInputAction.search,
//                       onSubmitted: (String value) {
//                         AMapSearch().searchPoiBound(PoiSearchQuery(city: location.city, query: value, location: LatLng(location.latitude, location.longitude))).then((poiResult) {
//                           setState(() {
//                             _list = poiResult.pois;
//                           });
//                         });
//                       },
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       height: ScreenUtil().setHeight(50),
//                       child: Row(
//                         children: <Widget>[
//                           ImageIcon(AssetImage('assets/image_icon/icon_gps.png'), size: 18),
//                           Text('地址列表')
//                         ],
//                       ),
//                     ),
//                     _buildAddressList()
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return showLoading();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildAddressList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: _list.length,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             var _addressMsg = {
//               'provinceName': _list[index].provinceName,
//               'cityName': _list[index].cityName,
//               'adName': _list[index].adName,
//               'snippet': _list[index].snippet
//             };
//             Navigator.pop(context, _addressMsg);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey[300]
//                 )
//               )
//             ),
//             child: ListTile(
//               title: Text(_list[index].title),
//               subtitle: Text(_list[index].snippet),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }