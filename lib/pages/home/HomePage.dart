/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2022-11-01 09:31:38
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-11-01 16:52:40
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/home/EditImagePage.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends BaseWidget with WidgetsBindingObserver {
  @override
  BaseWidgetState<BaseWidget> getState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState<HomePage> {
  List<Map<String, Object>> _listItems = [];
  int _currentPage = 1;
  static int _pageSize = 10;
  late File file;

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
    Color topTextColor = Color(0xD9000000);
    double topTextHeight = 35;
    double topTextTopMargin = 24;
    double topTextBottomMargin = 14;
    double topTextRightMargin = 14;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _buildLine(),
          _buildImageListView(),
        ],
      ),
    );
  }

  // 图片列表
  Widget _buildImageListView() {
    return Expanded(
      child: EasyRefresh(
        onRefresh: () async {
          _refresh();
        },
        onLoad: () async {
          _load();
        },
        child: ListView.builder(
          itemCount: _listItems.length,
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }

  // 底部添加图片按钮
  Widget _buildAddImageInkWell() {
    double width = 78;
    double height = 78;
    double rightMargin = 42;
    double bottomMargin = 74;

    return Positioned(
      right: rightMargin,
      bottom: bottomMargin,
      child: InkWell(
        onTap: () {
          _showPicker();
        },
        borderRadius: BorderRadius.circular(width / 2),
        child: SizedBox(
          height: height,
          width: width,
          child: Image.asset(
            JKImage.icon_home_add,
            height: height,
            width: width,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  // 灰色line
  Widget _buildLine() {
    double lineHeight = 1;
    Color lineColor = Color(0xFFE8E8E8);
    return SizedBox(
      width: JKSize.instance.width,
      height: lineHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: lineColor,
        ),
      ),
    );
  }

  // 弹出选择相册拍照对话框
  _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext con) => Container(
        height: 160,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Expanded(
          child: ListView(
            children: [createItem(true, "拍照"), createItem(false, "相册")],
          ),
        ),
      ),
    );
  }

  //创建item
  Widget createItem(bool state, String name) {
    return GestureDetector(
      onTap: () {
        //点击事件处理
        _openPicker(state);
      },
      child: ListTile(
        leading: Icon(state ? Icons.camera : Icons.image),
        title: Text(name),
      ),
    );
  }

  // 使用imagePicker异步打开拍照 、相册
  _openPicker(bool state) async {
    //销毁底部弹出框
    Navigator.pop(context);
    var imagePicker = ImagePicker();
    //根据状态标识决定打开相机还是相册
    final image = await imagePicker.getImage(
        source: state ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      this.push(EditImagePage(File(image.path)));
    }
  }

  //
  _refresh() async {
    _currentPage = 1;
  }

  _load() async {
    _currentPage += 1;
  }
}
