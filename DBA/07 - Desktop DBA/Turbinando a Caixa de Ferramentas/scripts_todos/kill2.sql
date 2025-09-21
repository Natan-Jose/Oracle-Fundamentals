------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Gera o comando para finalizar uma sessao
-- Compatibilidae: Oracle 10g em diante
-- Ex.  @kill2 username='SYSTEM' | @kill2 "username='APP' and program like 'sqlplus%'"
------------------------------------------------------------------------------


col  commands_to_verify_and_run form a200

set pages 5000
spool &tempdir/kill_user.sql
set heading off
set verify off
set feedback off

prompt
prompt

select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate -- '
       ||username||'@'||machine||' ('||program||');' commands_to_verify_and_run
from gv$session
where &1
and sid != (select sid from v$mystat where rownum = 1)
/ 

spool off

set heading on
set verify on
set feedback on

prompt
prompt
prompt


prompt execute the script @&tempdir/kill_user.sql

prompt
prompt