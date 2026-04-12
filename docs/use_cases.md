# CASOS DE USO - Dra Thais Tardelli

## UC01 - Cadastro de Novo Paciente

### Ator Principal: 
- Paciente

### Requisito: 
- [RF01](rf.md)

### Fluxo Principal:
1. O usuário acessa o app e seleciona "Criar Perfil".
2. O usuário insere dados pessoais e histórico básico.
3. O sistema valida os dados e salva o perfil.

---

## UC02 - Agendamento de Consulta

### Ator Principal: 
- Paciente

### Requisitos/Regras:
- [RF02](rf.d), [RN02](rn.md), [RN03](rn.md)

### Fluxo Principal:
1. O paciente visualiza o calendário de vagas [RNF02](rnf.md)
2. O sistema verifica se há conflito de horários [RN02](rn.md)
3. Fluxo de Exceção (Emergência): Se o paciente selecionar "Dor Aguda", o sistema prioriza horários de encaixe ou fornece contato direto [RN03](rn.md)
4. O paciente confirma a escolha.

--- 

## UC03 - Confirmação de Consulta

### Ator Principal:
- Paciente

### Requisitos/Regras: 
- [RF04](rf.md), [RN04](rn.md)

### Fluxo Principal:
1. O sistema envia notificação push 24h antes da consulta [RF04](rf.md)
2. O paciente clica no link de confirmação recebido.
3. O status da consulta muda para "Confirmada" [RN04](rn.md)

---

### UC04 - Cancelamento ou Reagendamento

### Ator Principal: 
- Paciente

### Requisitos/Regras: 
- [RF03](rf.md), [RN01](rn.md)

### Fluxo Principal:
1. O paciente solicita o cancelamento da consulta.
2. O sistema verifica se a solicitação está sendo feita com mais de 24h de antecedência [RN01](rn.md).
3. Se sim, o cancelamento é processado sem custos.

--- 

## UC05 - Gestão de Prontuário e Evolução

### Ator Principal: 
- Dentista

### Requisitos/Regras: 
- [RF05](rf.md), [RF06](rf.md), [RN05](rn.md), [RN06](rn.md)

### Fluxo Principal:
1. O dentista acessa a área restrita do paciente [RF06](rf.md).
2. Anexa fotos do tratamento para acompanhar a evolução [RF05](rf.md).
3. O sistema processa as imagens localmente para garantir privacidade [RN05](rn.md).
4. Todos os dados são salvos com criptografia conforme LGPD [RN06](rn.md).

---

## UC06 - Análise Evoluitiva Automática: 

### Ator Principal: 
- Dentista

### Requisitos/Regras:
- [RF05](rf.md) (Evolução)

### Fluxo Principal: 
1. O dentista acessa a galeria do paciente e seleciona "Comparar Evolução".
2. O sistema solicita o upload ou captura de uma foto atual e seleciona a foto anterior (âncora).
3. A IA processa as imagens, sobrepõe as camadas e gera um gráfico de retração ou clareamento.

--- 

## UC07 - Suporte Pós-Procedimento [Concierge IA](# "É um assistente virtual inteligente, que utiliza inteligência artificial para oferecer atendimento personalizado, agendamentos automáticos e suporte em tempo real, comum em turismo, e-commerce e saúde"):

### Ator Principal: 
- Sistema / Paciente 

### Requisitos/Regras: 
- [RF04](rf.md) (Notificações)

### Fluxo Principal: 
1. O sistema identifica o encerramento de um procedimento invasivo no prontuário.
2. O sistema dispara mensagens automáticas via chat/push em intervalos pré-definidos (4h, 12h, 24h).
3. O paciente interage confirmando bem-estar ou relatando sintomas.

--- 

## UC08 - Simulação de Sorriso (Realidade Aumentada): 

### Ator Princiapl: 
- Paciente

### Requisitos/Regras:
- [RF05](rf.md) (Galeria/Imagem)

### Fluxo Principal: 
1. O usuário seleciona a opção "Preview de Sorriso" no menu de tratamentos.
2. O sistema ativa a câmera frontal e aplica o filtro 3D com as lentes de contato dentais.
3. O usuário visualiza o resultado e salva a imagem para anexar à solicitação de orçamento.

--- 

## UC09 - Triagem Diagnóstica (Detecção de Patologias): 

### Ator Principal:
- Dentista

### Requisitos/Regras:
- [RF06](rf.md) (Prontuário)

### Fluxo Principal: 
1. O dentista captura ou faz upload de uma foto macro da arcada dentária.
2. O sistema processa a imagem via algoritmo de visão computacional para identificar cáries ou inflamações.
3. O sistema destaca as áreas afetadas e sugere o código CID para preenchimento automático do prontuário.

--- 

## UC10 - Gestão de Lista de Espera Inteligente: 

### Ator Principal: 
- Sistema / Paciente

### Requisitos/Regras:
- [RF03](rf.md) (Cancelamento/Reagendamento)

### Fluxo Principal: 
1. O sistema registra um cancelamento de horário na agenda principal.
2. O sistema filtra pacientes em espera com base em localização (proximidade) e urgência do perfil.
3. O sistema envia uma notificação de "Vaga Prioritária" para os candidatos selecionados e confirma o primeiro aceite.


