import 'dart:developer';

import 'package:html/parser.dart';

/// All functions
bool isHTML(String str) {
  final RegExp htmlRegExp =
      RegExp('<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlRegExp.hasMatch(str);
}

String textToHtml(String text) {
  // log(text);
  // Define the HTML representation of a tab character
  const String tabReplacement = '&nbsp;&nbsp;&nbsp;&nbsp;';
  if (text.contains('\t')) {
    // Replace tabs with corresponding HTML non-breaking spaces
    text = text.replaceAll('\t', tabReplacement);
    print('\tPARA');
  }

  // Replace multiple newlines with corresponding number of <br> tags
  text = text.replaceAllMapped(RegExp(r'\n+'), (match) {
    return '<br>' * match.group(0)!.length;
  });

  // Split the text by double newlines to create paragraphs
  List<String> paragraphs = text.split(RegExp(r'\n\s*\n'));

  // Wrap each paragraph in <p> tags
  String html = paragraphs.map((paragraph) {
    // Replace single newlines within a paragraph with <br>
    paragraph = paragraph.replaceAll('\n', '<br>');
    return '<p>$paragraph</p>';
  }).join('');

  return html;
}

String htmlTrimSpaces(String html) {
  // Remove code breaks and tabs

  html = html.replaceAll('\n', '');
  html = html.replaceAll('\t', '');

  return html;
}

String htmlToText(String html) {
  // Remove code breaks and tabs

  html = html.replaceAll('\n', '');
  html = html.replaceAll('\t', '');

  // log(html);

  // Keep HTML breaks and tabs
  html = html.replaceAll('</td>', '\t');
  html = html.replaceAll('</table>', '\n');
  html = html.replaceAll('</tr>', '\n');
  html = html.replaceAll('</p>', '\n');
  html = html.replaceAll('</div>', '\n');
  html = html.replaceAll('</h>', '\n');
  html = html.replaceAll('<br>', '\n');
  html = html.replaceAll(RegExp(r'<br( )*/>'), '\n');

  // Parse HTML into text
  return parse(html).documentElement!.text;
}
