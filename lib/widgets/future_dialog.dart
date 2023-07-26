import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vayroll/widgets/widgets.dart';

Future<T?> showFutureProgressDialog<T>({
  required BuildContext context,
  required InitFuture<T> initFuture,
  String message = 'Please Wait...',
  bool nullable = false,
}) async {
  return await showAdaptiveDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AdaptiveProgressDialog<T>(
        initFuture: initFuture,
        message: message,
        nullable: nullable,
      );
    },
  );
}

class AdaptiveProgressDialog<T> extends StatelessWidget {
  final InitFuture<T> initFuture;
  final String? message;
  final bool? nullable;

  const AdaptiveProgressDialog({
    required this.initFuture,
    this.message,
    this.nullable,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(16.0),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(40.0),
      //   ),
      // ),
      content: SizedBox(
        height: 125.0,
        child: AdaptiveProgressDialogContent<T>(
          initFuture: initFuture,
          message: message,
          nullable: nullable,
        ),
      ),
    );
  }
}

class AdaptiveProgressDialogContent<T> extends StatelessWidget {
  final InitFuture<T> initFuture;
  final String? message;
  final bool? nullable;

  const AdaptiveProgressDialogContent({
    required this.initFuture,
    this.message,
    this.nullable,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomFutureBuilder<T>(
        nullable: nullable!,
        initFuture: () async {
          try {
            var result = await initFuture();
            Navigator.of(context, rootNavigator: true).pop(result);
            return result;
          } catch (ex) {
            if (ex is DioError)
              Navigator.of(context, rootNavigator: true)
                  .pop(ex.response?.data as T?);
            // Navigator.of(context, rootNavigator: true).pop();
            rethrow;
          }
        },
        onError: (context, snapshot) {
          return const SplashArt();
        },
        onLoading: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: SplashArt(message: message),
          );
        },
        onSuccess: (context, snapshot) {
          return const SplashArt();
        },
      ),
    );
  }
}

Future<T?> showProgressDialog<T>({
  required BuildContext context,
  required InitFuture<T> initFuture,
  bool? barrierDismissible,
  String? message,
}) async {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          height: 125.0,
          child: WillPopScope(
            onWillPop: () async => false,
            child: FutureBuilder<T>(
              future: () async {
                var a = await initFuture();
                return a;
              }.call().whenComplete(() => Navigator.of(context).pop()),
              //future: initFuture.whenComplete(() => Navigator.of(context).pop()),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container();
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    return ProgressIndicator(message: message);
                  default:
                    return Container();
                }
              },
            ),
            // child: CustomFutureBuilder<T>(
            //   initFuture: () async {
            //     try {
            //       var result = await initFuture();
            //       Navigator.of(context, rootNavigator: true).pop(result);
            //       return result;
            //     } catch (ex) {
            //       Navigator.of(context, rootNavigator: true).pop();
            //       rethrow;
            //     }
            //   },
            //   onLoading: (context) {
            //     return ProgressIndicator(message: message);
            //   },
            //   onSuccess: (context, snapshot) {
            //     return ProgressIndicator(message: message);
            //   },
            // ),
          ),
        ),
      );
    },
  );
}

class ProgressIndicator extends StatelessWidget {
  final String? message;

  const ProgressIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(message!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
