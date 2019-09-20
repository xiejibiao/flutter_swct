import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/common/loading.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_add.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page_authentication.dart';
import 'package:flutter_swcy/vo/shop/my_store_page_vo.dart';

class ShareShopPage extends StatelessWidget {
  final GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  Widget build(BuildContext context) {
    final ShareShopPageBloc _bloc = BlocProvider.of<ShareShopPageBloc>(context);
    _bloc.getMyStorePage(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的分享店'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, size: 32),
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => BlocProvider(child: ShareShopPageAdd(_bloc), bloc: ShareShopPageBloc())));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.myStorePageVoStream,
        builder: (context, sanpshop) {
          if (!sanpshop.hasData) {
            return showLoading();
          } else {
            MyStorePageVo myStorePageVo = sanpshop.data;
            if (myStorePageVo.data.list.length <= 0) {
              return showLoading(); 
            } else {
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
                  loadedText: '加载完成'
                ),
                child: ListView(
                  children: <Widget>[
                    _buildStoreItem(myStorePageVo, _bloc),
                    _bloc.isEnd ? TheEndBaseline() : Text('')
                  ],
                ),
                loadMore: () {
                  return _bloc.getMyStorePageLoadMore(context);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildStoreItem(MyStorePageVo myStorePageVo, ShareShopPageBloc bloc) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: myStorePageVo.data.list.length,
      itemBuilder: (context, index) {
        return Container(
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(200),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    myStorePageVo.data.list[index].photo,
                    fit: BoxFit.fill,
                    width: ScreenUtil().setHeight(200),
                    height: ScreenUtil().setHeight(200),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(myStorePageVo.data.list[index].storeName),
                            Text(myStorePageVo.data.list[index].isChecked == 1 ? '持证上线' : '无证照上线'),
                          ],
                        ),
                      ),
                      _buildButtom(myStorePageVo.data.list[index].isChecked, TextUtil.isEmpty(myStorePageVo.data.list[index].licenseCode) ? false : true, context, myStorePageVo.data.list[index].id, bloc)
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 审核状态、是否申请认证
  Widget _buildButtom(int status, bool isAuthentication, BuildContext context, int id, ShareShopPageBloc bloc) {
    if (isAuthentication) {
      switch (status) {
        // 审核中
        case 0:
          return _buildAuditInProgressButtom();
          break;
        // 产品上架
        case 1:
          return _buildProductsOnShelvesButtom();
          break;
        // 审核失败
        default:
         return _buildAuditFailureButtom();
      }
    } else {
      return _buildAuthenticationButtom(context, id, bloc);
    }
  }

  // 审核中
  Widget _buildAuditInProgressButtom() {
    return Container(
      width: ScreenUtil().setWidth(445),
      alignment: Alignment.bottomRight,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(180),
        child: ImageIcon(AssetImage('assets/image_icon/icon_audit_in_progress.png'), size: 50, color: Colors.blue),
      ),
    );
  }

  // 产品上架
  Widget _buildProductsOnShelvesButtom() {
    return Container(
      height: ScreenUtil().setHeight(70),
      width: ScreenUtil().setWidth(445),
      alignment: Alignment.bottomRight,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue[300]
          ),
          child: Text('产品上架'),
        ),
        onTap: () {
          print('产品上架');
        },
      ),
    );
  }

  // 审核失败
  Widget _buildAuditFailureButtom() {
    return Container(
      height: ScreenUtil().setHeight(70),
      width: ScreenUtil().setWidth(445),
      alignment: Alignment.bottomRight,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300]
          ),
          child: Text('审核失败'),
        ),
        onTap: () {
          print('审核失败');
        },
      ),
    );
  }

  // 认证
  Widget _buildAuthenticationButtom(BuildContext context, int id, ShareShopPageBloc bloc) {
    return Container(
      height: ScreenUtil().setHeight(70),
      width: ScreenUtil().setWidth(445),
      alignment: Alignment.bottomRight,
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(8),
            color: Colors.green[500]
          ),
          child: Text('认证'),
        ),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder:( context) => BlocProvider(bloc: ShareShopPageBloc(), child: ShareShopPageAuthentication(id: id, bloc: bloc))));
        },
      ),
    );
  }
} 