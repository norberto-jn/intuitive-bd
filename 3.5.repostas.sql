/*
    Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU
    AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?
*/

SELECT 
    f.ans_registration_code,
    hip.socialname AS nome_operadora,
    SUM(f.final_balance_amount - f.initial_balance_amount) AS despesa_total,
    CURRENT_DATE - INTERVAL '3 months' AS data_inicio,
    CURRENT_DATE AS data_fim
FROM 
    intuitivecare.financial_data f
INNER JOIN 
    intuitivecare.health_insurance_providers hip ON f.ans_registration_code = hip.ans_registration_code
WHERE 
    f.description ILIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND f.date BETWEEN CURRENT_DATE - INTERVAL '3 months' AND CURRENT_DATE
GROUP BY 
    f.ans_registration_code, hip.socialname
ORDER BY 
    despesa_total DESC
LIMIT 10;

/*
    Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
*/

SELECT 
    f.ans_registration_code,
    hip.socialname,
    hip.fantasyname,
    SUM(f.final_balance_amount - f.initial_balance_amount) AS despesa_total,
    EXTRACT(YEAR FROM CURRENT_DATE) - 1 AS reference_year
FROM 
    intuitivecare.financial_data f
INNER JOIN 
    intuitivecare.health_insurance_providers hip ON f.ans_registration_code = hip.ans_registration_code
WHERE 
    f.description ILIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND EXTRACT(YEAR FROM f.date) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
GROUP BY 
    f.ans_registration_code, hip.socialname, hip.fantasyname
ORDER BY 
    despesa_total DESC
LIMIT 10;


/*
    ====================================================================================
    ====================================================================================
    ====================================================================================
*/


/*
    Quais são as 10 operadoras com maiores despesas em 'EVENTOS/SINISTROS CONHECIDOS OU
    AVISADOS DE ASSISTÊNCIA À SAÚDE MÉDICO-HOSPITALAR' no último trimestre do último ano?
*/

SELECT 
    f.ans_registration_code,
    hip.socialname,
    SUM(f.final_balance_amount - f.initial_balance_amount) AS total_expense,
    DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year' + INTERVAL '9 months' AS begin_date,
    DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 day' AS end_date
FROM 
    intuitivecare.financial_data f
INNER JOIN 
    intuitivecare.health_insurance_providers hip ON f.ans_registration_code = hip.ans_registration_code
WHERE 
    f.description ILIKE '%EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR%'
    AND f.date BETWEEN 
        (DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year' + INTERVAL '9 months') -- 1º de outubro do ano anterior
        AND 
        (DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 day') -- 31 de dezembro do ano anterior
GROUP BY 
    f.ans_registration_code, hip.socialname
ORDER BY 
    total_expense DESC
LIMIT 10;