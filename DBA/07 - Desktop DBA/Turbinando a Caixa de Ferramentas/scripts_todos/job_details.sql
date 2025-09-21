------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Informações detalhadas sobre um determinado job
-- Compatibilidae: Oracle 10g em diante
-- Ex. @job_details OWNER JOB_NAME
------------------------------------------------------------------------------


COL JOB_DETAILS FORM A200	
SET FEEDBACK OFF
set verify off

prompt ============================================================================================================
prompt == JOB INFORMATION 
prompt ============================================================================================================


SELECT
''||chr(10)|| 
'-- Basico Info:'||chr(10)|| 
'Owner			: '||OWNER||chr(10)|| 
'Job Name		: '||JOB_NAME||chr(10)|| 
'Job Creator		: '||JOB_CREATOR||chr(10)|| 
'Job Type		: '||JOB_TYPE||chr(10)||  
'Start Date		: '||to_char(START_DATE,'DD/MM/RRRR HH24:MI:SS') ||chr(10)|| 
'Enable			: '||ENABLED||chr(10)|| 
'State			: '||STATE||chr(10)|| 
''||chr(10)|| 
'-- Jobs Operaions	:'||chr(10)|| 
'Run Count		: '||RUN_COUNT||chr(10)|| 
'Failure Count		: '||FAILURE_COUNT||chr(10)|| 
'Last Start Date		: '||to_char(LAST_START_DATE,'DD/MM/RRRR HH24:MI:SS')||chr(10)|| 
'Last Run Duration	: '||LAST_RUN_DURATION||chr(10)|| 
'Next Run Date		: '||to_char(NEXT_RUN_DATE,'DD/MM/RRRR HH24:MI:SS')||chr(10)|| 
'Repeat Interval		: '|| REPEAT_INTERVAL||chr(10)|| 
'Comments		: '||COMMENTS  JOB_DETAILS
FROM DBA_SCHEDULER_JOBS
where owner like '%&1%'
and job_name like '%&2%';

SET FEEDBACK ON


prompt ============================================================================================================
prompt == VERIFY IF JOB IS IN RUNNING STATE
prompt ============================================================================================================


col job_name 		form a50
col ELAPSED_TIME 	form a20
col OWNER			form a30

select 
owner, job_name, session_id, running_instance,elapsed_time,cpu_used,log_id
from dba_scheduler_running_jobs
where owner like '%&1%'
and job_name like '%&2%';	


COL RUN_DURATION FORM A20
COL CPU_USED FORM A20
COL ADDITIONAL_INFO FORM A100

prompt ============================================================================================================
prompt == VIEW LAST 10 EXECUTIONS
prompt ============================================================================================================


col additional_info form a80
col status form a20
col log_date form a25
select * 
from (
select 
to_char(log_date,'DD/MM/RRRR HH24:MI:SS') log_date,status, run_duration,instance_id, to_char(cpu_used) CPU_USED, additional_info 
from DBA_SCHEDULER_JOB_RUN_DETAILS
where owner like '%&1%'
and job_name like '%&2%'
order by log_date desc
) 
where rownum <=10;
/*
prompt ============================================================================================================
prompt == JOB DDL	
prompt ============================================================================================================

col JOB_DEF form a300
SET LONG 100000
SELECT DBMS_METADATA.get_ddl('PROCOBJ','&2', '&1') AS job_def FROM    dba_scheduler_jobs
WHERE  owner    = UPPER('&1')
AND    job_name = DECODE(UPPER('&2'), 'ALL', job_name, UPPER('&2'));
*/


set verify on