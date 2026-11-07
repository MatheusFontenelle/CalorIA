# CalorIA — banco de memória do projeto

Última atualização: 2026-11-07
Ponto de referência: `v2.0` / commit `6d142ef`

Este arquivo registra o estado real do projeto para retomarmos o trabalho sem
precisar reconstruir o contexto. O repositório é um app de relógio Garmin
Connect IQ escrito em Monkey C.

## Objetivo do MVP

Permitir que a pessoa registre alimentos consumidos no dia, escolha uma porção,
veja o total de calorias e mantenha esse registro salvo no relógio.

Escopo mínimo adotado para o MVP:

- catálogo pequeno e fixo de alimentos;
- escolha por categoria, alimento e porção;
- total diário de calorias na tela principal;
- histórico das entradas do dia;
- desfazer a última entrada;
- zerar o dia;
- persistência local, sem backend e sem sincronização externa.

## O que já está implementado

### Aplicação e navegação

- App `CalorIAApp` com tela inicial e delegate de comportamento.
- Menu principal com as ações:
  - Adicionar alimento;
  - Ver histórico;
  - Desfazer adição;
  - Zerar hoje.
- Fluxo de adição: categoria → alimento → porção → confirmação.
- Atualização da tela após adicionar, desfazer ou zerar.

### Catálogo

- Catálogo inicial em `source/CalorIAFoodCatalog.mc`.
- Categoria atual: `Fruta`.
- Alimentos atuais: banana e maçã.
- Cada alimento possui identificador, nome, categoria e opções de porção com
  calorias.

### Registro diário

- Entradas guardadas com `foodId`, `foodName`, `portionLabel` e `calories`.
- Soma diária calculada a partir das entradas, sem manter um total duplicado.
- Histórico exibe alimento, porção e calorias de cada registro.
- Estado vazio exibe `Sem registros hoje`.

### Persistência

- Uso de `Application.Storage` em `source/CalorIAApp.mc`.
- Chaves principais: `todayEntries` e `lastSavedDate`.
- Ao abrir em outro dia, o registro atual é iniciado vazio.
- Existe migração do formato antigo baseado em `totalCalories` para uma entrada
  legada, preservando o valor já salvo.

### Projeto Garmin

- Produto configurado para `fr55`.
- `minApiLevel` configurado como `3.4.0`.
- Idioma declarado: `por`.
- Permissão declarada: `Fit`.
- Assets de launcher e ícones presentes em `resources/drawables`.
- A chave privada fica em `GarminKeys/developer_key` e não é versionada.

## Histórico relevante

- `65ff6ae` — commit inicial com a estrutura do app, tela de calorias e
  recursos básicos.
- `6d142ef` / tag `v2.0` — catálogo de alimentos, seleção de porções,
  histórico diário, desfazer, reset e persistência por entrada.

## Estado atual e limitações conhecidas

- A cópia local está sincronizada com `origin/main` e sem alterações pendentes
  no momento desta atualização.
- O SDK/`monkeyc` não está disponível no ambiente atual; o build e o teste no
  simulador ou no FR55 ainda precisam ser executados em uma máquina com o
  Connect IQ SDK instalado.
- `GarminKeys/` e `bin/` estão no `.gitignore`; em outra máquina é necessário
  configurar uma chave de desenvolvedor localmente.
- O arquivo `.vscode/settings.json` contém apenas o caminho local da chave e
  também não é enviado ao Git.
- O histórico atual é somente do dia corrente; não existe consulta de dias
  anteriores.
- O catálogo ainda é pequeno e estático; não há edição de alimentos pelo
  usuário, busca ou integração com banco nutricional.
- A tela principal mostra o total, mas ainda não há meta diária, progresso ou
  feedback visual mais rico.
- É necessário validar no build/runtime a navegação dos delegates e o
  comportamento do `Picker` no modelo FR55.

## Plano mínimo para expor o MVP

### P0 — obrigatório antes de divulgar

1. Instalar/selecionar o Connect IQ SDK e configurar uma `developer_key` local.
2. Compilar para `fr55` e corrigir eventuais erros de API ou tipagem.
3. Executar o fluxo completo no simulador ou no relógio:
   - abrir menu;
   - adicionar alimento;
   - escolher porção;
   - confirmar;
   - conferir total;
   - abrir histórico;
   - desfazer;
   - zerar;
   - fechar e abrir novamente para validar persistência.
4. Corrigir problemas visuais/linguísticos encontrados no teste, especialmente
   acentuação e textos de menu.

### P1 — melhoria pequena, se couber sem aumentar o escopo

1. Adicionar mais alguns alimentos comuns ao catálogo.
2. Melhorar a apresentação do total e do histórico no espaço limitado do FR55.
3. Adicionar uma mensagem de confirmação ou feedback após zerar o dia.
4. Criar um `README.md` curto com instalação, build e uso.

## Fora do MVP

Não iniciar estes itens antes de validar o fluxo básico:

- login, conta ou backend;
- sincronização com Garmin Connect;
- banco nutricional online;
- reconhecimento automático de alimentos;
- metas avançadas, gráficos e histórico de vários dias;
- notificações, widgets ou companion app;
- cadastro/edição completa de alimentos pelo relógio.

## Critério de pronto

O MVP está pronto quando o app compilar para o FR55 e uma pessoa conseguir
registrar uma refeição, escolher sua porção, ver o total diário, consultar e
desfazer o registro, zerar o dia e recuperar corretamente os dados após
reabrir o app — tudo sem depender de internet ou de arquivos privados no
repositório.

## Como retomar

1. Ler este arquivo.
2. Conferir `git status` e o commit atual.
3. Configurar o SDK e a chave privada local.
4. Executar o build para `fr55` antes de ampliar o catálogo ou criar novas
   funcionalidades.
5. Atualizar este arquivo sempre que uma decisão de escopo ou uma entrega do
   MVP mudar.
