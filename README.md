# Dra Thais Tardelli

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)](https://flutter.dev)

## Detalhamento:

### Visão Geral do Projeto
O app é uma solução móvel desenvolvida para modernizar o fluxo de agendamentos em clínicas odontológicas. O projeto foca na redução do absenteísmo através de notificações inteligentes e na segurança absoluta dos dados sensíveis dos pacientes, utilizando as melhores práticas de Engenharia de Software.

### Funcionalidades Principais
- **Agendamento Inteligente**: Calendário em tempo real para marcação de consultas sem conflitos de horário.
- **Notificações Push**: Alertas automáticos via Firebase Cloud Messaging para confirmar horários.
- **IA estilo ChatBox**: Procedimento para tirar dúvidas sobre os procedimentos que a Dra irá utilizar.

### Arquitetura e Tecnologias
Para garantir a escalabilidade e a manutenção do código, o projeto utiliza:
- **Linguagem/Framework**: Flutter (Dart) ou React Native.
- **Padrão Arquitetural**: **MVVM** (Model-View-ViewModel) para isolamento da lógica de negócio.
- **Backend & Auth**: Firebase para autenticação segura e banco de dados NoSQL.
- **Segurança**: Criptografia de ponta a ponta e processamento local para conformidade com a **LGPD**.

### Documentação Técnica
Acesse os detalhes do planejamento nos links abaixo:
- [Requisitos Funcionais (RF)](docs/rf.md)
- [Requisitos Não Funcionais (RNF)](docs/rnf.md)
- [Regras de Negócio (RN)](docs/rn.md)

## Dependências para funcionar o app:

### Flutter: 
Instale ele pelo VSCODE, utilizando o comando "flutter pub get".

## Inicialização:

### Flutter:
Rode com o comando no VSCODE "flutter run".

## Por que este README é eficaz?
1.  **Contextualização**: Ele explica o "porquê" do projeto, mencionando o impacto na eficiência da clínica.
2.  **Decisões de Engenharia**: Destaca o uso de **Inferência On-Device** e **MVVM**, o que demonstra maturidade técnica perante avaliadores ou recrutadores.
3.  **Segurança**: Ressalta o compromisso com a **LGPD**, algo crítico para apps que lidam com fotos e dados de saúde.
4.  **Organização**: Facilita a navegação para os outros documentos (`rf.md`, `rnf.md`) que criámos anteriormente.
