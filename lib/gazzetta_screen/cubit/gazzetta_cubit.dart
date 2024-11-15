import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../models/gazzetta_article.dart';
import '../repository/gazzetta_repository.dart';

part 'gazzetta_state.dart';

class GazzettaCubit extends Cubit<GazzettaState> {
  GazzettaCubit() : super(GazzettaInitial()) {
    fetchSoccerFeedData();
  }

  final _repository = GazzettaRepository();

  Future<void> fetchSoccerFeedData() async {
    emit(GazzettaLoading());
    try {
      final feedData = await _repository.fetchSoccerFeedData();
      final articles = _parseArticles(feedData);
      emit(GazzettaLoaded(articles: articles));
    } catch (e) {
      emit(GazzettaError(error: e.toString()));
    }
  }

  List<GazzettaArticle> _parseArticles(String feedData) {
    final articles = <GazzettaArticle>[];
    final document = XmlDocument.parse(feedData);
    final articlesXml = document.findAllElements('item');
    for (final xmlItem in articlesXml) {
      articles.add(GazzettaArticle.fromXmlElement(xmlItem));
    }
    return articles;
  }
}
