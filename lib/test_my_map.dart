import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

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

  //  获取定位
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
        title: Text('显示地图'),
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