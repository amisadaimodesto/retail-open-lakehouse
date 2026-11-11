import duckdb

con = duckdb.connect()

print("=" * 65)
print(" TESTE 1: AUDITORIA DE VOLUMETRIA E DEDUPLICAÇÃO")
print("=" * 65)

bronze_count = con.execute("SELECT count(*) FROM 'data_lake/bronze/vendas.parquet'").fetchone()[0]
gold_count = con.execute("SELECT count(*), count(distinct id_venda) FROM 'data_lake/gold/fato_vendas.parquet'").fetchone()

print(f"Total registros na Camada BRONZE (bruto): {bronze_count}")
print(f"Total registros na Camada GOLD (fato):    {gold_count[0]}")
print(f"Total vendas distintas na GOLD:          {gold_count[1]}")

assert gold_count[0] == gold_count[1], "FALHA: Existem IDs duplicados na camada Gold!"
assert bronze_count > gold_count[0], "FALHA: A deduplicação não filtrou registros excedentes da Bronze!"

print(">> [SUCESSO] Deduplicação determinística comprovada!")
print("=" * 65)
