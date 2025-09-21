------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe as tasks criadas pelo ADDM
-- Compatibilidae: Oracle 10g em diante
-- Ex. @addm 30 | mostras as tasks dos ultimos 30 minutos 
------------------------------------------------------------------------------


set verify off
col task_name form a40
col begin_time form a17
col end_time form a17
col status form a10
col owner form a15
SELECT
    t.owner,
    t.task_id,
    t.task_name,
    t.created,
    f.db_time_secons,
    f.aas,
    t.status,
    t.recommendation_count,
    begin_snap_id,
    end_snap_id,
    to_char(begin_time, 'DD/MM/RRRR HH24:MI') begin_time,
    to_char(end_time, 'DD/MM/RRRR HH24:MI')   end_time
FROM
    dba_addm_tasks t,
    (
        SELECT
            task_id,
            round(SUM(active_sessions),
                  1) aas,
            round(SUM(database_time / 1000000),
                  1) AS db_time_secons
        FROM 
            dba_addm_findings
        GROUP BY
            task_id
    )              f
WHERE
        t.task_id = f.task_id
    AND t.created > sysdate - &1 / ( 24 * 60 )
ORDER BY
    t.created;