COPY intuitivecare.health_insurance_providers (
    registro_ans,
    cnpj,
    razao_social,
    nome_fantasia,
    modalidade,
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    uf,
    cep,
    ddd,
    telefone,
    fax,
    endereco_eletronico,
    representante,
    cargo_representante,
    regiao_de_comercializacao,
    data_registro_ans
)
FROM '/var/lib/dados_demonstracoes_contabeis/relatorio_cadop/Relatorio_cadop.csv'
DELIMITER ';'
CSV HEADER;
