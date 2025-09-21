------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe os diretorios do banco de dados
-- Compatibilidae: Oracle 10g em diante
-- Ex. @dir 
------------------------------------------------------------------------------


col owner form a30
col DIRECTORY_NAME form a30
col DIRECTORY_PATH form a150


SELECT
    owner,
    directory_name,
    directory_path
FROM
    dba_directories
ORDER BY
    1,2;


