import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vayroll/widgets/adaptive_progress_indicator.dart';
import 'package:vayroll/widgets/pagination/custom_paged_list_view.dart';

class CustomPagedSliverListView2<T> extends StatefulWidget {
  final Future<List<T>> Function(int)? initPageFuture;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  CustomPagedSliverListView2({
    Key? key,
    this.initPageFuture,
    this.itemBuilder,
    this.emptyBuilder,
  }) : super(key: key);

  @override
  _CustomPagedSliverListView2State<T> createState() => _CustomPagedSliverListView2State<T>();
}

class _CustomPagedSliverListView2State<T> extends State<CustomPagedSliverListView2<T>> {
  var _pagingController = PagingController<int, T>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        List<T> pagedResult = await widget.initPageFuture!(pageKey);
        if (pagedResult.isEmpty) {
          _pagingController.appendLastPage(pagedResult);
        } else {
          _pagingController.appendPage(pagedResult, pageKey + 1);
        }
      } catch (ex) {
        _pagingController.error = "Error loading content";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverList<int, T>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        firstPageErrorIndicatorBuilder: (context) {
          return CustomPagedListViewErrorIndicatorBuilder(pagingController: _pagingController);
        },
        newPageErrorIndicatorBuilder: (context) {
          return CustomPagedListViewErrorIndicatorBuilder(pagingController: _pagingController);
        },
        firstPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: AdaptiveProgressIndicator(),
            ),
          );
        },
        noItemsFoundIndicatorBuilder: widget.emptyBuilder,
        newPageProgressIndicatorBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: AdaptiveProgressIndicator(),
            ),
          );
        },
        itemBuilder: widget.itemBuilder!,
      ),
    );
  }
}
