import duckdb
import time

con = duckdb.connect()

print("=" * 65)
print(" TESTE 3: BENCHMARK ANALÍTICO (PARTITION PRUNING SOBRE PARQUET)")
print("=" * 65)

start_time = time.time()

query = """
SELECT 
    c.uf,
    p.categoria,
    COUNT(f.sk_venda) AS total_pedidos,
    ROUND(SUM(f.valor_liquido), 2) AS receita_total,
    ROUND(AVG(f.valor_liquido), 2) AS ticket_medio
FROM 'data_lake/gold/fato_vendas/**/*.parquet' f
JOIN 'data_lake/gold/dim_lojas.parquet' c ON f.sk_loja = c.sk_loja
JOIN 'data_lake/gold/dim_produtos.parquet' p ON f.sk_produto = p.sk_produto
WHERE f.ano_venda = 2026
GROUP BY c.uf, p.categoria
ORDER BY receita_total DESC
LIMIT 5;
"""

df = con.execute(query).df()
elapsed = (time.time() - start_time) * 1000

print(df.to_string(index=False))
print(f"\nTempo de execução com pruning de partição: {elapsed:.2f} ms")
print("=" * 65)
