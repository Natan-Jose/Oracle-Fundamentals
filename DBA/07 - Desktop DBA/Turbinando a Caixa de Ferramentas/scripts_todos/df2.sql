------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre os datafiles de uma tablespace especifica
-- Compatibilidae: Oracle 10g em diante
-- Ex. @df2 tablespace_name
------------------------------------------------------------------------------

set verify off

col file_name form a120
col tablespace_name form a30

SELECT
    file_id,
    tablespace_name,
    file_name,
    round(bytes / 1024 / 1024 / 1024, 1)      size_gb,
    status,
    autoextensible,
    round(maxbytes / 1024 / 1024 / 1024, 1)   maxsize_gb,
    round(increment_by / 1024 / 1024, 2)      increment_by_mb,
    round(user_bytes / 1024 / 1024 / 1024, 1) used_gb
FROM
    dba_data_files
where tablespace_name = '&1'
ORDER BY 2,1;

select count(1) from dba_data_files where tablespace_name = '&1';