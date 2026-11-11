import duckdb

con = duckdb.connect()

print("\n" + "=" * 70)
print("  CONSULTA ANALÍTICA DIRETA SOBRE OS ARQUIVOS PARQUET (CAMADA GOLD)")
print("=" * 70)

query = """
SELECT 
    categoria,
    SUM(total_pedidos) AS total_pedidos,
    SUM(total_itens_vendidos) AS itens_vendidos,
    ROUND(SUM(receita_liquida_total), 2) AS receita_total_rs,
    ROUND(SUM(lucro_bruto_total), 2) AS lucro_total_rs,
    ROUND((SUM(lucro_bruto_total) / SUM(receita_liquida_total)) * 100, 2) AS margem_percentual
FROM 'data_lake/gold/dm_vendas_mensal_categoria.parquet'
GROUP BY categoria
ORDER BY receita_total_rs DESC;
"""

df = con.execute(query).df()
print(df.to_string(index=False))
print("=" * 70 + "\n")
