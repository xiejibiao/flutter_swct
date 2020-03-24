import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swcy/bloc/bloc_provider.dart';
import 'package:flutter_swcy/bloc/person/person_follow_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_bloc.dart';
import 'package:flutter_swcy/bloc/person/share_shop_page_commodity_admin_bloc.dart';
import 'package:flutter_swcy/bloc/shop/shop_pages_bloc.dart';
import 'package:flutter_swcy/bloc/supplier_page_bloc.dart';
import 'package:flutter_swcy/pages/person/person_about_page.dart';
// import 'package:flutter_swcy/pages/person/person_achievement_page.dart';
import 'package:flutter_swcy/pages/person/person_assets_page.dart';
import 'package:flutter_swcy/pages/person/person_complaints_page.dart';
import 'package:flutter_swcy/pages/person/person_follow_page.dart';
import 'package:flutter_swcy/pages/person/person_sms_page.dart';
import 'package:flutter_swcy/pages/person/person_team_page.dart';
import 'package:flutter_swcy/pages/person/shareshop/share_shop_page.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page.dart';
// import 'package:flutter_swcy/test_my_map.dart';
import 'package:oktoast/oktoast.dart';

class PersonPageItemButtom extends StatelessWidget {
  final bool notBusiness;
  PersonPageItemButtom(
    this.notBusiness
  );
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: _getItems(context),
    );
  }

  List<Widget> _getItems(BuildContext context) {
    List<Widget> _widgets = [];
    _widgets.add(_item(context, 'assets/image_icon/icon_shop.png', '我的共享店', BlocProvider(bloc: ShareShopPageBloc(), child: BlocProvider(bloc: ShopPagesBloc(), child: BlocProvider(bloc: ShareShopPageCommodityAdminBloc(), child: ShareShopPage())))));
    // if (!notBusiness) {
    //   _widgets.add(_item(context, 'assets/image_icon/icon_supplier.png', '供应商', BlocProvider(bloc: SupplierPageBloc(), child: SupplierPage(),)));
    // }
    _widgets.add(_item(context, 'assets/image_icon/icon_supplier.png', '供应商', BlocProvider(bloc: SupplierPageBloc(), child: SupplierPage(),)));
    _widgets.add(_item(context, 'assets/image_icon/icon_money1.png', '我的资产', PersonAssetsPage()));
    _widgets.add(_item(context, 'assets/image_icon/icon_team.png', '我的团队', PersonTeamPage()));
    _widgets.add(_item(context, 'assets/image_icon/icon_follow.png', '关注', BlocProvider(bloc: PersonFollowPageBloc(), child: PersonFollowPage())));
    // _widgets.add(_item(context, 'assets/image_icon/icon_achievement.png', '我的业绩', PersonAchievementPage()));
    _widgets.add(_item(context, 'assets/image_icon/icon_message.png', '消息', PersonSmsPage()));
    _widgets.add(_item(context, 'assets/image_icon/icon_opinion.png', '意见与建议', PersonComplaintsPage()));
    _widgets.add(_item(context, 'assets/image_icon/icon_about.png', '关于', PersonAboutPage()));
    return _widgets;
  }

  Widget _item (BuildContext context, String iconPath, String title, Widget path) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(200),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageIcon(AssetImage(iconPath), color: Colors.blue, size: 40),
            Text(title, style: TextStyle( fontSize: ScreenUtil().setSp(26), color: Colors.black54))
          ],
        ),
        onTap: () {
          if (path == null) {
            showToast('请等待完善~~~~');
          } else {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => path));
          }
        },
      ),
    );
  }
}