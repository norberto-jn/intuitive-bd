UPDATE intuitivecare.financial_data
SET 
    vl_saldo_inicial = REPLACE(vl_saldo_inicial, ',', '.')::NUMERIC,
    vl_saldo_final = REPLACE(vl_saldo_final, ',', '.')::NUMERIC;


ALTER TABLE intuitivecare.financial_data ALTER COLUMN vl_saldo_inicial TYPE numeric USING vl_saldo_inicial::numeric;
ALTER TABLE intuitivecare.financial_data ALTER COLUMN vl_saldo_final TYPE numeric USING vl_saldo_final::numeric;
