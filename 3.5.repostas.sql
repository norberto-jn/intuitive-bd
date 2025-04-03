/*
    Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU
    AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?
*/

SELECT 
    f.reg_ans,
    hip.razao_social AS nome_operadora,
    SUM(f.vl_saldo_final - f.vl_saldo_inicial) AS despesa_total,
    CURRENT_DATE - INTERVAL '3 months' AS data_inicio,
    CURRENT_DATE AS data_fim
FROM 
    financial_data f
LEFT JOIN 
    intuitivecare.health_insurance_providers hip ON f.reg_ans = hip.registro_ans
WHERE 
    f.descricao ILIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND f.data BETWEEN CURRENT_DATE - INTERVAL '3 months' AND CURRENT_DATE
GROUP BY 
    f.reg_ans, hip.razao_social
ORDER BY 
    despesa_total DESC
LIMIT 10;

/*
    Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
*/

SELECT 
    f.reg_ans,
    hip.razao_social AS nome_operadora,
    hip.nome_fantasia,
    SUM(f.vl_saldo_final - f.vl_saldo_inicial) AS despesa_total,
    EXTRACT(YEAR FROM CURRENT_DATE) - 1 AS ano_referencia
FROM 
    financial_data f
LEFT JOIN 
    intuitivecare.health_insurance_providers hip ON f.reg_ans = hip.registro_ans
WHERE 
    f.descricao ILIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND EXTRACT(YEAR FROM f.data) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
GROUP BY 
    f.reg_ans, hip.razao_social, hip.nome_fantasia
ORDER BY 
    despesa_total DESC
LIMIT 10;