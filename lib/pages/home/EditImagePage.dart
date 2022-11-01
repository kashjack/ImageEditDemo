/*
 * @Descripttion:
 * @version:
 * @Author: kashjack
 * @Date: 2022-11-01 09:51:38
 * @LastEditors: kashjack kashjack@163.com
 * @LastEditTime: 2022-11-01 16:35:02
 */

import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/image.dart';
import 'package:flutter_app/helper/config/size.dart';
import 'package:flutter_app/pages/home/EditTextPage.dart';
import 'package:flutter_app/pages/home/widget/ColorFilterGenerator.dart';
import 'package:flutter_app/route/BasePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends BaseWidget with WidgetsBindingObserver {
  final XFile image;
  EditImagePage(this.image);

  @override
  BaseWidgetState<BaseWidget> getState() => _EditImageState();
}

class _EditImageState extends BaseWidgetState<EditImagePage> {
  int _selectIndex = 0;
  GlobalKey _repaintKey = GlobalKey(); // 可以获取到被截图组件状态的 GlobalKey
  String _editText = '';
  final GlobalKey textKey = GlobalKey();
  bool _isShowBottomDel = false;

  //静止状态下的offset
  Offset _idleOffset = Offset(0, 0);

  //本次移动的offset
  Offset _moveOffset = Offset(0, 0);

  //最后一次down事件的offset
  Offset _lastStartOffset = Offset(0, 0);

  List<List<double>> _filterList = [
    [0, 0, 0],
    [0, 0.7, -0.3],
    [-0.7, 0, 0.4],
  ];

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
        child: Column(
          children: [
            _buildTopView(),
            _buildImageView(),
            _buildSelectFilterModeView(),
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
    double backImageWidth = 24;
    double backImageHeight = 24;
    double publishTextWidth = 60;
    FontWeight publishTextFontWeight = FontWeight.w400;
    double publishTextFontSize = 16;
    return Container(
      height: topHeight,
      margin: EdgeInsets.only(
        left: topLeftMargin,
        right: topRightMargin,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: topHeight,
            child: InkWell(
              onTap: () {
                this.back();
              },
              child: Center(
                child: Image.asset(
                  JKImage.icon_common_back,
                  width: backImageWidth,
                  height: backImageHeight,
                ),
              ),
            ),
          ),
          SizedBox(
            width: publishTextWidth,
            child: InkWell(
              onTap: () {
                _pubish();
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
                    '发布',
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
    );
  }

  // 图片
  Widget _buildImageView() {
    double imageVerticalMargin = 10;
    double imageHorizontalMargin = 40;
    double imageRadius = 10;
    List<double> mode = _filterList[_selectIndex];
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: imageVerticalMargin,
          horizontal: imageHorizontalMargin,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 截屏组件
            RepaintBoundary(
              key: _repaintKey,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageFilter(
                    hue: mode[0],
                    brightness: mode[1],
                    saturation: mode[2],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(imageRadius),
                      child: Image.file(
                        File(widget.image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  _buildMoveTextView(),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: InkWell(
                onTap: () {
                  this.push(
                    EditTextPage(
                      widget.image,
                      (text) {
                        setState(() {
                          _editText = text;
                        });
                      },
                    ),
                  );
                },
                child: Text(
                  'T',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isShowBottomDel,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  JKImage.icon_home_delete,
                  width: 80,
                  height: 80,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // 滤镜模式选择
  Widget _buildSelectFilterModeView() {
    double horizontalMargin = 30;
    double bottomMargin = 10 + JKSize.instance.bottom;
    double height = 120;
    return Container(
      height: height,
      margin: EdgeInsets.only(
        left: horizontalMargin,
        right: horizontalMargin,
        bottom: bottomMargin,
      ),
      child: Row(
        children: [
          _buildFilterModeView(1),
          _buildFilterModeView(2),
        ],
      ),
    );
  }

  // 滤镜模式
  Widget _buildFilterModeView(int mode) {
    double imageWidth = 48;
    double imageHeight = 62;
    double imageRadius = 5;
    double textTopMargin = 5;

    return InkWell(
      onTap: () {
        if (_selectIndex == mode) {
          setState(() {
            _selectIndex = 0;
          });
        } else {
          setState(() {
            _selectIndex = mode;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageRadius),
                  border: Border.all(
                    width: _selectIndex == mode ? 2 : 0,
                    color: Colors.blue,
                  )),
              child: imageFilter(
                hue: _filterList[mode][0],
                brightness: _filterList[mode][1],
                saturation: _filterList[mode][2],
                child: Container(
                  width: imageWidth,
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius),
                    child: Image.file(
                      File(widget.image.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: textTopMargin),
            child: Text('滤镜' + '$mode'),
          )
        ],
      ),
    );
  }

  // 滤镜
  Widget imageFilter({brightness, saturation, hue, child}) {
    return ColorFiltered(
      colorFilter:
          ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
        colorFilter:
            ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
          value: saturation,
        )),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
            value: hue,
          )),
          child: child,
        ),
      ),
    );
  }

  // 可移动的文字
  Widget _buildMoveTextView() {
    return Transform.translate(
      offset: _moveOffset,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            _isShowBottomDel = true;
          });
        },
        onPanStart: (detail) {
          setState(() {
            _lastStartOffset = detail.globalPosition;
          });
        },
        onPanUpdate: (detail) {
          if (_isShowBottomDel) {
            setState(() {
              if ((detail.globalPosition - _lastStartOffset).dx > 0 &&
                  (detail.globalPosition - _lastStartOffset).dy > 0) {
                print(
                    "点的位置----${detail.globalPosition - _lastStartOffset}---屏幕宽---${MediaQuery.of(context).size.width}---控件宽度---${textKey.currentContext?.size?.width}");
              }
              _moveOffset =
                  detail.globalPosition - _lastStartOffset + _idleOffset;
            });
          }
        },
        onPanEnd: (detail) {
          setState(() {
            _idleOffset = _moveOffset * 1;
            _isShowBottomDel = false;
          });
        },
        child: Container(
          decoration: _isShowBottomDel
              ? BoxDecoration(
                  border: Border.all(
                    width: 4,
                    color: Colors.blue,
                  ),
                )
              : null,
          child: Text(
            _editText,
            key: textKey,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _pubish() {}
}
