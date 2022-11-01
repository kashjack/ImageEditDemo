/*
 * @Author: your name
 * @Date: 2021-04-02 17:45:43
 * @LastEditTime: 2022-08-29 14:30:51
 * @LastEditors: kashjack kashjack@163.com
 * @Description: In User Settings Edit
 * @FilePath: /MTCouple/lib/route/route.dart
 */

import 'package:auto_route/auto_route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helper/config/config.dart';

class JKRoute {
  static FluroRouter router = FluroRouter();

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      printLog("route is not find !");
      return null;
    });

    //网页加载
    // router.define('/web', handler: Handler(
    //     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    //   // String title = params['title']?.first;
    //   String url = params['url']?.first;
    //   return WebViewPage(url, title);
    // }));
  }

  static void navigateTo(BuildContext context, String path) {
    router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }

  static void goWeb(BuildContext context, String url, String title) {
    navigateTo(context,
        "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}");
  }

  //=============AutoRoute===============//

  static ExtendedNavigatorState get navigator => ExtendedNavigator.root;

  static void push(String routeName) {
    navigator.push(routeName);
  }

  static void replace(String routeName) {
    navigator.replace(routeName);
  }
}
