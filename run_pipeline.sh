#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
fi

echo "=========================================="
echo " [1/4] INICIANDO INGESTÃO NA CAMADA BRONZE"
echo "=========================================="
python -m src.ingest_bronze

cd dbt_lakehouse

echo "=========================================="
echo " [2/4] PROCESSANDO CAMADAS SILVER E GOLD  "
echo "=========================================="
dbt run --profiles-dir .

echo "=========================================="
echo " [3/4] EXECUTANDO TESTES DE GOVERNANÇA    "
echo "=========================================="
dbt test --profiles-dir .

cd ..

echo "=========================================="
echo " [4/4] EXECUTANDO CONSULTA SOBRE O LAKE   "
echo "=========================================="
python sql/query_lakehouse.py

echo "=========================================="
echo " ESTEIRA LAKEHOUSE CONCLUÍDA COM SUCESSO! "
echo "=========================================="
