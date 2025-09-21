------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Average Active Sessions 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @ash2
------------------------------------------------------------------------------


prompt Good Options    USERNAME,MACHINE, SQL_ID,SESSION_ID, SESSION_SERIAL#, INST_ID, SESSION_TYPE, SQL_OPNAME, EVENT, WAIT_CLASS, PROGRAM, MODULE, ACTION, MACHINE

accept v_cname char prompt 'Enter Column Name: '
accept v_min char prompt 'Enter Period Time (max 60): '

col v_cname form a40
col FIRST form a20
col LAST form a20

set verify off
SELECT to_char(MIN(sample_time),'DD/MM/RRRR HH24:MI') FIRST, to_char(max(sample_time),'DD/MM/RRRR HH24:MI') last, NVL(a.&v_cname, 'ON CPU') AS &v_cname,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM    (select * from gv$active_session_history a, dba_users u where a.user_id = u.user_id (+)) a
WHERE  a.sample_time > SYSDATE - &v_min/(24*60)
GROUP BY a.&v_cname
ORDER BY total_wait_time DESC
fetch first 5 rows only ;
