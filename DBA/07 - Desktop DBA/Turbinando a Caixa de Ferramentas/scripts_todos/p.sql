------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostra informações de um determinado parâmetro do banco
-- Compatibilidae: Oracle 10g em diante
-- Ex. @p sga
------------------------------------------------------------------------------


set verify off

col NAME	form a40
col VALUE	form a120


select 
INST_ID
,NAME
,VALUE
from Gv$parameter 
where lower(name) like lower('%&1%')
order by name, inst_id;

