/*
 * @Author: your name
 * @Date: 2021-05-11 00:44:39
 * @LastEditTime: 2022-11-01 13:08:49
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /CarBlueTooth/lib/route/jkPage.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui' as ui show window;

abstract class BaseWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => getState();
  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with RouteAware {
  Widget? navigationBar; //navigationBar

  PreferredSizeWidget? appBarWidget; //body

  Widget? endDrawerWidget; //

  double width = 0;
  double height = 0;
  double top = 0;
  double bottom = 0;
  double left = 0;
  double right = 0;
  double px = 0;
  bool isPortrait = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  String pageName() {
    return ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    this.setParameters();
    return Scaffold(
        // appBar: appBarWidget!, //顶部导航栏
        endDrawer: endDrawerWidget, //右滑菜单栏
        body: WillPopScope(
          child: Stack(
            children: [
              Container(
                width: JKSize.instance.width,
                height: JKSize.instance.height,
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: this.top,
                    bottom: this.bottom,
                    left: this.left,
                    right: this.right),
                child: this.isPortrait
                    ? this.buildVerticalLayout()
                    : this.buildHorizontalLayout(),
              )
            ],
          ),
          onWillPop: () async {
            return true;
          },
        ));
  }

  setParameters() {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    this.isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    this.width = mediaQuery.size.width;
    this.height = mediaQuery.size.height;
    this.top = mediaQuery.padding.top;
    this.bottom = mediaQuery.padding.bottom;
    this.px = (this.isPortrait ? this.width : this.height) / 375.0;

    JKSize.instance.width = mediaQuery.size.width;
    JKSize.instance.height = mediaQuery.size.height;
    JKSize.instance.isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    JKSize.instance.left = mediaQuery.padding.left;
    JKSize.instance.right = mediaQuery.padding.right;
    JKSize.instance.px = (JKSize.instance.isPortrait
            ? JKSize.instance.width
            : JKSize.instance.height) /
        375.0;
    JKSize.instance.mRatio = MediaQuery.of(context).devicePixelRatio;
  }

  initData() {}
  buildVerticalLayout() {}
  buildHorizontalLayout() {}

  push(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((value) {
      if (value != null && value) {
        this.setState(() {});
      }
    });
  }

  pushReplacement(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  goHome() {
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  back() {
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 添加监听订阅
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    //重新回到该页面会走该方法
    this.initData();
    setState(() {});
  }
}
