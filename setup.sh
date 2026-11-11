#!/usr/bin/env bash
set -e

echo "=========================================="
echo "   CONFIGURANDO AMBIENTE DO LAKEHOUSE     "
echo "=========================================="

command -v python3 >/dev/null 2>&1 || { echo "Erro: python3 não está instalado."; exit 1; }

if [ ! -d ".venv" ]; then
    echo "==> Criando ambiente virtual Python (.venv)..."
    python3 -m venv .venv
fi

source .venv/bin/activate
echo "==> Instalando dependências (DuckDB, PyArrow, dbt-duckdb)..."
pip install --upgrade pip
pip install -r requirements.txt

mkdir -p data_lake/bronze data_lake/silver data_lake/gold

echo "=========================================="
echo " AMBIENTE LAKEHOUSE PRONTO COM SUCESSO!   "
echo " Execute: ./run_pipeline.sh               "
echo "=========================================="
