import 'dart:convert';
import 'dart:html';

class Pesquisa {
  String title = '';
  String url;
  Pesquisa({
    required this.title,
    required this.url,
  });
  factory Pesquisa.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as String;
    final url = json['url'] as String;
    return Pesquisa(title: title, url: url);
  }
  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }

  static fromJSON(e) {}
}
