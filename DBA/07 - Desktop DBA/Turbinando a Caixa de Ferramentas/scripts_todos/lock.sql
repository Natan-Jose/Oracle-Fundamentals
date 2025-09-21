------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Lista os bloqueios do banco
-- Compatibilidae: Oracle 8i em diante
-- Ex. @lock
------------------------------------------------------------------------------

col inst_id form 9
col level form 9
col username form a20
col osuser form a20
col module form a20
col serial# form 999999
col sid form 999999
col machine form a25
col event form a30
col status form a20
col sql_id form a15
col program form a25
col "Tempo de Conexao" form a20
col logon_time form a25
col object_owner form a20
col object_name form a20
col kill form a55
col locked_mode form a20

SELECT s.inst_id,level,
       s.osuser,
       LPAD(' ', (level-1)*2, ' ') || NVL(s.username, '(oracle)') AS username,
       s.sid,
       s.serial#,
       s.status,
       s.seconds_in_wait,
       s.sql_id,
       event,
       o.object_name,
       Decode(lo.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             lo.locked_mode) locked_mode,
    s.blocking_session,
    s.blocking_session_status,
       substr(s.machine,1,25) machine,
       substr(s.program,1,25) program,
    --   s.module,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
 /* FLOOR (ROUND ( ( (sysdate - logon_time ) * 1440), 2) / 60 )
         || 'h'
         || TRUNC (MOD (ROUND ( ( (sysdate - logon_time ) * 1440), 2), 60))
         || 'min' "Tempo de Conexao",*/
--'alter system kill session ''' || s.sid || ',' || s.serial# || ',@' || s.inst_id || ''' immediate;' kill
FROM   gv$locked_object lo
       JOIN dba_objects o ON o.object_id = lo.object_id
       JOIN gv$session s ON lo.session_id = s.sid
WHERE  level > 1
OR     EXISTS (SELECT 1
               FROM   gv$session
               WHERE  blocking_session = s.sid)
CONNECT BY PRIOR s.sid = s.blocking_session
START WITH s.blocking_session IS NULL;