------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Procura objetos no banco de dados (Usando o =)
-- Compatibilidae: Oracle 10g em diante
-- Ex. @find2 OWNER OBJECT_TYPE OBJECT_NAME 
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
Prompt Listing Owner = &1
Prompt Listing Object_type = &2
Prompt Listing objects = &3


Prompt Listing Objects
select owner,object_name, object_type, created , status
from dba_objects
where owner = '&1'
and object_type  like '%&2%'
and object_name like '%&3%';








SET VERIFY ON