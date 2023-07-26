import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vayroll/assets/images.dart';
import 'package:vayroll/utils/common.dart';
import 'package:vayroll/widgets/pagination/custom_paged_sliver_list_view.dart';

class CustomPagedListView<T> extends StatefulWidget {
  final Future<PagedList<T>> Function(int)? initPageFuture;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context)? noItemsFoundIndicatorBuilder;
  final EdgeInsets padding;
  final Axis scrollDirection;
  final MainAxisAlignment noItemMainAxis;

  CustomPagedListView({
    Key? key,
    this.initPageFuture,
    this.itemBuilder,
    this.padding = const EdgeInsets.only(bottom: 30),
    this.scrollDirection = Axis.vertical,
    this.noItemsFoundIndicatorBuilder,
    this.noItemMainAxis = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  _CustomPagedListViewState<T> createState() => _CustomPagedListViewState<T>();
}

class _CustomPagedListViewState<T> extends State<CustomPagedListView<T>> {
  var _pagingController = PagingController<int, T>(firstPageKey: 0);
  int pageKeyValue = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        pageKeyValue = pageKey;
        PagedList<T> pagedResult = await widget.initPageFuture!(pageKey);
        if (pagedResult.hasNext == false) {
          _pagingController.appendLastPage(pagedResult.records!);
        } else {
          _pagingController.appendPage(pagedResult.records!, (pagedResult.pageIndex ?? 0) + 1);
        }
      } catch (ex) {
        print(ex.toString());
        _pagingController.error = "Error loading content";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      padding: widget.padding,
      scrollDirection: widget.scrollDirection,
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        firstPageErrorIndicatorBuilder: (context) {
          return CustomPagedListViewErrorIndicatorBuilder(pagingController: _pagingController);
        },
        newPageErrorIndicatorBuilder: (context) {
          return CustomPagedListViewErrorIndicatorBuilder(pagingController: _pagingController);
        },
        firstPageProgressIndicatorBuilder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 12),
                Text(
                  context.appStrings!.loading,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
        },
        noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder ??
            (context) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: widget.noItemMainAxis,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      VPayImages.empty,
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                      height: 200,
                    ),
                    SizedBox(height: 16),
                    Text(
                      context.appStrings!.noDataToDisplay,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Color(0xff444053)),
                    ),
                  ],
                ),
              );
            },
        newPageProgressIndicatorBuilder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 12),
                Text(
                  context.appStrings!.loading,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
        },
        itemBuilder: widget.itemBuilder!,
      ),
    );
  }
}

class CustomPagedListViewErrorIndicatorBuilder extends StatelessWidget {
  final PagingController? pagingController;

  const CustomPagedListViewErrorIndicatorBuilder({
    this.pagingController,
    Key? key,
  })  : _pagingController = pagingController,
        super(key: key);

  final PagingController? _pagingController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () => _pagingController!.retryLastFailedRequest(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.error,
                color: Color(0xFFFD5675),
              ),
              SizedBox(height: 4.0),
              Text(
                "Tap to try again",
                style: TextStyle(color: Color(0xFFFD5675)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontallyPaddedTitleText extends StatelessWidget {
  final String text;

  const HorizontallyPaddedTitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
