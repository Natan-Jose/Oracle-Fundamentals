------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras os objetos invalidos do ambiente de um determinado usuario
-- Compatibilidae: Oracle 11g em diante
-- Ex. @inv2 | @inv2 TESTE (objetos invalidos do usuario teste)
------------------------------------------------------------------------------


set verify off



prompt Show invalid objects, indexes, index partitions and index subpartitions for &1....

col ind_owner head OWNER for a20
col inv_oname head OBJECT_NAME for a30

prompt Invalid Objects

select owner ind_owner, object_name inv_oname, object_type from dba_objects where status != 'VALID' and owner = '&1' order by 1,2;


prompt Invalid Indexes


select owner ind_owner, table_name, index_name from dba_indexes where status not in ('VALID', 'N/A') and owner = '&1' order by 1,2;

prompt Invalid Index Partition


select index_owner ind_owner, index_name, partition_name from dba_ind_partitions where status not in ('N/A', 'USABLE')  and index_owner = '&1' order by 1,2;


prompt Invalid Index Sub Partition

select indeX_owner ind_owner, index_name, partition_name, subpartition_name from dba_ind_subpartitions where status not in ('USABLE')  and index_owner = '&1' order by 1,2;

