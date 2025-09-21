------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras as sessoes de forma agrupada
-- Compatibilidae: Oracle 10g em diante
-- Ex. @quem username | @quem username,program 
------------------------------------------------------------------------------


set VERIFY OFF
set pagesize 100
col username 		form a30
col service_name 	form a30
col pdb 			form a30
col program 		form a30
col machine 		form a30

prompt
prompt
prompt All connections in database, excepction background process

col username form a30

col &1 form a30


col module form a50



select
&1,
count(1) "Total",
sum(decode(status,'ACTIVE',1,0)) "Ativo",
sum(decode(status,'INACTIVE',1,0)) "Inativo",
sum(decode(status,'KILLED',1,0)) "Killed" 
from gv$session s, (select con_id,name as pdb from v$pdbs) p
where s.con_id = p.con_id(+)
and type !='BACKGROUND'
group by &1
order by &1;


prompt
prompt
prompt Connections by inst_id

compute sum of "Total" on report
compute sum of "Ativo" on report
compute sum of "Inativo" on report
compute sum of "Killed" on report
break on report

col PDB form a30
col Killed form 9999
select
inst_id, 
nvl(p.pdb,'cdb$root') as PDB,
count(1) "Total",
sum(decode(status,'ACTIVE',1,0)) "Ativo",
sum(decode(status,'INACTIVE',1,0)) "Inativo",
sum(decode(status,'KILLED',1,0)) "Killed" 
from gv$session s, (select con_id,name as pdb from v$pdbs) p
where s.con_id = p.con_id(+)
group by inst_id, p.pdb
order by 1;


prompt
prompt
prompt Display active sessions grouped by &1....


compute sum of "Total" on report
col &1 form a80

select
    &1
  , count(*) "Total"
from
    gv$session s, (select con_id,name as pdb from v$pdbs) p
where
	s.con_id = p.con_id(+)
and    status='ACTIVE'
and type !='BACKGROUND'
and wait_class != 'Idle'
and sid != (select sid from v$mystat where rownum=1)
group by
    &1
order by
    count(*) desc
/


set VERIFY ON