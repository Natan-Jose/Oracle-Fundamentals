------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Faz uma consulta na view DICT
-- Compatibilidae: Oracle 12c em diante
-- Ex. @dict NOME_VIEW 
------------------------------------------------------------------------------

SET VERIFY OFF

COL COMMENTS FORM A90
COL TABLE_NAME FORM A50


select * from DICT
where table_name like upper('%&1%')
ORDER BY 1 DESC;

SET VERIFY ON