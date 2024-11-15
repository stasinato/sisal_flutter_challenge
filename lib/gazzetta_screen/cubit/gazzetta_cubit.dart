import 'dart:developer';

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

  final GazzettaRepository _gazzettaRepository = GazzettaRepository();

  Future<void> fetchSoccerFeedData() async {
    emit(GazzettaLoading());
    try {
      final List<GazzettaArticle> articles = [];
      final soccerFeedData = await _gazzettaRepository.fetchSoccerFeedData();
      log(soccerFeedData);
      final document = XmlDocument.parse(soccerFeedData);

      final articlesXml = document.findAllElements('item');
      for (XmlElement xmlItem in articlesXml) {
        articles.add(GazzettaArticle.fromXmlElement(xmlItem));
      }
      emit(GazzettaLoaded(articles: articles));
    } catch (e) {
      emit(GazzettaError());
    }
  }
}
