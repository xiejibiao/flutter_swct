import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_list_item.dart';
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

class _ShopPageSearchState extends State<ShopPageSearch> with AutomaticKeepAliveClientMixin {
  int pageNumber = 0;
  int pageSize = 10;
  ShopListVo shopListVo;
  bool isTheEnd = false;
  final textEditingController = TextEditingController();
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

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

  @override
  bool get wantKeepAlive => true;

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
    return EasyRefresh(
      refreshFooter: ClassicsFooter(
        key: _footerKey,
        bgColor: Colors.blue[200],
        textColor: Colors.white,
        moreInfoColor: Colors.white,
        showMore: true,
        loadingText: '加载中...',
        moreInfo: '上次加载 %T',
        noMoreText: '加载完成...',
        loadReadyText: '松手加载...',
        loadText: '上拉加载更多...',
      ),
      child: ListView(
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0
            ),
            itemCount: shopListVo.data.list.length,
            itemBuilder: (context, index) {
              return ShopPageShopListItem(shopListVo.data.list[index]);
            },
          ),
          isTheEnd ? TheEndBaseline() : Text('')
        ],
      ),
      loadMore: () {
        if ((shopListVo.data.pageNumber + 1) < shopListVo.data.totalPage) {
          loadMoreShopPage(widget.latitude, widget.longitude, textEditingController.text);
        }
      },
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