import os
import requests
import zipfile
from bs4 import BeautifulSoup
from urllib.parse import urljoin
import datetime
from typing import List

# Classe para lidar com operações de download e descompactação
class Downloader:
    def __init__(self, url: str, pasta_destino: str):
        self.url = url
        self.pasta_destino = pasta_destino

    def baixar_e_descompactar(self):
        resposta = requests.get(self.url)
        if resposta.status_code != 200:
            print(f"Erro ao acessar a URL: {self.url}")
            return

        soup = BeautifulSoup(resposta.text, 'html.parser')
        for link in soup.find_all('a', href=True):
            href = link['href']
            if href.endswith('.zip'):
                self._baixar_arquivo_zip(href)

    def _baixar_arquivo_zip(self, href: str):
        arquivo_url = urljoin(self.url, href)
        nome_arquivo_zip = os.path.join(self.pasta_destino, href.split('/')[-1])

        print(f"Baixando {nome_arquivo_zip}...")
        resposta_arquivo = requests.get(arquivo_url, stream=True)

        if resposta_arquivo.status_code == 200:
            with open(nome_arquivo_zip, 'wb') as f:
                for chunk in resposta_arquivo.iter_content(chunk_size=8192):
                    f.write(chunk)
            print(f"{nome_arquivo_zip} baixado com sucesso!")

            self._descompactar_arquivo(nome_arquivo_zip)
        else:
            print(f"Erro ao baixar o arquivo {arquivo_url}")

    def _descompactar_arquivo(self, nome_arquivo_zip: str):
        with zipfile.ZipFile(nome_arquivo_zip, 'r') as zip_ref:
            print(f"Descompactando {nome_arquivo_zip}...")
            zip_ref.extractall(self.pasta_destino)
        print(f"{nome_arquivo_zip} descompactado com sucesso!")
        os.remove(nome_arquivo_zip)
        print(f"{nome_arquivo_zip} removido após descompactação.")

# Classe para gerar comandos SQL a partir dos arquivos CSV
class SqlGenerator:
    def __init__(self, pasta_base: str):
        self.pasta_base = pasta_base

    def gerar_comando_sql(self):
        arquivo_sql = os.path.join(self.pasta_base, "sqls/main_insert.sql")
        os.makedirs(os.path.dirname(arquivo_sql), exist_ok=True)

        with open(arquivo_sql, 'w') as f:
            for root, dirs, files in os.walk(self.pasta_base):
                for file in files:
                    if file.endswith('.csv'):
                        self._processar_arquivo_csv(f, root, file)

        print(f"Arquivo SQL gerado com sucesso: {arquivo_sql}")

    def _processar_arquivo_csv(self, f, root: str, file: str):
        caminho_arquivo_csv = f"/var/lib/{os.path.join(root, file)}"
        nome_arquivo = os.path.splitext(file)[0]
        ano_trimestre = nome_arquivo[-7:]
        ano = ano_trimestre[-4:]
        trimestre = ano_trimestre[:1]

        comando_sql = (
            f"SET SCHEMA 'intuitivecare';COPY financial_data (DATA, REG_ANS, CD_CONTA_CONTABIL, "
            f"DESCRICAO, VL_SALDO_INICIAL, VL_SALDO_FINAL) FROM '{caminho_arquivo_csv}' "
            f"DELIMITER ';' CSV HEADER;\n"
        )
        f.write(comando_sql)

# Classe para baixar o relatório CADOP
class CadopReporter:
    def __init__(self, url: str, pasta_destino: str):
        self.url = url
        self.pasta_destino = pasta_destino
        self.caminho_arquivo = os.path.join(pasta_destino, "Relatorio_cadop.csv")

    def baixar_relatorio(self):
        os.makedirs(self.pasta_destino, exist_ok=True)

        print(f"Baixando {self.url}...")
        try:
            resposta = requests.get(self.url, stream=True)
            resposta.raise_for_status()

            with open(self.caminho_arquivo, 'wb') as arquivo:
                for chunk in resposta.iter_content(chunk_size=8192):
                    arquivo.write(chunk)

            print(f"Arquivo salvo em: {os.path.abspath(self.caminho_arquivo)}")
        except Exception as e:
            print(f"Erro ao baixar o arquivo: {e}")

# Função para obter os anos para download
def obter_anos_para_download() -> List[int]:
    ano_atual = datetime.datetime.now().year
    return [ano_atual - 1, ano_atual - 2]

def main():
    anos = obter_anos_para_download()
    pasta_base = 'dados_demonstracoes_contabeis'

    for ano in anos:
        url = f'https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/{ano}/'
        pasta_destino = os.path.join(pasta_base, str(ano))
        downloader = Downloader(url, pasta_destino)
        print(f'Iniciando download e descompactação para o ano de {ano}...')
        downloader.baixar_e_descompactar()

    sql_generator = SqlGenerator(pasta_base)
    sql_generator.gerar_comando_sql()

    cadop_url = "https://dadosabertos.ans.gov.br/FTP/PDA/operadoras_de_plano_de_saude_ativas/Relatorio_cadop.csv"
    cadop_pasta_destino = os.path.join(pasta_base, "relatorio_cadop")
    cadop_reporter = CadopReporter(cadop_url, cadop_pasta_destino)
    cadop_reporter.baixar_relatorio()

if __name__ == '__main__':
    main()