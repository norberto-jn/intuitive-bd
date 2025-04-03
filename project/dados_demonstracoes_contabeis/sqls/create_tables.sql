-- Create schema if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.schemata 
        WHERE schema_name = 'intuitivecare'
    ) THEN
        CREATE SCHEMA intuitivecare AUTHORIZATION postgres;
    END IF;
END
$$;

-- Set schema
SET search_path TO intuitivecare;

-- Create table if not exists
CREATE TABLE IF NOT EXISTS financial_data (
    DATA DATE,
    REG_ANS VARCHAR(50),
    CD_CONTA_CONTABIL VARCHAR(50),
    DESCRICAO VARCHAR(255),
    VL_SALDO_INICIAL VARCHAR(255),
    VL_SALDO_FINAL VARCHAR(255)
);


CREATE TABLE intuitivecare.health_insurance_providers (
    registro_ans varchar(6) NOT NULL,
    cnpj varchar(14) NOT NULL,
    razao_social varchar(140) NOT NULL,
    nome_fantasia varchar(100) NULL,
    modalidade varchar(50) NULL,
    logradouro varchar(40) NULL,
    numero varchar(15) NULL,
    complemento varchar(40) NULL,
    bairro varchar(30) NULL,
    cidade varchar(30) NULL,
    uf bpchar(2) NULL,
    cep varchar(8) NULL,
    ddd bpchar(2) NULL,
    telefone varchar(18) NULL,
    fax varchar(15) NULL,
    endereco_eletronico varchar(50) NULL,
    representante varchar(50) NULL,
    cargo_representante varchar(100) NULL,
    regiao_de_comercializacao varchar(1) NULL,
    data_registro_ans date NULL,
    CONSTRAINT health_insurance_providers_pkey PRIMARY KEY (registro_ans)
);