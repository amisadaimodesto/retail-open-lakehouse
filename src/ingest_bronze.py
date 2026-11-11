import os
from datetime import datetime, timezone
import pandas as pd
from faker import Faker

fake = Faker("pt_BR")
Faker.seed(42)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BRONZE_PATH = os.path.join(BASE_DIR, "data_lake", "bronze")
os.makedirs(BRONZE_PATH, exist_ok=True)

def generate_lojas(n=20) -> pd.DataFrame:
    cidades = [
        ("São Paulo", "SP", "Sudeste"),
        ("Rio de Janeiro", "RJ", "Sudeste"),
        ("Belo Horizonte", "MG", "Sudeste"),
        ("Curitiba", "PR", "Sul"),
        ("Porto Alegre", "RS", "Sul"),
        ("Salvador", "BA", "Nordeste"),
        ("Recife", "PE", "Nordeste"),
        ("Brasília", "DF", "Centro-Oeste"),
        ("Goiânia", "GO", "Centro-Oeste"),
        ("Manaus", "AM", "Norte"),
    ]
    lojas = []
    for i in range(1, n + 1):
        cidade, uf, regiao = cidades[(i - 1) % len(cidades)]
        lojas.append({
            "id_loja": i,
            "nome_loja": f"Loja {cidade} {i}",
            "cidade": cidade,
            "uf": uf,
            "regiao": regiao,
            "data_abertura": fake.date_between(start_date="-5y", end_date="-1y").isoformat()
        })
    return pd.DataFrame(lojas)

def generate_produtos(n=30) -> pd.DataFrame:
    categorias = ["Eletrônicos", "Vestuário", "Alimentos", "Móveis", "Livros", "Esportes"]
    produtos = []
    for i in range(1, n + 1):
        cat = categorias[(i - 1) % len(categorias)]
        custo = round(fake.random.uniform(15.0, 450.0), 2)
        preco = round(custo * fake.random.uniform(1.3, 2.2), 2)
        produtos.append({
            "id_produto": i,
            "nome_produto": f"Produto {cat} Modelo {i}",
            "categoria": cat,
            "preco_unitario": preco,
            "custo_unitario": custo
        })
    return pd.DataFrame(produtos)

def generate_clientes(n=300) -> pd.DataFrame:
    clientes = []
    for i in range(1, n + 1):
        clientes.append({
            "id_cliente": i,
            "nome_cliente": fake.name(),
            "email": fake.unique.email(),
            "telefone": fake.phone_number(),
            "data_cadastro": fake.date_between(start_date="-3y", end_date="today").isoformat()
        })
    return pd.DataFrame(clientes)

def generate_vendas(n=5000, n_clientes=300, n_lojas=20, n_produtos=30) -> pd.DataFrame:
    vendas = []
    status_list = ["APROVADO", "CANCELADO"]
    for i in range(1, n + 1):
        qtd = fake.random_int(min=1, max=5)
        desconto = round(fake.random.uniform(0.0, 0.15), 2) if fake.boolean(chance_of_getting_true=25) else 0.0
        vendas.append({
            "id_venda": i,
            "id_cliente": fake.random_int(min=1, max=n_clientes),
            "id_loja": fake.random_int(min=1, max=n_lojas),
            "id_produto": fake.random_int(min=1, max=n_produtos),
            "quantidade": qtd,
            "desconto_percentual": desconto,
            "status_pagamento": fake.random_element(elements=status_list),
            "data_venda": fake.date_time_between(start_date="-2y", end_date="now").isoformat()
        })
    
    df_vendas = pd.DataFrame(vendas)
    duplicados = df_vendas.sample(n=50, random_state=42)
    return pd.concat([df_vendas, duplicados], ignore_index=True)

def run():
    now_utc = datetime.now(timezone.utc).isoformat()
    print("--- [LAKEHOUSE] REGERANDO CAMADA BRONZE COM INTEGRIDADE ---")
    
    df_lojas = generate_lojas(n=20)
    df_prods = generate_produtos(n=30)
    df_clis = generate_clientes(n=300)
    df_vendas = generate_vendas(n=5000, n_clientes=len(df_clis), n_lojas=len(df_lojas), n_produtos=len(df_prods))
    
    datasets = {
        "lojas": df_lojas,
        "produtos": df_prods,
        "clientes": df_clis,
        "vendas": df_vendas
    }
    
    for name, df in datasets.items():
        df["_ingested_at"] = now_utc
        file_path = os.path.join(BRONZE_PATH, f"{name}.parquet")
        df.to_parquet(file_path, index=False, engine="pyarrow", compression="snappy")
        print(f"✔ Gravado: {file_path} ({len(df)} registros)")
        
    print("--- [LAKEHOUSE] REGERAÇÃO BRONZE CONCLUÍDA ---")

if __name__ == "__main__":
    run()
