import 'package:flutter/material.dart';

class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de dicas com ícones, títulos e descrições reais
    final List<Map<String, dynamic>> dicasDeSaude = [
      {
        'titulo': 'A Importância do Fio Dental',
        'descricao':
            'O uso diário do fio dental remove a placa bacteriana onde a escova não consegue chegar. O fio dental deve ser passado suavemente entre todos os dentes, abraçando cada um deles em formato de "C" para garantir uma limpeza completa e evitar o surgimento de cáries entre os dentes.',
        'icone': Icons.cleaning_services,
        'corFundo': Colors.teal[50],
        'corIcone': Colors.teal,
      },
      {
        'titulo': 'Sensibilidade nos Dentes?',
        'descricao':
            'Evite alimentos ácidos em excesso e consulte sua dentista sobre pastas para dentes sensíveis. A sensibilidade ocorre quando a camada protetora do dente (esmalte) se desgasta ou a gengiva se retrai, expondo a dentina. O tratamento adequado ajuda a aliviar esse desconforto no dia a dia.',
        'icone': Icons.health_and_safety,
        'corFundo': Colors.red[50],
        'corIcone': Colors.red,
      },
      {
        'titulo': 'Troca da Escova de Dentes',
        'descricao':
            'Especialistas recomendam trocar a sua escova de dentes a cada 3 meses para garantir a higiene. Usar uma escova desgastada não limpa os dentes de forma eficiente e acumula bactérias. Além disso, é importante trocar de escova após se recuperar de gripes ou resfriados.',
        'icone': Icons.brush,
        'corFundo': Colors.blue[50],
        'corIcone': Colors.blue,
      },
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dicasDeSaude.length,
        itemBuilder: (context, index) {
          final dica = dicasDeSaude[index];
          return NewsCard(
            titulo: dica['titulo'],
            descricao: dica['descricao'],
            icone: dica['icone'],
            corFundo: dica['corFundo'],
            corIcone: dica['corIcone'],
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final IconData icone;
  final Color corFundo;
  final Color corIcone;

  const NewsCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.corFundo,
    required this.corIcone,
  });

  // Função que exibe o pop-up com as informações completas
  void _mostrarDetalhes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Text(
            descricao,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _mostrarDetalhes(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: corFundo,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(icone, size: 36, color: corIcone),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: const TextStyle(fontSize: 8, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
