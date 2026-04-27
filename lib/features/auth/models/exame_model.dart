class ExameModel {
  final String titulo;
  final String data;
  final String urlDocumento;
  final String tipo;

  ExameModel({
    required this.titulo,
    required this.data,
    required this.urlDocumento,
    required this.tipo,
  });

  factory ExameModel.fromMap(Map<String, dynamic> data) {
    return ExameModel(
      titulo: data['titulo'] ?? '',
      data: data['data'] ?? '',
      urlDocumento: data['urlDocumento'] ?? '',
      tipo: data['tipo'] ?? 'Exame',
    );
  }
}
