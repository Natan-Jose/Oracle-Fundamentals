------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Informações sobre os jobs do banco
-- Compatibilidae: Oracle 10g em diante
-- Ex. @jobs 1=1 (todos os jobs) | jobs owner='SYS' Jobs do owner SYS
------------------------------------------------------------------------------


col job_name 			form a30
col ELAPSED_TIME 		form a20
col OWNER			form a15
col START_DATE		form a18
col LAST_START_DATE		form a18
col NEXT_RUN_DATE		form a18
col duration			form a10
col REPEAT_INTERVAL		form a75
col JOB_TYPE			form a25
col ENABLED 			form a10

set verify off
SELECT
    owner,
    job_name,
    job_type,
    to_char(start_date, 'DD/MM/RR HH24:MI:SS')      start_date,
    enabled,
--	STATE,
    run_count,
    failure_count,
    to_char(last_start_date, 'DD/MM/RR HH24:MI:SS') last_start_date,
    lpad(EXTRACT(HOUR FROM last_run_duration),2,'0')|| ':'|| 
    lpad(EXTRACT(MINUTE FROM last_run_duration),2,'0')|| ':'|| 
    lpad(round(EXTRACT(SECOND FROM last_run_duration)),2,'0')                                             AS duration
---	to_char(NEXT_RUN_DATE,	'DD/MM/RRRR HH24:MI:SS') NEXT_RUN_DATE
	--substr(REPEAT_INTERVAL,	1,	50) REPEAT_INTERVAL
	--substr(COMMENTS,	1,	50) COMMENTS
FROM
    dba_scheduler_jobs
	WHERE &1
    order by owner, job_name, last_start_date;

