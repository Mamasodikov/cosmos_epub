import 'package:cosmos_epub/Helpers/context_extensions.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'Component/constants.dart';
import 'Component/circle_button.dart';
import 'Component/theme_colors.dart';
import 'Helpers/chapters.dart';
import 'Helpers/custom_toast.dart';
import 'Helpers/pagination.dart';
import 'Helpers/progress_singleton.dart';
import 'Model/chapter_model.dart';

///TODO: Change Future to more controllable timer to control show/hide elements
///  BUG-1: https://github.com/Mamasodikov/cosmos_epub/issues/2
///- Add sub chapters support
///- Add image support
///- Add text style attributes / word-break support

late BookProgressSingleton bookProgress;

const double DESIGN_WIDTH = 375;
const double DESIGN_HEIGHT = 812;

String selectedFont = 'Segoe';
List<String> fontNames = [
  "Segoe",
  "Alegreya",
  "Amazon Ember",
  "Atkinson Hyperlegible",
  "Bitter Pro",
  "Bookerly",
  "Droid Sans",
  "EB Garamond",
  "Gentium Book Plus",
  "Halant",
  "IBM Plex Sans",
  "LinLibertine",
  "Literata",
  "Lora",
  "Ubuntu"
];

Color backColor = Colors.white;
Color fontColor = Colors.black;
int staticThemeId = 3;

// ignore: must_be_immutable
class ShowEpub extends StatefulWidget {
  EpubBook epubBook;
  bool shouldOpenDrawer;
  int starterChapter;
  final String bookId;
  final String chapterListTitle;
  final Function(int currentPage, int totalPages)? onPageFlip;
  final Function(int lastPageIndex)? onLastPage;
  final Color accentColor;

  ShowEpub({
    super.key,
    required this.epubBook,
    required this.accentColor,
    this.starterChapter = 0,
    this.shouldOpenDrawer = false,
    required this.bookId,
    required this.chapterListTitle,
    this.onPageFlip,
    this.onLastPage,
  });

  @override
  State<StatefulWidget> createState() => ShowEpubState();
}

class ShowEpubState extends State<ShowEpub> {
  String htmlContent = '';
  String? innerHtmlContent;
  String textContent = '';
  bool showBrightnessWidget = false;
  final controller = ScrollController();
  Future<void> loadChapterFuture = Future.value(true);
  List<LocalChapterModel> chaptersList = [];
  double _fontSizeProgress = 17.0;
  double _fontSize = 17.0;

  late EpubBook epubBook;
  late String bookId;
  String bookTitle = '';
  String chapterTitle = '';
  double brightnessLevel = 0.5;

  // late Map<String, String> allFonts;

  // Initialize with the first font in the list
  late String selectedTextStyle;

  bool showHeader = true;
  bool isLastPage = false;
  int lastSwipe = 0;
  int prevSwipe = 0;
  bool showPrevious = false;
  bool showNext = false;
  var dropDownFontItems;

  GetStorage gs = GetStorage();

  PagingTextHandler controllerPaging = PagingTextHandler(paginate: () {});

  @override
  void initState() {
    loadThemeSettings();

    bookId = widget.bookId;
    epubBook = widget.epubBook;
    // allFonts = GoogleFonts.asMap().cast<String, String>();
    // fontNames = allFonts.keys.toList();
    // selectedTextStyle = GoogleFonts.getFont(selectedFont).fontFamily!;
    selectedTextStyle =
        fontNames.where((element) => element == selectedFont).first;

    getTitleFromXhtml();
    reLoadChapter(init: true);

    super.initState();
  }

  loadThemeSettings() {
    selectedFont = gs.read(libFont) ?? selectedFont;
    var themeId = gs.read(libTheme) ?? staticThemeId;
    updateTheme(themeId, isInit: true);
    _fontSize = gs.read(libFontSize) ?? _fontSize;
    _fontSizeProgress = _fontSize;
  }

  getTitleFromXhtml() {
    ///Listener for slider
    // controller.addListener(() {
    //   if (controller.position.userScrollDirection == ScrollDirection.forward &&
    //       showHeader == false) {
    //     showHeader = true;
    //     update();
    //   } else if (controller.position.userScrollDirection ==
    //           ScrollDirection.reverse &&
    //       showHeader) {
    //     showHeader = false;
    //     update();
    //   }
    // });

    if (epubBook.Title != null) {
      bookTitle = epubBook.Title!;
      updateUI();
    }
  }

  reLoadChapter({bool init = false, int index = -1}) async {
    int currentIndex =
        bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    setState(() {
      loadChapterFuture = loadChapter(
          index: init
              ? -1
              : index == -1
                  ? currentIndex
                  : index);
    });
  }

  loadChapter({int index = -1}) async {
    chaptersList = [];

    await Future.wait(epubBook.Chapters!.map((EpubChapter chapter) async {
      String? chapterTitle = chapter.Title;
      List<LocalChapterModel> subChapters = [];
      for (var element in chapter.SubChapters!) {
        subChapters.add(
            LocalChapterModel(chapter: element.Title!, isSubChapter: true));
      }

      chaptersList.add(LocalChapterModel(
          chapter: chapterTitle ?? '...', isSubChapter: false));

      chaptersList += subChapters;
    }));

    ///Choose initial chapter
    if (widget.starterChapter >= 0 &&
        widget.starterChapter < chaptersList.length) {
      setupNavButtons();
      await updateContentAccordingChapter(
          index == -1 ? widget.starterChapter : index);
    } else {
      setupNavButtons();
      await updateContentAccordingChapter(0);
      CustomToast.showToast(
          "Invalid chapter number. Range [0-${chaptersList.length}]");
    }
  }

  updateContentAccordingChapter(int chapterIndex) async {
    ///Set current chapter index
    await bookProgress.setCurrentChapterIndex(bookId, chapterIndex);

    String content = '';

    await Future.wait(epubBook.Chapters!.map((EpubChapter chapter) async {
      content = epubBook.Chapters![chapterIndex].HtmlContent!;

      List<EpubChapter>? subChapters = chapter.SubChapters;
      if (subChapters != null && subChapters.isNotEmpty) {
        for (int i = 0; i < subChapters.length; i++) {
          content = content + subChapters[i].HtmlContent!;
        }
      } else {
        subChapters?.forEach((element) {
          if (element.Title == epubBook.Chapters![chapterIndex].Title) {
            content = element.HtmlContent!;
          }
        });
      }
    }));

    htmlContent = content;
    textContent = parse(htmlContent).documentElement!.text;

    if (isHTML(textContent)) {
      innerHtmlContent = textContent;
    } else {
      textContent = textContent.replaceAll('Unknown', '').trim();
    }
    controllerPaging.paginate();

    setupNavButtons();
  }

  bool isHTML(String str) {
    final RegExp htmlRegExp =
        RegExp('<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlRegExp.hasMatch(str);
  }

  setupNavButtons() {
    int index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    setState(() {
      if (index == 0) {
        showPrevious = false;
      } else {
        showPrevious = true;
      }
      if (index == chaptersList.length - 1) {
        showNext = false;
      } else {
        showNext = true;
      }
    });
  }

  Future<bool> backPress() async {
    // Navigator.of(context).pop();
    return true;
  }

  void setBrightness(double brightness) async {
    await ScreenBrightness().setScreenBrightness(brightness);
    await Future.delayed(const Duration(seconds: 5));
    showBrightnessWidget = false;
    updateUI();
  }

  updateFontSettings() {
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        backgroundColor: backColor,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r))),
        builder: (context) {
          return SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, setState) => SizedBox(
                        height: 170.h,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.h, vertical: 8.w),
                              height: 45.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(1);
                                    },
                                    child: CircleButton(
                                      backColor: cVioletishColor,
                                      fontColor: Colors.black,
                                      id: 1,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(2);
                                    },
                                    child: CircleButton(
                                      backColor: cBluishColor,
                                      fontColor: Colors.black,
                                      id: 2,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(3);
                                    },
                                    child: CircleButton(
                                      id: 3,
                                      backColor: Colors.white,
                                      fontColor: Colors.black,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(4);
                                    },
                                    child: CircleButton(
                                      id: 4,
                                      backColor: Colors.black,
                                      fontColor: Colors.white,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      updateTheme(5);
                                    },
                                    child: CircleButton(
                                      id: 5,
                                      backColor: cPinkishColor,
                                      fontColor: Colors.black,
                                      accentColor: widget.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.h,
                              height: 0,
                              indent: 0,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.h),
                                  child: Column(
                                    children: [
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                                StateSetter setState) =>
                                            Theme(
                                          data: Theme.of(context)
                                              .copyWith(canvasColor: backColor),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                                value: selectedFont,
                                                isExpanded: true,
                                                menuMaxHeight: 400.h,
                                                onChanged: (newValue) {
                                                  selectedFont =
                                                      newValue ?? 'Segoe';

                                                  selectedTextStyle = fontNames
                                                      .where((element) =>
                                                          element ==
                                                          selectedFont)
                                                      .first;

                                                  gs.write(
                                                      libFont, selectedFont);

                                                  ///For updating inside
                                                  setState(() {});
                                                  controllerPaging.paginate();
                                                  updateUI();
                                                },
                                                items: fontNames.map<
                                                    DropdownMenuItem<
                                                        String>>((String font) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: font,
                                                    child: Text(
                                                      font,
                                                      style: TextStyle(
                                                          color: selectedFont ==
                                                                  font
                                                              ? widget
                                                                  .accentColor
                                                              : fontColor,
                                                          package:
                                                              'cosmos_epub',
                                                          fontSize:
                                                              context.isTablet
                                                                  ? 10.sp
                                                                  : 15.sp,
                                                          fontWeight:
                                                              selectedFont ==
                                                                      font
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                          fontFamily: font),
                                                    ),
                                                  );
                                                }).toList()),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Aa",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: fontColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              activeColor: staticThemeId == 4
                                                  ? Colors.grey.withOpacity(0.8)
                                                  : Colors.blue,
                                              value: _fontSizeProgress,
                                              min: 15.0,
                                              max: 30.0,
                                              onChangeEnd: (double value) {
                                                _fontSize = value;

                                                gs.write(
                                                    libFontSize, _fontSize);

                                                ///For updating outside
                                                updateUI();
                                                controllerPaging.paginate();
                                              },
                                              onChanged: (double value) {
                                                ///For updating widget's inside
                                                setState(() {
                                                  _fontSizeProgress = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(
                                            "Aa",
                                            style: TextStyle(
                                                color: fontColor,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )));
        });
  }

  updateTheme(int id, {bool isInit = false}) {
    staticThemeId = id;
    if (id == 1) {
      backColor = cVioletishColor;
      fontColor = Colors.black;
    } else if (id == 2) {
      backColor = cBluishColor;
      fontColor = Colors.black;
    } else if (id == 3) {
      backColor = Colors.white;
      fontColor = Colors.black;
    } else if (id == 4) {
      backColor = Colors.black;
      fontColor = Colors.white;
    } else {
      backColor = cPinkishColor;
      fontColor = Colors.black;
    }

    gs.write(libTheme, id);

    if (!isInit) {
      Navigator.of(context).pop();
      controllerPaging.paginate();
      updateUI();
    }
  }

  ///Update widget tree
  updateUI() {
    setState(() {});
  }

  nextChapter() async {
    ///Set page to initial
    await bookProgress.setCurrentPageIndex(bookId, 0);

    var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    if (index != chaptersList.length - 1) {
      reLoadChapter(index: index + 1);
    }
  }

  prevChapter() async {
    ///Set page to initial
    await bookProgress.setCurrentPageIndex(bookId, 0);

    var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

    if (index != 0) {
      reLoadChapter(index: index - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(DESIGN_WIDTH, DESIGN_HEIGHT));

    return WillPopScope(
        onWillPop: backPress,
        child: Scaffold(
          backgroundColor: backColor,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: Stack(
                      children: [
                        FutureBuilder<void>(
                            future: loadChapterFuture,
                            builder: (context, snapshot) {
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
                                    if (widget.shouldOpenDrawer) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        openTableOfContents();
                                      });

                                      widget.shouldOpenDrawer = false;
                                    }

                                    var currentChapterIndex = bookProgress
                                            .getBookProgress(bookId)
                                            .currentChapterIndex ??
                                        0;

                                    return PagingWidget(
                                      textContent,
                                      innerHtmlContent,

                                      ///Do we need this to the production
                                      lastWidget: null,
                                      starterPageIndex: bookProgress
                                              .getBookProgress(bookId)
                                              .currentPageIndex ??
                                          0,
                                      style: TextStyle(
                                          backgroundColor: backColor,
                                          fontSize: _fontSize.sp,
                                          fontFamily: selectedTextStyle,
                                          package: 'cosmos_epub',
                                          color: fontColor),
                                      handlerCallback: (ctrl) {
                                        controllerPaging = ctrl;
                                      },
                                      onTextTap: () {
                                        if (showHeader) {
                                          showHeader = false;
                                        } else {
                                          showHeader = true;
                                        }
                                        updateUI();
                                      },
                                      onPageFlip: (currentPage, totalPages) {
                                        if (widget.onPageFlip != null) {
                                          widget.onPageFlip!(
                                              currentPage, totalPages);
                                        }

                                        if (currentPage == totalPages - 1) {
                                          bookProgress.setCurrentPageIndex(
                                              bookId, 0);
                                        } else {
                                          bookProgress.setCurrentPageIndex(
                                              bookId, currentPage);
                                        }

                                        if (isLastPage) {
                                          showHeader = true;
                                        } else {
                                          lastSwipe = 0;
                                        }

                                        isLastPage = false;
                                        updateUI();

                                        if (currentPage == 0) {
                                          prevSwipe++;
                                          if (prevSwipe > 1) {
                                            prevChapter();
                                          }
                                        } else {
                                          prevSwipe = 0;
                                        }
                                      },
                                      onLastPage: (index, totalPages) async {
                                        if (widget.onLastPage != null) {
                                          widget.onLastPage!(index);
                                        }

                                        if (totalPages > 1) {
                                          lastSwipe++;
                                        } else {
                                          lastSwipe = 2;
                                        }

                                        if (lastSwipe > 1) {
                                          nextChapter();
                                        }

                                        isLastPage = true;

                                        updateUI();
                                      },
                                      chapterTitle:
                                          chaptersList[currentChapterIndex]
                                              .chapter,
                                      totalChapters: chaptersList.length,
                                    );
                                  }
                              }
                            }),
                        //)

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Visibility(
                            visible: showBrightnessWidget,
                            child: Container(
                                height: 150.h,
                                width: 30.w,
                                alignment: Alignment.bottomCenter,
                                margin:
                                    EdgeInsets.only(bottom: 40.h, right: 15.w),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.brightness_7,
                                      size: 14.h,
                                      color: fontColor,
                                    ),
                                    SizedBox(
                                      height: 120.h,
                                      width: 30.w,
                                      child: RotatedBox(
                                          quarterTurns: -1,
                                          child: SliderTheme(
                                              data: SliderThemeData(
                                                activeTrackColor:
                                                    staticThemeId == 4
                                                        ? Colors.white
                                                        : Colors.blue,
                                                disabledThumbColor:
                                                    Colors.transparent,
                                                inactiveTrackColor: Colors.grey
                                                    .withOpacity(0.5),
                                                trackHeight: 5.0,

                                                thumbColor: staticThemeId == 4
                                                    ? Colors.grey
                                                        .withOpacity(0.8)
                                                    : Colors.blue,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            0.r),
                                                // Adjust the size of the thumb
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                        overlayRadius: 10
                                                            .r), // Adjust the size of the overlay
                                              ),
                                              child: Slider(
                                                value: brightnessLevel,
                                                min: 0.0,
                                                max: 1.0,
                                                onChangeEnd: (double value) {
                                                  setBrightness(value);
                                                },
                                                onChanged: (double value) {
                                                  setState(() {
                                                    brightnessLevel = value;
                                                  });
                                                },
                                              ))),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      ],
                    )),
                    AnimatedContainer(
                      height: showHeader ? 40.h : 0,
                      duration: const Duration(milliseconds: 100),
                      color: backColor,
                      child: Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backColor,
                          border: Border(
                            top: BorderSide(
                                width: 3.w, color: widget.accentColor),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5.w,
                            ),
                            Visibility(
                              visible: showPrevious,
                              child: IconButton(
                                  onPressed: () {
                                    prevChapter();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    size: 15.h,
                                    color: fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              flex: 10,
                              child: Text(
                                chaptersList.isNotEmpty
                                    ? chaptersList[bookProgress
                                                .getBookProgress(bookId)
                                                .currentChapterIndex ??
                                            0]
                                        .chapter
                                    : 'Loading...',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: selectedTextStyle,
                                    package: 'cosmos_epub',
                                    fontWeight: FontWeight.bold,
                                    color: fontColor),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Visibility(
                                visible: showNext,
                                child: IconButton(
                                    onPressed: () {
                                      nextChapter();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15.h,
                                      color: fontColor,
                                    ))),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  height: showHeader ? 50.h : 0,
                  duration: const Duration(milliseconds: 100),
                  color: backColor,
                  child: Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: AppBar(
                      centerTitle: true,
                      title: Text(
                        bookTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: fontColor),
                      ),
                      backgroundColor: backColor,
                      shape: Border(
                          bottom: BorderSide(
                              color: widget.accentColor, width: 3.h)),
                      elevation: 0,
                      leading: IconButton(
                        onPressed: openTableOfContents,
                        icon: Icon(
                          Icons.menu,
                          color: fontColor,
                          size: 20.h,
                        ),
                      ),
                      actions: [
                        InkWell(
                            onTap: () {
                              updateFontSettings();
                            },
                            child: Container(
                              width: 40.w,
                              alignment: Alignment.center,
                              child: Text(
                                "Aa",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: fontColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkWell(
                            onTap: () async {
                              setState(() {
                                showBrightnessWidget = true;
                              });
                              await Future.delayed(const Duration(seconds: 7));
                              setState(() {
                                showBrightnessWidget = false;
                              });
                            },
                            child: Icon(
                              Icons.brightness_high_sharp,
                              size: 20.h,
                              color: fontColor,
                            )),
                        SizedBox(
                          width: 10.w,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  openTableOfContents() async {
    bool? shouldUpdate = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChaptersList(
                  bookId: bookId,
                  chapters: chaptersList,
                  leadingIcon: null,
                  accentColor: widget.accentColor,
                  chapterListTitle: widget.chapterListTitle,
                ))) ??
        false;
    if (shouldUpdate) {
      var index = bookProgress.getBookProgress(bookId).currentChapterIndex ?? 0;

      ///Set page to initial and update chapter index with content
      await bookProgress.setCurrentPageIndex(bookId, 0);
      reLoadChapter(index: index);
    }
  }
}

// ignore: must_be_immutable
