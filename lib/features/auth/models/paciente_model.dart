class PacienteModel {
  final String nomeCompleto;
  final String cpf;
  final String genero;
  final String endereco;
  final String telefone;
  final String fotoUrl;
  final String status;

  PacienteModel({
    required this.nomeCompleto,
    required this.cpf,
    required this.genero,
    required this.endereco,
    required this.telefone,
    required this.fotoUrl,
    this.status = "Paciente Ativo",
  });

  factory PacienteModel.fromMap(Map<String, dynamic> data) {
    return PacienteModel(
      nomeCompleto: data['nomeCompleto'] ?? '',
      cpf: data['cpf'] ?? '',
      genero: data['genero'] ?? '',
      endereco: data['endereco'] ?? '',
      telefone: data['telefone'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      status: data['status'] ?? 'Pacinte Ativo',
    );
  }
}
