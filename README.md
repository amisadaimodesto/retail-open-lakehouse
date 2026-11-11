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
    ├── fato_vendas.parquet
    └── dm_vendas_mensal_categoria.parquet