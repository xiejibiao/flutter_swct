import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/shop_page_bloc.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_shop_list_item.dart';
import 'package:flutter_swcy/vo/shop/shop_list_vo.dart';

class ShopPageShopList extends StatefulWidget {
  final ShopListVo shopListVo;
  final int industryId;
  final String latitude;
  final String longitude;
  final ShopPageBloc bloc;
  ShopPageShopList(
    this.shopListVo,
    this.industryId,
    this.latitude,
    this.longitude,
    this.bloc
  );
  _ShopPageShopListState createState() => _ShopPageShopListState();
}

class _ShopPageShopListState extends State<ShopPageShopList> {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  bool theEnd = false;
  @override
  Widget build(BuildContext context) {
    if ((widget.shopListVo.data.pageNumber + 1) == widget.shopListVo.data.totalPage) {
      setState(() {
        theEnd = true;
      });
    } else {
      setState(() {
        theEnd = false;
      });
    }
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
              childAspectRatio: 0.9
            ),
            itemCount: widget.shopListVo.data.list.length,
            itemBuilder: (context, index) {
              return ShopPageShopListItem(widget.shopListVo.data.list[index]);
            },
          ),
          theEnd ? TheEndBaseline() : Text('')
        ],
      ),
      loadMore: () {
        if ((widget.shopListVo.data.pageNumber + 1) < widget.shopListVo.data.totalPage) {
          widget.shopListVo.data.pageNumber++;
          widget.bloc.loadMorePageStore(widget.industryId, widget.latitude, widget.longitude, widget.shopListVo.data.pageNumber, widget.shopListVo.data.pageSize).then((response){
            ShopListVo shopListVo = ShopListVo.fromJson(response);
            setState(() {
              widget.shopListVo.data.list.addAll(shopListVo.data.list);
            });
            if (shopListVo.data.totalPage == (widget.shopListVo.data.pageNumber + 1)) {
              setState(() {
                theEnd = true;
              });
            }
          });
        }
      },
    );
  }
}