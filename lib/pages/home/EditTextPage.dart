/*
 * @Author: kashjack kashjack@163.com
 * @Date: 2022-11-01 14:46:05
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-11-01 16:44:09
 * @FilePath: /ImageEditDemo/lib/pages/home/EditTextPage.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditTextPage extends BaseWidget with WidgetsBindingObserver {
  final File image;
  final Function(String text) callback;
  EditTextPage(this.image, this.callback);

  @override
  BaseWidgetState<BaseWidget> getState() => _EditTextState();
}

class _EditTextState extends BaseWidgetState<EditTextPage> {
  final _controller = TextEditingController();

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
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageView(),
            _buildTopView(),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  // 顶部返回和发布按钮
  Widget _buildTopView() {
    double topHeight = 44;
    double topLeftMargin = 12;
    double topRightMargin = 12;
    double publishTextWidth = 60;
    FontWeight publishTextFontWeight = FontWeight.w400;
    double publishTextFontSize = 16;
    return Positioned(
      top: JKSize.instance.top + 20,
      child: Container(
        height: topHeight,
        width: JKSize.instance.width - 20,
        margin: EdgeInsets.only(
          left: topLeftMargin,
          right: topRightMargin,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: publishTextWidth,
              child: InkWell(
                onTap: () {
                  this.back();
                },
                child: Center(
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: publishTextFontSize,
                      fontWeight: publishTextFontWeight,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: publishTextWidth,
              child: InkWell(
                onTap: () {
                  if (_controller.text.isEmpty) {
                    Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER, msg: '尚未输入文本');
                  } else {
                    widget.callback(_controller.text);
                    this.back();
                  }
                },
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        transform: GradientRotation(90),
                        colors: [
                          Color(0xFF50FDF6),
                          Color(0xFF38BAFF),
                        ],
                        stops: [
                          0.45,
                          0.9,
                        ],
                      ).createShader(rect);
                    },
                    child: Text(
                      '完成',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: publishTextFontSize,
                        fontWeight: publishTextFontWeight,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return Container(
      child: Image.file(
        File(widget.image.path),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '输入文本',
          labelStyle: TextStyle(color: Colors.white),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
