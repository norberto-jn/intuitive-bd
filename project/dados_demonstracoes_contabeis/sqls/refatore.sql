set schema 'intuitivecare';

UPDATE intuitivecare.financial_data
SET 
    vl_saldo_inicial = REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
    vl_saldo_final = REPLACE(vl_saldo_final, ',', '.')::NUMERIC;


ALTER TABLE intuitivecare.financial_data ALTER COLUMN vl_saldo_inicial TYPE numeric USING vl_saldo_inicial::numeric;
ALTER TABLE intuitivecare.financial_data ALTER COLUMN vl_saldo_final TYPE numeric USING vl_saldo_final::numeric;

INSERT INTO intuitivecare.address (
    road, 
    "number", 
    complement, 
    neighborhood, 
    city, 
    state, 
    zip_code, 
    ans_registration
)
SELECT 
    logradouro,
    numero,
    complemento,
    bairro,
    cidade,
    uf,
    cep,
    registro_ans
FROM 
    intuitivecare.health_insurance_providers
WHERE 
    logradouro IS NOT NULL;


ALTER TABLE intuitivecare.health_insurance_providers ADD COLUMN address_code INTEGER NULL;


update
	intuitivecare.health_insurance_providers hip
set
	address_code = a.code
from
	address a
where
	hip.registro_ans = a.ans_registration
	and a.ans_registration is not null;


ALTER TABLE intuitivecare.health_insurance_providers ALTER COLUMN address_code SET NOT NULL;

ALTER TABLE intuitivecare.health_insurance_providers ADD CONSTRAINT fk_address FOREIGN KEY (address_code) REFERENCES address(code);

ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN logradouro;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN numero;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN complemento;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN bairro;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN cidade;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN uf;
ALTER TABLE intuitivecare.health_insurance_providers DROP COLUMN cep;

ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN razao_social TO socialname;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN nome_fantasia TO fantasyname;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN modalidade TO modality;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN ddd TO area_code;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN telefone TO phone;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN endereco_eletronico TO email;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN representante TO representative;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN cargo_representante TO representative_position;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN regiao_de_comercializacao TO commercialization_region;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN data_registro_ans TO ans_registration_date;
ALTER TABLE intuitivecare.health_insurance_providers RENAME COLUMN registro_ans TO ans_registration_code;


ALTER TABLE intuitivecare.address DROP CONSTRAINT address_ans_registration_key;
ALTER TABLE intuitivecare.address DROP COLUMN ans_registration;


ALTER TABLE intuitivecare.financial_data RENAME COLUMN descricao TO description;
ALTER TABLE intuitivecare.financial_data RENAME COLUMN vl_saldo_inicial TO initial_balance_amount;
ALTER TABLE intuitivecare.financial_data RENAME COLUMN vl_saldo_final TO final_balance_amount;
ALTER TABLE intuitivecare.financial_data RENAME COLUMN cd_conta_contabil TO accounting_account_code;
ALTER TABLE intuitivecare.financial_data RENAME COLUMN reg_ans TO ans_registration_code;
ALTER TABLE intuitivecare.financial_data RENAME COLUMN data TO date;