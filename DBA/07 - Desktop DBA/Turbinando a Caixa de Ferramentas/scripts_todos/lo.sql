------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostra os ultimos objetos criados
-- Compatibilidae: Oracle 10g em diante
-- Ex. @lo 5 | mostra os objetos criados nos ultimos 5 minutos
------------------------------------------------------------------------------



col owner form a20
col object_name form a30
col object_type form a30


select owner, object_name, object_type, status, created
from dba_objects
where created > SYSDATE-&1/(24*60);