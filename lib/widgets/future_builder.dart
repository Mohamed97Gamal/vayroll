import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/utils/utils.dart';

class RefreshNotifier extends ValueNotifier<DateTime> {
  RefreshNotifier() : super(DateTime.now());

  void refresh() => value = DateTime.now();
}

typedef InitFuture<T> = Future<T> Function();

typedef OnSuccess<T> = Widget Function(BuildContext context, AsyncSnapshot<T> snapshot);
typedef OnError<T> = Widget? Function(BuildContext context, AsyncSnapshot<T> snapshot);

class CustomFutureBuilder<T> extends StatefulWidget {
  final OnSuccess<T> onSuccess;
  final InitFuture<T> initFuture;
  final WidgetBuilder? onLoading;
  final bool nullable;
  final OnError<T>? onError;
  final bool refreshOnRebuild;
  final String loadingMessage;
  final Color? loadingMessageColor;

  const CustomFutureBuilder({
    required this.initFuture,
    required this.onSuccess,
    bool refreshOnRebuild = false,
    this.onLoading,
    this.nullable = false,
    this.onError,
    this.loadingMessage = 'Loading...',
    this.loadingMessageColor,
  })  : refreshOnRebuild = refreshOnRebuild ?? false,
        assert(nullable != null);

  @override
  _CustomFutureBuilderState<T> createState() => _CustomFutureBuilderState<T>();
}

class _CustomFutureBuilderState<T> extends State<CustomFutureBuilder<T>> {
  Future<T>? future;
  int maxRetries = 5;

  @override
  void initState() {
    super.initState();
    future = widget.refreshOnRebuild ? null : widget.initFuture?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future ??
          () {
            setState(() => maxRetries--);
            return widget.initFuture?.call();
          }.call(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (widget.onLoading != null) {
              return widget.onLoading!(context);
            }
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                  if (widget.loadingMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.loadingMessage,
                      style: TextStyle(color: widget.loadingMessageColor ?? Theme.of(context).primaryColor),
                    ),
                  ],
                ],
              ),
            );

          case ConnectionState.done:
            if (snapshot.data == null && !widget.nullable) {
              return _buildOnError(context, snapshot)!;
            }
            if (snapshot.hasError) {
              return _buildOnError(context, snapshot)!;
            }
            var response = tryCast<BaseResponse>(snapshot.data);
            if (response != null && response?.status == false) {
              var msg = response.message;
              if (response.errors != null && response.errors!.isNotEmpty) {
                msg = msg! + "\n" + response.errors!.join("\n");
              }
              return _buildOnError(context, snapshot, msg)!;
            }

            return widget.onSuccess(context, snapshot);

          default:
            return Container();
        }
      },
    );
  }

  // ignore: unused_element
  Widget? _buildOnError(BuildContext context, AsyncSnapshot<T> snapshot, [String? errorMessage]) {
    printIfDebug("snapshot error : ${snapshot.error.toString()}");

    if (widget.onError != null) {
      return widget.onError!(context, snapshot);
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: (maxRetries == 0)
            ? null
            : () {
                setState(() {
                  maxRetries--;
                  future = widget.initFuture();
                });
              },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (maxRetries > 0)
                Icon(
                  Icons.error,
                  color: Color(0xFFFD5675),
                ),
              if (maxRetries > 0) SizedBox(height: 4.0),
              if (maxRetries > 0)
                Text(
                  "Tap to try again",
                  style: TextStyle(color: Color(0xFFFD5675)),
                ),
              //update when custom future builder fail max retries
              if (maxRetries <= 0) MaxRetriesError(),
              if (maxRetries <= 0) Text("Sorry, can't process your request right now"),
              if (maxRetries > 0 && errorMessage != null)
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFFD5675)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaxRetriesError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      VPayImages.stillError,
      fit: BoxFit.contain,
    );
  }
}
