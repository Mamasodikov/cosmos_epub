import 'dart:ui';

import 'package:cosmos_epub/PageFlip/page_flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'functions.dart';

class PagingTextHandler {
  final Function paginate;

  PagingTextHandler(
      {required this.paginate}); // will point to widget show method
}

class PagingWidget extends StatefulWidget {
  final String textContent;
  final String chapterTitle;
  final int totalChapters;
  final int starterPageIndex;
  final TextStyle style;
  final Function handlerCallback;
  final VoidCallback onTextTap;
  final Function(int, int) onPageFlip;
  final Function(int, int) onLastPage;
  final Widget? lastWidget;

  const PagingWidget(
    this.textContent, {
    super.key,
    this.style = const TextStyle(
      color: Colors.black,
      fontSize: 30,
    ),
    required this.handlerCallback(PagingTextHandler handler, int totalPages),
    required this.onTextTap,
    required this.onPageFlip,
    required this.onLastPage,
    this.starterPageIndex = 0,
    required this.chapterTitle,
    required this.totalChapters,
    this.lastWidget,
  });

  @override
  _PagingWidgetState createState() => _PagingWidgetState();
}

class _PagingWidgetState extends State<PagingWidget> {
  final List<String> _pageTexts = [];
  List<Widget> pages = [];
  int _currentPageIndex = 0;
  Future<int> paginateFuture = Future.value(0);
  late RenderBox _initializedRenderBox;
  Widget? lastWidget;

  final _pageKey = GlobalKey();
  final _pageController = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    rePaginate();
    var handler = PagingTextHandler(paginate: rePaginate);
    widget.handlerCallback(handler, 0); // callback call.
    super.initState();
  }

  rePaginate() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _initializedRenderBox = context.findRenderObject() as RenderBox;
        paginateFuture = _paginate();
      });
    });
  }

  int findLastHtmlTagIndex(String input) {
    // Regular expression pattern to match HTML tags
    RegExp regex = RegExp(r'<[^>]');

    // Find all matches
    Iterable<Match> matches = regex.allMatches(input);

    // If matches are found
    if (matches.isNotEmpty) {
      // Return the end index of the last match
      return matches.last.end;
    } else {
      // If no match is found, return -1
      return -1;
    }
  }

  Future<int> _paginate() async {
    final pageSize = _initializedRenderBox.size;

    _pageTexts.clear();

    final textSpan = TextSpan(
      text: widget.textContent,
      style: widget.style,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: pageSize.width,
    );

    // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
    List<LineMetrics> lines = textPainter.computeLineMetrics();
    double currentPageBottom = pageSize.height - 180.h;
    int currentPageStartIndex = 0;
    int currentPageEndIndex = 0;

    await Future.wait(lines.map((line) async {
      final left = line.left;
      final top = line.baseline - line.ascent;
      final bottom = line.baseline + line.descent;

      // Current line overflow page
      if (currentPageBottom < bottom) {
        currentPageEndIndex =
            textPainter.getPositionForOffset(Offset(left, top)).offset;

        var pageText = widget.textContent
            .substring(currentPageStartIndex, currentPageEndIndex);

        var index = findLastHtmlTagIndex(pageText) + currentPageStartIndex;

        /// Offset to the left from last HTML tag
        if (index != -1) {
          int difference = currentPageEndIndex - index;
          if (difference < 4) {
            currentPageEndIndex = index - 2;
          }

          pageText = widget.textContent
              .substring(currentPageStartIndex, currentPageEndIndex);
          // print('start : $currentPageStartIndex');
          // print('end : $currentPageEndIndex');
          // print('last html tag : $index');
        }

        _pageTexts.add(pageText);

        currentPageStartIndex = currentPageEndIndex;
        currentPageBottom = top + (pageSize.height - 230.h);
      }
    }));

    final lastPageText = widget.textContent.substring(currentPageStartIndex);
    _pageTexts.add(lastPageText);

    var index = -1;
    // Assuming each operation within the loop is asynchronous and returns a Future
    List<Future<Widget>> futures = _pageTexts.map((text) async {
      index++;
      return InkWell(
        onTap: widget.onTextTap,
        child: Padding(
            padding: EdgeInsets.only(top: 60.h, left: 10.w, right: 10.w),
            child: HtmlWidget(
              textToHtml(
                  '$text ${(index != 0 && index != _pageTexts.length - 1) ? '→' : ''}'),
              customStylesBuilder: (element) {
                if (element.localName == 'p') {
                  return {'text-align': 'justify'};
                }
                return null;
              },
              onTapUrl: (String? s) async {
                if (s != null && s == "a") {
                  if (s.contains("chapter")) {
                    setState(() {
                      ///Write logic for goto chapter
                      // var s1 = s.split("-0");
                      // String break1 =
                      //     s1.toList().last.split(".xhtml").first;
                      // int number = int.parse(break1);
                    });
                  }
                }
                return true;
              },
              textStyle: widget.style,
            )),
      );
    }).toList();

    pages = await Future.wait(futures);
    return _pageTexts.length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: paginateFuture,
        builder: (context, snapshot) {
          var handler = PagingTextHandler(paginate: rePaginate);
          widget.handlerCallback(handler, snapshot.data ?? 0); // callback call.

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              {
                // Otherwise, display a loading indicator.
                return Center(
                    child: CupertinoActivityIndicator(
                  color: Theme.of(context).primaryColor,
                  radius: 30.r,
                ));
              }
            default:
              {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SizedBox.expand(
                            key: _pageKey,
                            child: PageFlipWidget(
                              key: _pageController,
                              initialIndex: widget.starterPageIndex != 0
                                  ? (pages.isNotEmpty &&
                                          widget.starterPageIndex < pages.length
                                      ? widget.starterPageIndex
                                      : 0)
                                  : widget.starterPageIndex,
                              onPageFlip: (pageIndex) {
                                _currentPageIndex = pageIndex;
                                widget.onPageFlip(pageIndex, pages.length);
                                if (_currentPageIndex == pages.length - 1) {
                                  widget.onLastPage(pageIndex, pages.length);
                                }
                              },
                              backgroundColor:
                                  widget.style.backgroundColor ?? Colors.white,
                              lastPage: widget.lastWidget,
                              children: pages,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.first_page, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    _currentPageIndex = 0;
                                    _pageController.currentState
                                        ?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.navigate_before,
                                    color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    if (_currentPageIndex > 0)
                                      _currentPageIndex--;
                                    _pageController.currentState
                                        ?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              Text(
                                '${_currentPageIndex + 1}/${_pageTexts.length}',
                              ),
                              IconButton(
                                icon: Icon(Icons.navigate_next,
                                    color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    if (_currentPageIndex <
                                        _pageTexts.length - 1)
                                      _currentPageIndex++;
                                    _pageController.currentState
                                        ?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.last_page, color: Colors.blue),
                                onPressed: () {
                                  setState(() {
                                    _currentPageIndex = _pageTexts.length - 1;
                                    _pageController.currentState
                                        ?.goToPage(_currentPageIndex);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
          }
        });
  }
}
