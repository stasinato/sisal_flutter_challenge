import 'package:html_unescape/html_unescape.dart';
import 'package:xml/xml.dart';

class GazzettaArticle {
  final String title;
  final String link;
  final String description;
  final String thumbnail;

  GazzettaArticle({
    required this.title,
    required this.link,
    required this.description,
    required this.thumbnail,
  });

  factory GazzettaArticle.fromXmlElement(XmlElement xml) {
    final HtmlUnescape unescape = HtmlUnescape();

    return GazzettaArticle(
      title: unescape.convert(xml.findElements('title').first.innerText),
      link: unescape.convert(xml.findElements('link').first.innerText),
      description:
          unescape.convert(xml.findElements('description').first.innerText),
      thumbnail: xml.findElements('media:thumbnail').first.getAttribute('url')!,
    );
  }

  @override
  String toString() {
    return 'GazzettaArticle{title: $title, link: $link, description: $description, thumbnail: $thumbnail}';
  }
}
