import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_grid_view_item.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/service/service_method.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageSearch extends StatefulWidget {
  final String latitude, longitude;
  ShopPageSearch(
    this.latitude,
    this.longitude
  );
  _ShopPageSearchState createState() => _ShopPageSearchState();
}

class _ShopPageSearchState extends State<ShopPageSearch> {
  int pageNumber = 0;
  int pageSize = 10;
  ShopListVo shopListVo;
  bool isTheEnd = false;
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTextField(),
      ),
      body: shopListVo == null ? 
            Center(
              child: Text('查找商家'),
            ) : shopListVo.data.list.length == 0 ? ShopPageSearchDefaultPage() : _buildEasyRefresh()
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: textEditingController,
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        height: 1.2
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30), 
          ),
          borderSide: BorderSide(
            color: Colors.amber, 
            width: 2, 
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30), 
          ),
          borderSide: BorderSide(
            color: Colors.amber, 
            width: 2, 
          )
        ),
        hintText: '搜索',
        hintStyle: TextStyle(
          color: Colors.grey[300]
        )
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        getPageSearchStore(widget.latitude, widget.longitude, value);
      },
    );
  }

  Widget _buildEasyRefresh() {
    return EasyRefresh.custom(
      footer: BallPulseFooter(
        enableHapticFeedback: true,
        enableInfiniteLoad: false
      ),
      slivers: <Widget>[
        ShopPageGridViewItem(shopListVo.data.list),
        SliverToBoxAdapter(
          child: isTheEnd ? TheEndBaseline() : Container()
        )
      ],
      onLoad: () async {
        if ((shopListVo.data.pageNumber + 1) < shopListVo.data.totalPage) {
          await loadMoreShopPage(widget.latitude, widget.longitude, textEditingController.text);
        }
      }
    );
  }

  // 查找商家
  getPageSearchStore(String lat, String lng, String name) async {
    if (name != '') {
      pageNumber = 0;
      var formData = {
        'lat': lat,
        'lng': lng,
        'name': name,
        'pageNumber': pageNumber,
        'pageSize': pageSize
      };
      await requestPost('getPageSearchStore', formData: formData).then((val) {
        setState(() {
          shopListVo = ShopListVo.fromJson(val);
        });
        if (shopListVo.data.totalPage == (pageNumber + 1)) {
          setState(() {
            isTheEnd = true;
          });
        } else {
          setState(() {
            isTheEnd = false;
          });
        }
      });
    }
  }

  loadMoreShopPage(String lat, String lng, String name) async {
    if (name != '') {
      pageNumber++;
      var formData = {
        'lat': lat,
        'lng': lng,
        'name': name,
        'pageNumber': pageNumber,
        'pageSize': pageSize
      };
      await requestPost('getPageSearchStore', formData: formData).then((val) {
        ShopListVo temp = ShopListVo.fromJson(val);
        setState(() {
          this.shopListVo.data.list.addAll(temp.data.list);
        });
        if (this.shopListVo.data.totalPage == (pageNumber + 1)) {
          setState(() {
            isTheEnd = true;
          });
        }
      });
    }
  }
}