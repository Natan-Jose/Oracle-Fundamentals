------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras as sessoes de forma detalhada
-- Compatibilidae: Oracle 10g em diante
-- Ex. @s 465 2338
------------------------------------------------------------------------------


prompt 
prompt 
prompt =========================================================================
Prompt == Session Details for Sid: &1 Serial#:&2
prompt =========================================================================
prompt 


set verify off
col "Session Details" form a100
select 
'Sid................................: '||s.SID||chr(10)||               
'Serial#............................: '||s.SERIAL#||chr(10)||               
'Username...........................: '||s.USERNAME||chr(10)||                
'Lockwait...........................: '||s.LOCKWAIT||chr(10)||                
'Status.............................: '||s.STATUS||chr(10)||                
'Schemaname.........................: '||s.SCHEMANAME||chr(10)||                
'Osuser.............................: '||s.OSUSER||chr(10)||                
'Process............................: '||s.PROCESS||chr(10)||               
'Machine............................: '||s.MACHINE||chr(10)||               
'Program............................: '||s.PROGRAM||chr(10)||               
'Type...............................: '||s.TYPE||chr(10)||                
'Sql_hash_value.....................: '||s.SQL_HASH_VALUE||chr(10)||                
'Sql_id.............................: '||s.SQL_ID||chr(10)||                
'Sql_exec_start.....................: '||s.SQL_EXEC_START||chr(10)||                
'Prev_sql_id........................: '||s.PREV_SQL_ID||chr(10)||               
'Prev_exec_start....................: '||s.PREV_EXEC_START||chr(10)||               
'Module.............................: '||s.MODULE||chr(10)||                
'Action.............................: '||s.ACTION||chr(10)||                
'Client_info........................: '||s.CLIENT_INFO||chr(10)||               
'Logon_time.........................: '||s.LOGON_TIME||chr(10)||                
'Last_call_et.......................: '||s.LAST_CALL_ET||chr(10)||                
'Blocking_session_status............: '||s.BLOCKING_SESSION_STATUS||chr(10)||               
'Blocking_instance..................: '||s.BLOCKING_INSTANCE||chr(10)||               
'Blocking_session...................: '||s.BLOCKING_SESSION||chr(10)||                
'Final_blocking_session_status......: '||s.FINAL_BLOCKING_SESSION_STATUS||chr(10)||               
'Final_blocking_instance............: '||s.FINAL_BLOCKING_INSTANCE||chr(10)||               
'Final_blocking_session.............: '||s.FINAL_BLOCKING_SESSION||chr(10)||                
'Event..............................: '||s.EVENT||chr(10)||               
'P1text.............................: '||s.P1TEXT||chr(10)||                
'Wait_class.........................: '||s.WAIT_CLASS||chr(10)||                
'Seconds_in_wait....................: '||s.SECONDS_IN_WAIT||chr(10)||               
'State..............................: '||s.STATE||chr(10)||               
'Wait_time_micro....................: '||s.WAIT_TIME_MICRO||chr(10)||
'Pga_used_mem.......................: '||p.pga_used_mem||chr(10)||               
'Cpu_used...........................: '||p.cpu_used||chr(10)||               
'Tracefile..........................: '||p.tracefile||chr(10)||               
'Service_name.......................: '||s.SERVICE_NAME 
"Session Details"
from gv$session s, gv$process p
where p.addr  = s.paddr
and p.inst_id = s.INST_ID
and s.sid = '&1' and s.serial# = '&2';
