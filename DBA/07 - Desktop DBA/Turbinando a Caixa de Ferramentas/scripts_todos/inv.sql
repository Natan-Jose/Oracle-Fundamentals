------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras os objetos invalidos do ambiente
-- Compatibilidae: Oracle 11g em diante
-- Ex. @inv
------------------------------------------------------------------------------

prompt Show invalid objects, indexes, index partitions and index subpartitions....

col ind_owner head OWNER for a20
col inv_oname head OBJECT_NAME for a30
col owner form a25


SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Invalid Objects                                             |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN owner           FORMAT a25         HEADING 'Owner'
COLUMN object_name     FORMAT a30         HEADING 'Object Name'
COLUMN object_type     FORMAT a20         HEADING 'Object Type'
COLUMN status          FORMAT a10         HEADING 'Status'

BREAK ON owner SKIP 0 ON report

COMPUTE count LABEL ""               OF object_name ON owner
COMPUTE count LABEL "Grand Total: "  OF object_name ON report

SELECT
    owner
  , object_name
  , object_type
  , status
FROM dba_objects
WHERE status <> 'VALID'
ORDER BY owner, object_name
/

select owner, count(1) tot_invalids from dba_objects  where status != 'VALID' group by owner order by 1,2;


select owner ind_owner, table_name, index_name from dba_indexes where status not in ('VALID', 'N/A') order by 1,2;

select index_owner ind_owner, index_name, partition_name from dba_ind_partitions where status not in ('N/A', 'USABLE') order by 1,2;

select indeX_owner ind_owner, index_name, partition_name, subpartition_name from dba_ind_subpartitions where status not in ('USABLE') order by 1,2;

col total format 999,999,999,999,999
select status, count(1) total from dba_objects   group by status order by 1,2;

prompt for specific schema @inv2 SCHEMA