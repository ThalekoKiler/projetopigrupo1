# 📖 Regras de Negócio (RN)

As regras que definem como a clínica opera através do aplicativo.

### 1. Política de Agendamento
| ID | Requisito | Descrição |
|:---|:---|:---|
|**RN01**|Antecedência de Cancelamento|O paciente só pode cancelar ou reagendar sem custos até 24 horas antes do horário marcado|
|**RN02**|Conflito de Horários|O sistema deve impedir que dois pacientes agendem o mesmo horário simultaneamente.|

### 2. Triagem e Inteligência
| ID | Requisito | Descrição |
|:---|:---|:---|
|**RN03**|Validação de Emergência|Se o paciente marcar "Dor Aguda", o sistema deve priorizar a exibição de horários de encaixe ou fornecer o contato direto de urgência.|
|**RN04**|Confirmação Obrigatória|Consultas só são confirmadas após o paciente clicar no link de confirmação enviado via notificação push.|

### 3. Ética e Documentação
| ID | Requisito | Descrição |
|:---|:---|:---|
|**RN05**|Registro de Evolução|Fotos de tratamento capturadas pelo app devem ser processadas localmente (*On-Device*) para garantir a privacidade extrema das imagens bucais do paciente.|
|**RN06**|Segurança de Dados (LGPD|Todos os prontuários e dados de saúde devem ser criptografados, seguindo as normas de sigilo médico-paciente.|

