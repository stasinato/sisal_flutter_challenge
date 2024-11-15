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

  /// metodo per creare oggetto da un item xml
  factory GazzettaArticle.fromXmlElement(XmlElement xml) {
    /// uso la libreria html_unescape per decodificare i caratteri speciali nel
    /// titolo. Ad esempio &amp; diventa &
    final HtmlUnescape unescape = HtmlUnescape();

    return GazzettaArticle(
      title: unescape.convert(xml.findElements('title').first.innerText),
      link: xml.findElements('link').first.innerText,
      description: xml.findElements('description').first.innerText,
      thumbnail: xml.findElements('media:thumbnail').first.getAttribute('url')!,
    );
  }

  @override
  String toString() {
    return 'GazzettaArticle{title: $title, link: $link, description: $description, thumbnail: $thumbnail}';
  }
}
