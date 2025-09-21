------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Faz o compile dos objetos invalidos de um determinado usuario
-- Compatibilidae: Oracle 11g em diante
-- Ex. @compile_schema TESTE | @compile_schema teste (Compile dos objetos invalidos do usuario teste)
------------------------------------------------------------------------------

set serverout on
set verify off
set feedback off


prompt COMPILING INVALID OBJECTS FOR &1


column tot_invalids_before new_value p_tot_invalids_before

select count(1) tot_invalids_before
from dba_objects 
where status = 'INVALID'
and owner = '&1';


set feedback on


PROMPT Compiling Objects for schema &1

EXEC DBMS_UTILITY.compile_schema(schema => '&1', compile_all => false);


set feedback off


column tot_invalids_after new_value p_tot_invalids_after

select count(1) tot_invalids_after
from dba_objects 
where status = 'INVALID'
and owner = '&1';

set feedback on


@inv2 &1


-- prompt &p_tot_invalids_before
-- prompt &p_tot_invalids_after

