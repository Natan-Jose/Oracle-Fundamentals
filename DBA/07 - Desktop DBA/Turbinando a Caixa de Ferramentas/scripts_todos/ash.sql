------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Average Active Sessions 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @aas 5 | agrupa as informacoes de espera dos ultimos 5 minutos
------------------------------------------------------------------------------


col wait_class form a30
col event form a30
col SQL_ID form a30
col username form a30

prompt ======================================================
prompt == Top 5 Wait Class in last &1 minutes
prompt ======================================================

set verify off
SELECT NVL(a.wait_class, 'ON CPU') AS wait_class,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM   v$active_session_history a
WHERE  a.sample_time > SYSDATE - &1/(24*60)
GROUP BY a.wait_class
ORDER BY total_wait_time DESC
fetch first 5 rows only ;


prompt ======================================================
prompt == Top 5 Events in last &1 minutes
prompt ======================================================
SELECT NVL(a.event, 'ON CPU') AS event,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM   v$active_session_history a
WHERE  a.sample_time > SYSDATE - &1/(24*60)
GROUP BY a.event
ORDER BY total_wait_time DESC
fetch first 5 rows only ;


prompt ======================================================
prompt == Top 5 username in last &1 minutes
prompt ======================================================
SELECT NVL(u.username, 'ON CPU') AS username,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM   gv$active_session_history a
      , dba_users u
WHERE a.user_id = u.user_id (+)
and a.sample_time > SYSDATE - 5/(24*60)
GROUP BY u.username
ORDER BY total_wait_time DESC
fetch first 5 rows only ;


prompt ======================================================
prompt == Top 5 SQL_ID in last &1 minutes
prompt ======================================================
SELECT SQL_ID,
       COUNT(*) AS total_wait_time,LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
FROM   v$active_session_history a
WHERE  a.sample_time > SYSDATE - &1/(24*60)
GROUP BY SQL_ID
ORDER BY total_wait_time DESC
fetch first 5 rows only ;