# CalorIA

Aplicativo de contagem de calorias para relógios Garmin com Connect IQ.

## Intuito do projeto

O CalorIA foi criado para permitir que a pessoa registre rapidamente os alimentos consumidos diretamente pelo relógio, sem precisar abrir o celular a cada refeição.

O aplicativo mostra:

- total de calorias consumidas no dia;
- quantidade de alimentos registrados;
- histórico dos alimentos do dia;
- porções pré-configuradas para facilitar o registro;
- opção de desfazer o último lançamento;
- opção de zerar os registros do dia.

O projeto também serve como uma base aberta para estudos e melhorias em aplicações Garmin Connect IQ.

## Quem pode usar

Qualquer pessoa que tenha um Garmin compatível com o projeto pode utilizar o aplicativo. Atualmente, o projeto está configurado oficialmente para o **Garmin Forerunner 55 (FR55)**.

Desenvolvedores também podem adaptar o manifesto para outros relógios Connect IQ, desde que revisem a compatibilidade, a memória disponível e o tamanho da tela.

O CalorIA não exige conta, internet ou cadastro. Os registros atuais ficam armazenados localmente no relógio.

> Os valores calóricos são estimativas para acompanhamento pessoal e não substituem orientação de nutricionista ou profissional de saúde.

## Como usar no relógio

1. Abra o aplicativo CalorIA.
2. Abra o menu do relógio.
3. Selecione **Adicionar**.
4. Escolha uma categoria de alimentos.
5. Escolha o alimento.
6. Escolha a porção consumida.
7. O total diário será atualizado automaticamente.

No menu também estão disponíveis:

- **Histórico:** consulta os alimentos registrados no dia;
- **Desfazer:** remove o último alimento lançado;
- **Zerar:** apaga os registros do dia após confirmação.

## Instalação manual no relógio

Para instalar uma versão compilada:

1. Conecte o relógio ao computador por USB.
2. Gere o arquivo `.prg` para o modelo do relógio.
3. Abra a unidade `GARMIN` do relógio.
4. Copie o arquivo `.prg` para `GARMIN/APPS`.
5. Ejete o relógio com segurança.
6. Abra o CalorIA na lista de aplicativos do relógio.

## Como desenvolver

### Requisitos

- Visual Studio Code;
- extensão oficial **Monkey C**, da Garmin;
- Connect IQ SDK;
- chave de desenvolvedor Garmin para assinar o aplicativo.

### Compilação pelo VS Code

1. Clone este repositório.
2. Abra a pasta do projeto no VS Code.
3. Instale a extensão Monkey C.
4. Gere ou configure uma chave de desenvolvedor local.
5. Abra a paleta de comandos com `Ctrl + Shift + P`.
6. Execute **Monkey C: Build for Device**.
7. Selecione `fr55`.
8. Copie o `.prg` gerado para `GARMIN/APPS`.

Nunca envie a chave privada de desenvolvedor para o GitHub. A pasta `GarminKeys/` já está ignorada pelo Git.

## Estrutura principal

```text
source/                 Código Monkey C do aplicativo
resources/drawables/    Ícones e imagens
resources/layouts/      Layouts da interface
resources/menus/        Menus do aplicativo
resources/strings/      Textos exibidos na interface
manifest.xml            Configuração do aplicativo e dispositivos
monkey.jungle           Arquivo de compilação
```

## Estado atual

Na versão 3.0, o projeto possui:

- catálogo com 75 alimentos;
- cinco categorias de alimentos;
- quatro opções de porção por alimento;
- histórico visualizável do dia;
- armazenamento local no relógio;
- interface otimizada para a tela pequena do FR55;
- fluxo de adicionar, desfazer e zerar registros.

Ainda não há sincronização com celular, banco de dados ou histórico de vários dias. Essas funcionalidades podem fazer parte das próximas versões.

## Como contribuir

Sugestões, correções e melhorias são bem-vindas.

Fluxo sugerido:

1. Faça um fork do projeto.
2. Crie uma branch para sua alteração.
3. Faça a mudança e teste no simulador ou no relógio.
4. Envie um pull request explicando o que foi alterado.

Ao contribuir, tenha atenção ao limite de memória do FR55 e ao espaço reduzido da tela. Alterações no catálogo devem priorizar estruturas leves e textos curtos.

## Licença

O repositório está público para estudo, colaboração e evolução do projeto. Uma licença de código aberto formal ainda precisa ser escolhida para definir as permissões de reutilização e distribuição.
