import duckdb

con = duckdb.connect()

print("\n" + "=" * 65)
print(" TESTE 2: RECONCILIAÇÃO CONTÁBIL ENTRE FATO E DATAMART")
print("=" * 65)

q_fato = """
SELECT 
    ROUND(SUM(valor_liquido), 2) AS receita_fato,
    ROUND(SUM(lucro_bruto), 2) AS lucro_fato
FROM 'data_lake/gold/fato_vendas.parquet'
WHERE status_pagamento = 'APROVADO';
"""

q_mart = """
SELECT 
    ROUND(SUM(receita_liquida_total), 2) AS receita_mart,
    ROUND(SUM(lucro_bruto_total), 2) AS lucro_mart
FROM 'data_lake/gold/dm_vendas_mensal_categoria.parquet';
"""

fato_res = con.execute(q_fato).fetchone()
mart_res = con.execute(q_mart).fetchone()

print(f"Fato Vendas -> Receita Líquida: R$ {fato_res[0]:,.2f} | Lucro: R$ {fato_res[1]:,.2f}")
print(f"Datamart    -> Receita Líquida: R$ {mart_res[0]:,.2f} | Lucro: R$ {mart_res[1]:,.2f}")

diff_receita = abs(fato_res[0] - mart_res[0])
diff_lucro = abs(fato_res[1] - mart_res[1])

assert diff_receita < 0.05, f"Divergência na receita: {diff_receita}"
assert diff_lucro < 0.05, f"Divergência no lucro: {diff_lucro}"

print(">> [SUCESSO] Reconciliação aprovada! Zero divergência de centavos.")
print("=" * 65 + "\n")
