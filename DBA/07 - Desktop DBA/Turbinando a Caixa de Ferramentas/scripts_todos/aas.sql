------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre a metrica Average Active Session. 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @aas 5 (Exibe o aas dos ultimos 5 minutos)
------------------------------------------------------------------------------


SELECT
    begin_time,
    round(value, 2) aas
FROM
    gv$sysmetric_history
WHERE
        metric_name = 'Average Active Sessions'
    AND group_id = 2
    AND  begin_time > SYSDATE - &1/(24*60)
ORDER BY
    begin_time;
