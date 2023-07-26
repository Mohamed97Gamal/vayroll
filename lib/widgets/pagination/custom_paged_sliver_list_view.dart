import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vayroll/widgets/adaptive_progress_indicator.dart';
import 'package:vayroll/widgets/pagination/custom_paged_list_view.dart';

class PagedList<T> {
  int? recordsTotalCount;
  int? pagesTotalCount;
  int? pageIndex;
  int? pageSize;
  bool? hasNext;
  bool? hasPrevious;
  List<T>? records;
}

class CustomPagedSliverListView<T> extends StatefulWidget {
  final Future<PagedList<T>> Function(int)? initPageFuture;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Function(BuildContext context)? emptyBuilder;

  CustomPagedSliverListView({
    Key? key,
    this.initPageFuture,
    this.itemBuilder,
    this.emptyBuilder,
  }) : super(key: key);

  @override
  _CustomPagedSliverListViewState<T> createState() => _CustomPagedSliverListViewState<T>();
}

class _CustomPagedSliverListViewState<T> extends State<CustomPagedSliverListView<T>> {
  var _pagingController = PagingController<int, T>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        PagedList<T> pagedResult = await widget.initPageFuture!(pageKey);
        if (pagedResult.hasNext == false) {
          _pagingController.appendLastPage(pagedResult.records!);
        } else {
          _pagingController.appendPage(pagedResult.records!, pagedResult.pageIndex! + 1);
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
        noItemsFoundIndicatorBuilder: widget.emptyBuilder as Widget Function(BuildContext)?,
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
