import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/store_page_bloc.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/shop/shop_page_search_default_page.dart';
import 'package:flutter_swcy/pages/store/store_page_list_item.dart';
import 'package:flutter_swcy/vo/shop/news_get_page_store_vo.dart';

class StorePageList extends StatefulWidget {
  final NewsGetPageStoreDto newsGetPageStoreDto;
  final int industryId;
  final StoreMap storeMap;
  StorePageList(
    this.newsGetPageStoreDto,
    this.storeMap,
    this.industryId
  );
  _StorePageListState createState() => _StorePageListState();
}

class _StorePageListState extends State<StorePageList> with AutomaticKeepAliveClientMixin {
  StoreMap newStoreMap;
  @override
  void initState() { 
    super.initState();
    newStoreMap = widget.storeMap;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final StorePageBloc _storePageBloc = BlocProvider.of<StorePageBloc>(context);
    return Scaffold(
      body: newStoreMap.count == 0 ? 
              InkWell(
                child: ShopPageSearchDefaultPage(),
                onTap: () {
                  _storePageBloc.loadMoreStore(widget.industryId, widget.newsGetPageStoreDto.lat, widget.newsGetPageStoreDto.lng, 0, 10).then((val) {
                    StoreMap tempStoreMap = StoreMap.fromJson(val['data']);
                    newStoreMap = tempStoreMap;
                    setState(() {});
                  });
                },
              ) :
              EasyRefresh.custom(
                header: BallPulseHeader(),
                footer: BallPulseFooter(
                  enableHapticFeedback: true,
                  enableInfiniteLoad: false
                ),
                slivers: <Widget>[
                  StorePageListItem(newStoreMap),
                  SliverToBoxAdapter(
                    child: newStoreMap.list.length == newStoreMap.count ? TheEndBaseline() : Container(),
                  )
                ],
                onLoad: () async {
                  if (newStoreMap.pageNumber + 1 == newStoreMap.totalPage) {
                    return null;
                  }
                  return await _storePageBloc.loadMoreStore(widget.industryId, widget.newsGetPageStoreDto.lat, widget.newsGetPageStoreDto.lng, newStoreMap.pageNumber + 1, 10).then((val) {
                    StoreMap tempStoreMap = StoreMap.fromJson(val['data']);
                    newStoreMap.pageNumber = newStoreMap.pageNumber + 1;
                    newStoreMap.list.addAll(tempStoreMap.list);
                    setState(() {});
                  });
                },
                onRefresh: () async {
                  await _storePageBloc.loadMoreStore(widget.industryId, widget.newsGetPageStoreDto.lat, widget.newsGetPageStoreDto.lng, 0, 10).then((val) {
                    StoreMap tempStoreMap = StoreMap.fromJson(val['data']);
                    newStoreMap = tempStoreMap;
                    setState(() {});
                  });
                },
              )
    );
  }

  @override
  bool get wantKeepAlive => true;
}