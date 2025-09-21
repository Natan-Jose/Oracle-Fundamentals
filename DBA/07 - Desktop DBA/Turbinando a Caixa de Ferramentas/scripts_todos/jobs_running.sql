------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostra os jobs em execução no momento
-- Compatibilidae: Oracle 10g em diante
-- Ex. @jobs_running
------------------------------------------------------------------------------

col job_name 		form a50
col ELAPSED_TIME 	form a20
col OWNER			form a35
col cpu_used 		form a30
select 
owner, job_name, session_id, running_instance,elapsed_time,cpu_used,log_id
from dba_scheduler_running_jobs;