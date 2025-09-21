------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Gera um report do ADDM 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @addm_report
------------------------------------------------------------------------------


col HOST_NAME form a50
set pages 80

prompt ============================================================================
prompt == ADDM Report
prompt ============================================================================

select INST_ID, INSTANCE_NUMBER, INSTANCE_NAME, HOST_NAME from gv$instance;
accept v_inst_list char prompt 'Put the Instance Number (ex. 1,2,3)  : '


accept v_snp char prompt 'Filter Snap_id by hour: '

COL BEGIN_INTERVAL_TIME FORM A30


SELECT
    s.snap_id,
    to_char(begin_interval_time, 'DD/MM/RRRR HH24:MI') begin_interval_time,
    to_char(end_interval_time, 'DD/MM/RRRR HH24:MI')   end_interval_time,
    a.totalseconds,
    a.aas
FROM
    dba_hist_snapshot s,
    (
        SELECT
            snap_id,
            COUNT(*) totalseconds,
            round(COUNT(*) / nullif(CAST(MAX(sample_time) AS DATE) - CAST(MIN(sample_time) AS DATE),
                                    0) / 86400,
                  1) aas
        FROM
            dba_hist_active_sess_history
        GROUP BY
            snap_id
    )                 a
WHERE
    a.snap_id (+) = s.snap_id
AND
    end_interval_time > sysdate - &v_snp / 24
ORDER BY
    snap_id;

accept v_snp_begin char prompt 'Enter Begin SNAP_ID: '
accept v_snp_end char prompt 'Enter End SNAP_ID: '



set feedback off


column task_name new_value v_task_name
select 'manual_addm_'||&v_snp_begin||'_'||&v_snp_end task_name from dual;



DECLARE
  l_task_name VARCHAR2(30) := '&v_task_name';
BEGIN
  DBMS_ADDM.analyze_inst (
    task_name       => l_task_name,
    begin_snapshot  => &v_snp_begin,
    end_snapshot    => &v_snp_end,
    instance_number => '&v_inst_list');
END;
/


SET LONG 1000000 LONGCHUNKSIZE 1000000
SET LINESIZE 1000 PAGESIZE 0
SET TRIM ON TRIMSPOOL ON
SET ECHO OFF FEEDBACK OFF
SELECT DBMS_ADDM.get_report('&v_task_name') FROM dual;

set feedback on

prompt For delete ADDM Report
prompt exec DBMS_ADDM.delete('&v_task_name');


set feedback on
set pagesize 80