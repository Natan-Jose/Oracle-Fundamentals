------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: exibe detalhes de uma task 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @addm_detail task_id | mostras os detalhes de uma task_id especifica
------------------------------------------------------------------------------


set verify off
col "Task Info" form a65
prompt =====================================================================
prompt == Task Info
prompt =====================================================================
select
'Task ID.........................: '||t.task_id||chr(10)||   
'Task Name.......................: '||t.task_name||chr(10)||
'status..........................: '||t.status||chr(10)||
'Recommendation Count............: '||t.recommendation_count||chr(10)||
'Begin Snap Id...................: '||t.begin_snap_id||chr(10)||
'End Snap Id.....................: '||t.end_snap_id||chr(10)||
'begin_time......................: '||t.begin_time||chr(10)||
'end_time........................: '||t.end_time as "Task Info"
FROM DBA_ADDM_TASKS t
where t.task_id = &1;

prompt =====================================================================
prompt == Findings
prompt =====================================================================
col Findings form a200

select
'Finding ID...........................: '||f.finding_id||chr(10)||   
'Finding Name.........................: '||f.finding_name||chr(10)||   
'Type.................................: '||f.type||chr(10)||   
'Message..............................: '||f.message||chr(10)||   
'More Info............................: '||f.more_info||chr(10)||   
'Database Time (sec)..................: '||round(f.database_time / 1000000)||chr(10)||   
'Active Sessions......................: '||f.active_sessions||chr(10)||   
'Active Sessions %....................: '||f.perc_active_sess as Findings
from dba_addm_findings f
where TASK_ID = &1
order by perc_active_sess;


