import 'package:flutter/material.dart';
import 'package:flutter_swcy/common/custom_image_delegate.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class ShareShopPageCommodityDetailEdit extends StatefulWidget {
  final Delta deltaDetail;
  ShareShopPageCommodityDetailEdit({
    this.deltaDetail
  });
  _ShareShopPageCommodityDetailEditState createState() => _ShareShopPageCommodityDetailEditState();
}

class _ShareShopPageCommodityDetailEditState extends State<ShareShopPageCommodityDetailEdit> {
  final FocusNode _focusNode = FocusNode();
  NotusDocument _document;
  ZefyrController _controller;
  @override
  void initState() {
    super.initState();
    if(widget.deltaDetail == null) {
      _document = NotusDocument();
    } else {
      _document = NotusDocument.fromDelta(widget.deltaDetail);
    }    
    _controller = ZefyrController(_document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑文字'),
        actions: <Widget>[
          IconButton(
            icon: Text('完成'),
            onPressed: () {
              Navigator.pop(context, _controller.document.toDelta());
            },
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          controller: _controller,
          focusNode: _focusNode,
          enabled: true,
          imageDelegate: CustomImageDelegate(),
        ),
      ),
    );
  }
}