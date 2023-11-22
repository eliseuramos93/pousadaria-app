# POUSADARIA

Este é um projeto desenvolvido durante meus estudos no programa TreinaDev, turma 11, de uma aplicação de aluguel de quartos em pousadas.

## Conteúdo
* [Sprints de desenvolvimento](https://github.com/eliseuramos93/pousadaria-app#sprints-de-desenvolvimento)
  * [Primeiro sprint](https://github.com/eliseuramos93/pousadaria-app#primeiro-sprint)
  * [Segundo sprint](https://github.com/eliseuramos93/pousadaria-app#segundo-sprint)
  * [Terceiro sprint](https://github.com/eliseuramos93/pousadaria-app#terceiro-sprint)
  * [Quarto sprint](https://github.com/eliseuramos93/pousadaria-app#quarto-sprint)
* [Banco de dados](https://github.com/eliseuramos93/pousadaria-app#banco-de-dados)
* [API](https://github.com/eliseuramos93/pousadaria-app#api)
  * [Introdução](https://github.com/eliseuramos93/pousadaria-app#introdução)
  * [Resultados](https://github.com/eliseuramos93/pousadaria-app#resultados)
  * [Erros](https://github.com/eliseuramos93/pousadaria-app#erros)
  * [Endpoints](https://github.com/eliseuramos93/pousadaria-app#endpoints)
    * [Lista de pousadas ativas](https://github.com/eliseuramos93/pousadaria-app#lista-de-pousadas-ativas)

## Sprints de desenvolvimento
### Primeiro sprint
* Criar conta como dono de pousada
* Cadastrar pousada
* Adicionar quartos
* Preços por período
### Segundo sprint
* Listagem de pousadas
* Pousadas por cidade
* Busca de pousadas
* Ver quartos
### Terceiro sprint
* Disponibilidade de quartos
* Reservar quarto
* Check-in
* Check-out
### Quarto sprint
* Avaliações de estadia
* API de Pousadas
* Pousadaria VueJS

## Banco de Dados

![Imagem com o desenho da estrutura de banco de dados](app/assets/images/database_v1.jpg)

## API

### Introdução

Essa API foi criada como uma das tarefas da sprint 4 do projeto, com o objetivo de disponibilizar quatro endpoints para outras aplicações poderem consultar as informações da Pousadaria.

### Resultados

Todos os resultados da API serão retornados no formato `JSON`. 

### Erros

Em caso de erro, será retornado um objeto JSON simples com a descrição do erro, além do código HTTP informando o tipo de erro que aconteceu.

### Endpoints

#### Lista de pousadas ativas

Você pode fazer o requerimento de todas as pousadas ativas na Pousadaria através do endpoint abaixo:

`https://localhost:3000/api/v1/inns`

Você também pode filtrar as pousadas ativas pelo nome, usando o parâmetro **name**.

`https://localhost:3000/api/v1/inns/?name=Pousadinha`