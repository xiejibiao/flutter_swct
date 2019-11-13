import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swcy/bloc/supplier_page_bloc.dart';
import 'package:flutter_swcy/common/the_end_baseline.dart';
import 'package:flutter_swcy/pages/person/supplier/supplier_page_list_item.dart';
import 'package:flutter_swcy/vo/supplier/get_supplier_page_vo.dart';

class SupplierPageList extends StatefulWidget {
  final InfoVoLgmnPage infoVoLgmnPage;
  final int industryId;
  final SupplierPageBloc _bloc;
  SupplierPageList(
    this.infoVoLgmnPage,
    this.industryId,
    this._bloc
  );
  @override
  _SupplierPageListState createState() => _SupplierPageListState();
}

class _SupplierPageListState extends State<SupplierPageList> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      footer: BallPulseFooter(
        enableHapticFeedback: true,
        enableInfiniteLoad: false
      ),
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(10.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
                return SupplierPageListItem(widget.infoVoLgmnPage.list[index]);
              },
              childCount: widget.infoVoLgmnPage.list.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: (widget.infoVoLgmnPage.pageNumber + 1) == widget.infoVoLgmnPage.totalPage ? TheEndBaseline() : Container(),
        )
      ],
      onLoad: () async {
        if ((widget.infoVoLgmnPage.pageNumber + 1) < widget.infoVoLgmnPage.totalPage) {
           await widget._bloc.loadMoreSupplierPage(widget.industryId, widget.infoVoLgmnPage.pageNumber);
        }
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}