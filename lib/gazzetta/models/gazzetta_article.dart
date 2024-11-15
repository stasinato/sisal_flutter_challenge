import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

import 'package:xml/xml.dart';

class GazzettaArticle {
  final String title;
  final String link;
  final String creator;
  final String pubDate;
  final String category;
  final String guid;
  final String description;
  final String thumbnail;

  GazzettaArticle({
    required this.title,
    required this.link,
    required this.creator,
    required this.pubDate,
    required this.category,
    required this.guid,
    required this.description,
    required this.thumbnail,
  });

  factory GazzettaArticle.fromXmlElement(XmlElement xml) {
    final HtmlUnescape unescape = HtmlUnescape();

    return GazzettaArticle(
      title: unescape.convert(xml.findElements('title').first.innerText),
      link: unescape.convert(xml.findElements('link').first.innerText),
      creator: unescape.convert(xml.findElements('dc:creator').first.innerText),
      pubDate: unescape.convert(xml.findElements('pubDate').first.innerText),
      category: unescape.convert(xml.findElements('category').first.innerText),
      guid: unescape.convert(xml.findElements('guid').first.innerText),
      description:
          unescape.convert(xml.findElements('description').first.innerText),
      thumbnail: xml.findElements('media:thumbnail').first.getAttribute('url')!,
    );
  }

  @override
  String toString() {
    return 'GazzettaArticle{title: $title, link: $link, creator: $creator, pubDate: $pubDate, category: $category, guid: $guid, description: $description, thumbnail: $thumbnail}';
  }
}
