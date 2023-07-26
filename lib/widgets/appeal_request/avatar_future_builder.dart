import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vayroll/models/api_responses/base_response.dart';
import 'package:vayroll/utils/utils.dart';
import 'package:vayroll/widgets/widgets.dart';

class AvatarFutureBuilder<T> extends StatefulWidget {
  final OnSuccess<T> onSuccess;
  final InitFuture<T> initFuture;
  final WidgetBuilder? onLoading;
  final bool nullable;
  final OnError<T>? onError;
  final bool refreshOnRebuild;

  const AvatarFutureBuilder({
    required this.initFuture,
    required this.onSuccess,
    bool refreshOnRebuild = false,
    this.onLoading,
    this.nullable = false,
    this.onError,
  })  : refreshOnRebuild = refreshOnRebuild ?? false,
        assert(nullable != null);

  @override
  _AvatarFutureBuilderState<T> createState() => _AvatarFutureBuilderState<T>();
}

class _AvatarFutureBuilderState<T> extends State<AvatarFutureBuilder<T>> {
  Future<T>? future;

  @override
  void initState() {
    super.initState();
    future = widget.refreshOnRebuild ? null : widget.initFuture?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future ?? widget.initFuture?.call(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container();
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (widget.onLoading != null) {
              return widget.onLoading!(context);
            }
            return SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
            );

          case ConnectionState.done:
            if (snapshot.data == null && !widget.nullable) {
              return _buildOnError(context, snapshot)!;
            }
            if (snapshot.hasError) {
              return _buildOnError(context, snapshot)!;
            }
            if (tryCast<BaseResponse>(snapshot.data)?.status == false) {
              return _buildOnError(context, snapshot)!;
            }
            return widget.onSuccess(context, snapshot);

          default:
            return Container();
        }
      },
    );
  }

  // ignore: unused_element
  Widget? _buildOnError(BuildContext context, AsyncSnapshot<T> snapshot) {
    printIfDebug("snapshot error : ${snapshot.error.toString()}");

    if (widget.onError != null) {
      return widget.onError!(context, snapshot);
    }
    return InkWell(
      onTap: () {
        setState(() {
          future = widget.initFuture();
        });
      },
      child: Center(
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: 16,
          child: Icon(
            Icons.error,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
