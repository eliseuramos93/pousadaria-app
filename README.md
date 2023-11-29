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
    * [Listagem de quartos de uma pousada](https://github.com/eliseuramos93/pousadaria-app#listagem-de-quartos-de-uma-pousada)
    * [Detalhes de uma pousada](https://github.com/eliseuramos93/pousadaria-app#detalhes-de-uma-pousada)
    * [Consulta de disponibilidade](https://github.com/eliseuramos93/pousadaria-app#consulta-de-disponibilidade)

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

`https://localhost:3000/api/v1/inns`

Retorna uma listagem completa das pousadas cadastradas e ativas na plataforma. É possível informar um texto e usar como filtro de busca pelo nome da pousada, um nome de cidade para filtrar a listagem por cidades, e usar ambos os parâmetros para combinar os filtros. 

> Parâmetros necessários:
>
> Nenhum
>
> Parâmetros opcionais:
> 
> * name: Texto para utilizar no filtro aplicado aos nomes das pousadas
> * city: Texto com nome da cidade para utilizar no filtro 

Exemplos: 

`https://localhost:3000/api/v1/inns/?name=Pousadinha`

`https://localhost:3000/api/v1/inns/?city=São Paulo`

`https://localhost:3000/api/v1/inns/?name=Pousadinha&city:Florianópolis`

#### Listagem de quartos de uma pousada

`https://localhost:3000/api/v1/inns/:inn_id/rooms`

A partir do ID de uma pousada, você pode fazer o requerimento de uma lista com informações sobre os tipos de quartos disponíveis para hospedagem nesta pousada

> Parâmetros necessários:
>
> * inn_id: ID da pousada
>
> Parâmetros opcionais:
> 
> Nenhum

Exemplo:

`https://localhost:3000/api/v1/inns/1/rooms`

#### Detalhes de uma pousada

`https://localhost:3000/api/v1/inns/:inn_id`

A partir do ID de uma pousada, são exibids todos os detalhes púlbicos de uma pousada. O retorno inclui a nota média da pousada a partir de suas avaliações. Caso não existam avaliações o campo virá como uma string vazia.

> Parâmetros necessários:
>
> * inn_id: ID da pousada
>
> Parâmetros opcionais:
> 
> Nenhum

Exemplo:

`https://localhost:3000/api/v1/inns/1`

#### Consulta de disponibilidade

`https://localhost:3000/api/v1/rooms/:room_id/check_avaibility/?parametros`

Informando um ID de um quarto, a data de entrada, data de saída e quantidade de hóspedes, é ser possível verificar a disponibilidade para reserva. 

Se o quarto estiver disponível, será retornado o valor da reserva assim como um código da pré-reserva, em caso negativo será retornada uma lista de mensagens informando o motivo da requisição não gerar uma pré-reserva.

> Parâmetros necessários:
> 
> * room_id: ID do quarto que será reservado
> * start_date: Data de check-in, em formato yyyy-MM-dd, sem necessidade  de aspas
> * end_date: Data de check-out, em formato yyyy-MM-dd, sem necessidade de aspas
> * number_guests: Número de hóspedes da reserva
>
> Parâmetros opcionais:
>
> Nenhum.

Exemplo:

`http://localhost:3000/api/v1/rooms/2/check_availability/?start_date=2023-12-27&end_date=2023-12-29&number_guests=3&teste=%27reginaldo%27`

#### Listagem de cidades

`https://localhost:3000/api/v1/inns/city_list/`

Esse endpoint retorna uma listagem com todas as cidades em que existem pousadas cadastradas e ativas na plataforma.

> Parâmetros necessários:
> 
> Nenhum
>
> Parâmetros opcionais:
>
> Nenhum.