/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2020-12-31 17:31:38
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-11-01 10:53:57
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/route/BasePage.dart';

class HomePage extends BaseWidget with WidgetsBindingObserver {
  @override
  BaseWidgetState<BaseWidget> getState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState<HomePage> {
  int index = 0;

  bool isPlayed = false;
  int count = 5;
  String version = '';
  bool triedConnect = false;

  // didChangeAppLifecycleState

  initData() {
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarWidget!, //顶部导航栏
      // endDrawer: endDrawerWidget, //右滑菜单栏
      body: Container(
        height: JKSize.instance.height,
        width: JKSize.instance.width,
        margin: EdgeInsets.only(
          top: JKSize.instance.top,
        ),
        child: Stack(
          children: [
            _buildMainContentView(),
            _buildAddImageInkWell(),
          ],
        ),
      ),
    );
  }

  // 页面主内容
  Widget _buildMainContentView() {
    FontWeight topTextFontWeight = FontWeight.w700;
    double topTextFontSize = 24;
    Color topTextColor = Colors.black.withAlpha(217);
    double topTextHeight = 35;
    double topTextTopMargin = 24;
    double topTextBottomMargin = 14;
    double topTextRightMargin = 14;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: topTextHeight,
            margin: EdgeInsets.only(
              top: topTextTopMargin,
              bottom: topTextBottomMargin,
              left: topTextRightMargin,
            ),
            child: Text(
              'Hyperbound Flutter Demo',
              style: TextStyle(
                color: topTextColor,
                fontSize: topTextFontSize,
                fontWeight: topTextFontWeight,
              ),
            ),
          ),
          _buildImageListView(),
        ],
      ),
    );
  }

  // 图片列表
  Widget _buildImageListView() {
    return Container();
  }

  // 底部添加图片按钮
  Widget _buildAddImageInkWell() {
    double width = 78;
    double height = 78;
    double rightMargin = 42;
    double bottomMargin = 74;

    return InkWell(
      onTap: () {
        this.back();
      },
      child: Container(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: rightMargin, bottom: bottomMargin),
        child: Image.asset(
          JKImage.icon_home_add,
          height: height,
          width: width,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget buildTopView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    );
  }
}
