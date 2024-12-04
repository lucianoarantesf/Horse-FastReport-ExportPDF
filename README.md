# API de Pizzaria

Esta API foi desenvolvida utilizando a linguagem **Delphi** e o framework **Horse**. Seu objetivo é fornecer dados relacionados a uma pizzaria e permitir a exportação de relatórios em formato PDF.

## Funcionalidades

1. **Exibição de Dados de Pizzaria:**
   - Retorna informações sobre as pizzas disponíveis.
   - Filtro por `id` opcional.

2. **Geração de Relatórios em PDF:**
   - Relatório gerado e exportado diretamente.
   - Relatório pode ser visualizado ou baixado.

---

## Endpoints

### 1. **GET /pizzas**
Retorna uma lista de pizzas em formato JSON.

**Parâmetros de Consulta:**
- `id` (opcional): Filtra o resultado pelo ID da pizza.

**Exemplo de Resposta:**
```json
[
  {
    "id": 1,
    "nome": "Margherita",
    "preco": 25.00
  },
  {
    "id": 2,
    "nome": "Pepperoni",
    "preco": 30.00
  }
]
```

### 2. **GET /pizzas/open/pdf**
Gera um relatório PDF com os dados de pizzas e retorna o arquivo como stream.

**Cabeçalhos de Resposta:**
- `Content-Type: application/octet-stream`

### 3. **GET /pizzas/create/pdf**
Gera e retorna o relatório PDF com os dados de pizzas baseado em um arquivo `.fr3` pré-configurado.

**Cabeçalhos de Resposta:**
- `Content-Type: application/octet-stream`

---

## Estrutura do Código

### Unidade: `controllers.pizzas`

#### Principais Procedimentos

1. **getPizzas:**
   - Recupera dados da pizzaria via `TServicesPizzas`.
   - Converte o resultado para JSON utilizando `DataSet.Serialize`.

2. **onOpenPdfPizzas:**
   - Gera um relatório PDF diretamente no fluxo de memória utilizando `frxReport` e `frxPDFExport`.
   - Envia o arquivo gerado como resposta.

3. **onCreatePdfPizzas:**
   - Carrega e gera um relatório com base em um modelo `.fr3`.
   - Exporta o relatório para PDF e retorna ao cliente.

#### Registro dos Endpoints
Os endpoints são registrados no método `TPizzas.registry` utilizando o grupo `THorse.Group`.

---

## Dependências

- **Horse Framework:** Para construção da API REST.
- **DataSet.Serialize:** Para serialização de dados em JSON.
- **FastReport:** Para geração de relatórios em PDF.

---

## Como Executar

1. Certifique-se de ter o Delphi configurado.
2. Adicione as dependências necessárias ao projeto.
3. Compile e execute o projeto.
4. Acesse os endpoints utilizando uma ferramenta como Postman ou diretamente pelo navegador.

---

## Exemplo de Uso do FastReport

- Relatório `.fr3` armazenado no caminho:
  ```
  {caminho_do_projeto}/report/cardapio-pizzas.fr3
  ```
- Configuração do `frxReport`:
  ```pascal
  frxReport.LoadFromFile('{caminho_do_arquivo}');
  frxReport.PrepareReport;
  frxReport.Export(frxPDFExport);
  ```

---

## Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests no repositório.

---

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).
