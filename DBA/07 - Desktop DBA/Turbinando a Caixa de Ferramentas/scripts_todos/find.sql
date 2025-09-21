------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Procura objetos no banco de dados (Usando o like)
-- Compatibilidae: Oracle 10g em diante
-- Ex. @find OWNER OBJECT_TYPE OBJECT_NAME 
------------------------------------------------------------------------------


set feedback on
set pagesize 100
SET VERIFY OFF
col owner form a30
col object_name form a30
col object_type form a20
col created form a20
col status form a20


prompt
Prompt Listing Owner like: &1
Prompt Listing Object_type like: &2
Prompt Listing objects like: &3


Prompt Listing Objects
select owner,object_name, object_type, created , status
from dba_objects
where owner like upper('%&1%')
and object_type like upper('%&2%')
and object_name like upper('%&3%');

col segment_name form a30



SET VERIFY ON