------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe os logs de um backup especifico. 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @backup_detail recid stamp  (Exibe os logs do backup)
------------------------------------------------------------------------------


set lines 1000

set pages 5000
--spool &_tpt_tempdir/rman.log
set heading off
set verify off
set feedback off

col output form a1000




select output
from gv$rman_output
where session_recid = &1
    AND session_stamp = &2
order by recid ;




--spool off

--host &_tpt_tempdir/rman.log

@init


set heading on