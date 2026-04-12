# Backlog do Produto - Sistema de Agendamento Odontológico

Este documento centraliza todos os requisitos funcionais, não funcionais e regras de negócio, organizados em itens de trabalho para o desenvolvimento do sistema.

## EPIC 1: Segurança & Conformidade (LGPD & Ética)

Prioridade: Crítica | Objetivo: Garantir a segurança dos dados sensíveis do paciente.

- [ ] Criptografia de Dados [RN06](rn.md)/[RNF01](rnf.md): Implementar criptografia de ponta a ponta para prontuários e dados de saúde, seguindo as normas de sigilo médico.

- [ ] Processamento de Imagem no Dispositivo [RN05](rn.md): Desenvolver módulo de processamento local para fotos de tratamentos, garantindo que as imagens originais não sejam expostas externamente.

- [ ] Configuração de Disponibilidade [RNF01/RNF05](rnf.md): Configurar infraestrutura 24/7 com sincronização automática e cópia de segurança (backup) na nuvem (Firebase).

## EPIC 2: Motor de Agendamento Central (Agendamento Inteligente)

Prioridade: Alta | Objetivo: Criar um fluxo de marcação rápido, intuitivo e sem erros.

- [ ] Calendário em Tempo Real [RF02](rf.md): Interface de calendário integrada para escolha de data e hora com atualização em tempo real.

- [ ] Algoritmo de Conflito Zero [RN02](rn.md): Lógica de processamento (backend) para impedir agendamentos simultâneos no mesmo horário.

- [ ] Otimização de Desempenho [RNF02](rnf.md): Otimizar a consulta de vagas para garantir que o carregamento ocorra em menos de 2 segundos.

- [ ] Triagem de Emergência [RN03](rn.md): Implementar um fluxo prioritário para pacientes que selecionarem a opção "Dor Aguda".

## EPIC 3: Gestão Clínica & do Paciente

Prioridade: Média | Objetivo: Facilitar o dia a dia da Dra. Thais e a gestão dos perfis.

- [ ] Perfis de Pacientes [RF01](rf.md): Sistema de registo de pacientes com histórico básico e visualização da evolução do tratamento.

- [ ] Painel de Prontuários Médicos [RF06](rf.md): Área restrita ao dentista para anotações de procedimentos e prescrições.

- [ ] Lógica de Cancelamento/Reagendamento [RF03](rf.md)/[RN01](rn.md): Implementar a validação de antecedência mínima de 24 horas para alterações sem custos adicionais.

## EPIC 4: Envolvimento & Inteligência

Prioridade: Alta | Objetivo: Reduzir faltas (absenteísmo) e esclarecer dúvidas.

- [ ] Notificações Push (RF04): Sistema de lembretes automáticos enviados 24h antes da consulta via FCM (Firebase Cloud Messaging).

- [ ] Confirmação Obrigatória (RN04): Lógica que exige a confirmação através de um link para validar o horário agendado.

- [ ] ChatBox Interativo (IA): Implementar interface de IA estilo chat para esclarecimento de dúvidas sobre procedimentos clínicos.

- [ ] Galeria de Tratamento (RF05): Galeria para acompanhamento visual da evolução do tratamento do paciente.

---

## Tabela de SLA e Nível de Serviço (Qualidade)

A tabela abaixo define os indicadores de performance e qualidade (SLA) que o sistema deve manter para garantir uma boa experiência de utilizador e conformidade legal.

ID    | Indicador de Serviço       | Métrica Alvo (SLA)          | Estado
------|----------------------------|-----------------------------|---------
RNF01 | Disponibilidade do Sistema | 99.9% do tempo (24/7)       | Pendente
RNF02 | Tempo de Resposta          | < 2.0 segundos              | Pendente
RNF03 | Responsividade Visual      | Compatibilidade 100% Mobile | Pendente 
RN06  | Segurança (LGPD)           | Criptografia AES-256 ativa  | Pendente
RF04  | Entrega de Notificações    | < 5 minutos de atraso       | Pendente

---

## Tecnologias & Padrões:

### Framework: 
- Flutter (Dart) ou React Native.

### Arquitetura: 
- MVVM (Model-View-ViewModel).

### Backend: 
- Firebase (Auth, Firestore, Cloud Messaging).
