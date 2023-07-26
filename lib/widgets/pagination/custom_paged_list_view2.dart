import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vayroll/widgets/adaptive_progress_indicator.dart';

class CustomPagedListView2<T> extends StatefulWidget {
  final Future<List<T>> Function(int)? initPageFuture;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final EdgeInsets padding;
  final Axis scrollDirection;

  CustomPagedListView2({
    Key? key,
    this.initPageFuture,
     this.itemBuilder,
    this.emptyBuilder,
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  _CustomPagedListView2State<T> createState() => _CustomPagedListView2State<T>();
}

class _CustomPagedListView2State<T> extends State<CustomPagedListView2<T>> {
  var _pagingController = PagingController<int, T>(firstPageKey: 0);
  int pageKeyValue = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) async {
      try {
        List<T> pagedResult = await widget.initPageFuture!(pageKey);
        if (pagedResult.isEmpty) {
          if(pageKey==0){
            _pagingController.error = "Empty";
            return;
          }
          _pagingController.appendLastPage(pagedResult);
        } else {
          _pagingController.appendPage(pagedResult, pageKey+1);
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
          if(_pagingController.error=="Empty"){
            return widget.emptyBuilder!(context);
          }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HorizontallyPaddedTitleText("Something Went Wrong"),
              SizedBox(height: 20.0),
              Text(
                "Network error",
                style: TextStyle(fontSize: 20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: Theme.of(context).primaryColor),
                  Text("Retry", style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
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