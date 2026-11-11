# Retail Open Lakehouse Platform

<p align="left">
  <img src="https://img.shields.io/badge/DuckDB-1.1.3-FFF000?style=for-the-badge&logo=duckdb&logoColor=black" alt="DuckDB" />
  <img src="https://img.shields.io/badge/Apache_Parquet-Colunar-005C8A?style=for-the-badge&logo=apache&logoColor=white" alt="Apache Parquet" />
  <img src="https://img.shields.io/badge/dbt_Core-1.8.7-FF694B?style=for-the-badge&logo=dbt&logoColor=white" alt="dbt" />
  <img src="https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/PyArrow-26.0-blue?style=for-the-badge" alt="PyArrow" />
  <img src="https://img.shields.io/badge/Ubuntu_24.04-WSL2-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu" />
  <img src="https://img.shields.io/badge/VS_Code-Editor-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white" alt="VS Code" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</p>

Plataforma de **Modern Data Lakehouse** baseada na arquitetura Medallion (Bronze, Silver e Gold), desacoplando armazenamento e computação analítica. Utiliza **DuckDB** como motor colunar embedded, arquivos **Apache Parquet** como formato de armazenamento aberto e **dbt-core** (`dbt-duckdb`) para transformações, modelagem dimensional e governança de dados.

---

## 🏛 Arquitetura Medallion & Topologia

```text
[Fontes Transacionais / Python Faker]
│
├── data_lake/bronze/ (Ingestão Raw em Parquet com auditoria temporal _ingested_at)
│   ├── clientes.parquet
│   ├── lojas.parquet
│   ├── produtos.parquet
│   └── vendas.parquet
│
├── dbt-duckdb (Camada Silver: tipagem, limpeza e deduplicação analítica)
│   ├── silver_clientes (view)
│   ├── silver_lojas (view)
│   ├── silver_produtos (view)
│   └── silver_vendas (view com ROW_NUMBER() determinístico)
│
└── data_lake/gold/ (Kimball Star Schema e Datamarts em Parquet colunar)
    ├── dim_calendario.parquet
    ├── dim_clientes.parquet
    ├── dim_lojas.parquet
    ├── dim_produtos.parquet
    ├── fato_vendas/ (Hive Partitioned por ano_venda e mes_venda)
    └── dm_vendas_mensal_categoria.parquet
```

### Detalhamento das Camadas

* **Bronze (`data_lake/bronze/`)**: Arquivos binários Parquet gerados via PyArrow com compressão Snappy, preservando o dado bruto como chegou da origem e registrando timestamps de auditoria de carga.
* **Silver**: Camada lógica gerenciada pelo dbt responsável por tipagem estrita, higienização semântica e deduplicação analítica via janelamento (`ROW_NUMBER() OVER (PARTITION BY id_venda ORDER BY _ingested_at DESC)`).
* **Gold (`data_lake/gold/`)**: Star Schema de Ralph Kimball materializado como arquivos Parquet colunares independentes no disco:
  - `dim_clientes.parquet`: Chave substituta MD5 e atributos cadastrais limpos.
  - `dim_lojas.parquet`: Hierarquia geográfica e regional.
  - `dim_produtos.parquet`: Categorização e margens brutas unitárias.
  - `dim_calendario.parquet`: Granularidade diária com indicadores de trimestres e fins de semana.
  - `fato_vendas/ (Hive Partitioned por ano_venda e mes_venda)`: Grão no nível de item com métricas de receita bruta, descontos, receita líquida, custo total e lucro bruto.
  - `dm_vendas_mensal_categoria.parquet`: Datamart analítico consolidando pedidos, itens comercializados e ticket médio.

---

## 🛠 Stack Tecnológica

| Componente | Ferramenta | Papel na Arquitetura |
|---|---|---|
| **Motor Analítico (Compute)** | DuckDB 1.1.3 | Execução analítica in-process vetorizada em C++ |
| **Formato de Armazenamento** | Apache Parquet (via PyArrow) | Arquivos colunares abertos, eficientes e de alta compressão |
| **Transformação e Governança** | dbt-core 1.8.7 (`dbt-duckdb` 1.8.3) | Linhagem de dados (DAG), testes de integridade e modelagem SQL |
| **Ingestão Sintética** | Python 3.12 (Pandas, Faker) | Simulação de eventos e geração controlada de volumes de varejo |
| **Ambiente de Desenvolvimento** | VS Code no WSL2 (Ubuntu 24.04) | Edição de modelos, depuração e controle de versão |
| **Orquestração Local** | Bash Shell (`setup.sh`, `run_pipeline.sh`) | Inicialização automática de dependências e execução da esteira |

---

## 🚀 Como Executar o Projeto

### 1. Clonar o repositório
```bash
git clone https://github.com/amisadaimodesto/retail-open-lakehouse.git
cd retail-open-lakehouse
```

### 2. Configurar o ambiente automaticamente
O script `setup.sh` inicializa o ambiente virtual `.venv`, atualiza o pip, instala os pacotes do `requirements.txt` e provisiona os diretórios de armazenamento:
```bash
./setup.sh
```

### 3. Rodar a esteira ponta a ponta
Executa ingestão Bronze, compilação Silver/Gold no dbt, validação dos testes e consulta analítica:
```bash
./run_pipeline.sh
```

### 4. Consultar os arquivos Parquet diretamente
```bash
python sql/query_lakehouse.py
```

---

## 🧪 Governança e Qualidade de Dados

O projeto conta com **19 testes automatizados** integrados:
* `unique` e `not_null` em todas as chaves primárias e substitutas (`sk_*`).
* `relationships` validando a integridade referencial estrita entre a `fato_vendas` e as dimensões do Star Schema diretamente sobre os arquivos Parquet.
* `accepted_values` validando regras de negócio para os status de faturamento (`APROVADO`, `CANCELADO`).

---

## 📄 Licença

Este projeto está distribuído sob a licença [MIT](LICENSE).
