------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Average Active Sessions 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @aas3 | @ash3 event "sql_id='c13sma6rkr27c'" 15 | mostra os eventos de espera dos ultimos 15 minutos para o sql_id c13sma6rkr27c
------------------------------------------------------------------------------

col FIRST form a20
col LAST form a20

set verify off
SELECT to_char(MIN(sample_time),'DD/MM/RRRR HH24:MI') FIRST, to_char(max(sample_time),'DD/MM/RRRR HH24:MI') last, NVL(a.&1, 'ON CPU') AS &1,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM    (select * from gv$active_session_history a, dba_users u where a.user_id = u.user_id (+)) a
WHERE &2
AND  a.sample_time > SYSDATE - &3/(24*60)
GROUP BY a.&1
ORDER BY total_wait_time DESC
fetch first 5 rows only ;

