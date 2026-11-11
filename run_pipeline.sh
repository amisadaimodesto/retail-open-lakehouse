#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
fi

echo "=========================================="
echo " [1/5] INICIANDO INGESTÃO NA CAMADA BRONZE"
echo "=========================================="
python -m src.ingest_bronze

cd dbt_lakehouse

echo "=========================================="
echo " [2/5] PROCESSANDO CAMADAS SILVER E GOLD  "
echo "=========================================="
dbt run --profiles-dir .

echo "=========================================="
echo " [3/5] EXECUTANDO TESTES DE GOVERNANÇA    "
echo "=========================================="
dbt test --profiles-dir .

cd ..

echo "=========================================="
echo " [4/5] EXECUTANDO SUÍTE DE TESTES E AUDITORIA"
echo "=========================================="
python tests/test_lakehouse_resilience.py
python tests/test_financial_integrity.py
python tests/test_query_benchmark.py

echo "=========================================="
echo " [5/5] CONSULTA ANALÍTICA SOBRE O LAKE    "
echo "=========================================="
python sql/query_lakehouse.py

echo "=========================================="
echo " ESTEIRA LAKEHOUSE CONCLUÍDA COM SUCESSO! "
echo "=========================================="
