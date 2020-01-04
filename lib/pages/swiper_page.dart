import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/pages/swiper_page_detail.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperPage extends StatelessWidget {
  final List list;
  SwiperPage(
    this.list
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      child: Swiper(
        autoplay: list.length >= 2 ? true : false,
        loop: list.length >= 2 ? true : false,
        onTap: (index) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => SwiperPageDetail(list[index].content)));
        },
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
            color: Colors.black54,
            activeColor: Colors.white,
        )),
        itemBuilder: (BuildContext context,int index){
          return new Image.network(
            list[index].cover,
            fit: BoxFit.fill
          );
        },
        itemCount: list.length,
      ),
    );
  }
}