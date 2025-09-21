------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras as sessoes de forma detalhada
-- Compatibilidae: Oracle 10g em diante
-- Ex. @quem2 "program like '%sqlplus%'"
------------------------------------------------------------------------------

SET VERIFY OFF


COLUMN schemaname       FORMAT A25
COLUMN username         FORMAT A15
COLUMN osuser           FORMAT A25
COLUMN spid             FORMAT A10
COLUMN service_name     FORMAT A15
COLUMN module           FORMAT A30
COLUMN machine          FORMAT A25
COLUMN logon_time       FORMAT A20
COLUMN event            FORMAT A30
COLUMN wait_class       FORMAT A20
COLUMN state            FORMAT A20
COLUMN program          FORMAT A30
COLUMN status           FORMAT A12
COLUMN lockwait           FORMAT A12
COLUMN sid           FORMAT 9999999999



SET PAGESIZE 200


BREAK ON username;
BREAK ON machine SKIP 0;


Prompt "Display all sessions by ...."
select * from (
select 
       s.inst_id,
       NVL(s.username, '(oracle)') AS username,
       substr(s.machine,1,25) machine,
       s.status,
       s.wait_class, 
   --    s.state,
       s.osuser,
    --   S.port,
       s.sid,
       s.serial#,
  --     p.spid,
  --     s.lockwait,
       substr(s.module,1,25) module,
       substr(s.program,1,25) program,
       substr(s.service_name,1,15) service_name,       
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
    --   s.last_call_et AS last_call_et_secs,
  --     ROUND((SYSDATE-s.LOGON_TIME)*(24*60),1) as MINUTES_LOGGED_ON, 
   --    ROUND(s.LAST_CALL_ET/60,1) as Minutes_FOR_CURRENT_SQL,
   --    s.event   
   --    p.tracefile
from gv$session s, gv$process p
where p.addr  = s.paddr
and p.inst_id = s.INST_ID
and type = 'USER'
and type !='BACKGROUND')
where &1
-- and s.status = 'ACTIVE'
order by username, machine,program, status ;


Prompt "Display all  Active sessions by &1...."

select
schemaname, program, machine
  , count(*) "Total"
from
    gv$session s
where
    status='ACTIVE'
and type !='BACKGROUND'
and wait_class != 'Idle'
and sid != (select sid from v$mystat where rownum=1)
and &1
group by
    schemaname, program, machine
order by
    count(*) desc
/


SET VERIFY ON