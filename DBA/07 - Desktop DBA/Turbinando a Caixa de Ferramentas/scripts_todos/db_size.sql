------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre a ocupacao do banco
-- Compatibilidae: Oracle 10g em diante
-- Ex. @db_size
------------------------------------------------------------------------------


COL "Datafile Size"     FORM A20
COL "Tempfile Size"     FORM A20
COL "RedoLog Size"      FORM A20
COL "Segment Size"      FORM A20
COL "Database Size"     FORM A70
col "Free Space" 		FORM A20

SELECT 
'===========================================================' || chr(10) ||
'Phisycal Size' || chr(10) ||
'===========================================================' || chr(10) ||
		'Datafile size		: '||CASE
          WHEN LENGTH (df.total) >= 13
                THEN              TO_CHAR (ROUND (df.total / 1024 / 1024 / 1024 / 1024, 2) || ' TB')
          WHEN LENGTH (df.total) < 13          
                THEN             TO_CHAR (ROUND (df.total / 1024 / 1024 / 1024, 2) || ' GB')
       END || chr(10) ||
       'Tempfile size		: '||CASE
          WHEN LENGTH (temp.total) >= 10
                THEN TO_CHAR (ROUND (temp.total / 1024 / 1024 / 1024, 2) || ' GB')
          WHEN LENGTH (temp.total) < 10
                THEN TO_CHAR (ROUND (temp.total / 1024 / 1024, 2) || ' MB')
       END  || chr(10) ||
      'Redo Log size		: '|| CASE
          WHEN LENGTH (LOG.total) >= 10
                THEN TO_CHAR (ROUND (LOG.total / 1024 / 1024 / 1024, 2) || ' GB')
          WHEN LENGTH (LOG.total) < 10
                THEN TO_CHAR (ROUND (LOG.total / 1024 / 1024, 2) || ' MB')
       END || chr(10) ||
	   'FRA Ocupation    		: '||fra_size||' GB'|| chr(10) ||
	   'Control File size	: '||ctl_file_size||' MB'|| chr(10) ||
'===========================================================' || chr(10) ||
   'Segment size		: '|| CASE
          WHEN LENGTH (seg.total) >= 13
                THEN TO_CHAR (ROUND (seg.total / 1024 / 1024 / 1024 / 1024, 2) || ' TB')
          WHEN LENGTH (seg.total) < 13
                THEN TO_CHAR (ROUND (seg.total / 1024 / 1024 / 1024, 2) || ' GB')
       END || chr(10) ||
   'Free Space size		: '||CASE
          WHEN LENGTH (FREE_SPACE.size_free) >= 13
                THEN TO_CHAR (ROUND (FREE_SPACE.size_free / 1024 / 1024 / 1024 / 1024, 2) || ' TB')
          WHEN LENGTH (FREE_SPACE.size_free) < 13
                THEN TO_CHAR (ROUND (FREE_SPACE.size_free / 1024 / 1024 / 1024, 2) || ' GB')
       END || chr(10) ||
     'Database size		: '|| CASE
          WHEN LENGTH (DF.TOTAL + LOG.TOTAL + TEMP.TOTAL) >= 13
                THEN TO_CHAR (ROUND ((DF.TOTAL + LOG.TOTAL + TEMP.TOTAL)/ 1024/ 1024/ 1024/ 1024,2)|| ' TB')
          WHEN LENGTH (DF.TOTAL + LOG.TOTAL + TEMP.TOTAL) < 13
                THEN  TO_CHAR (ROUND ((DF.TOTAL + LOG.TOTAL + TEMP.TOTAL)/ 1024/ 1024/ 1024,2)|| ' GB')
       END   "Database Size"
	   FROM DUAL,
       (SELECT SUM (a.bytes) TOTAL
          FROM dba_data_files a) DF,
       (SELECT SUM (d.bytes) TOTAL
          FROM dba_temp_files d) TEMP,
       (SELECT SUM (b.bytes * b.members) TOTAL
          FROM v$log b) LOG,
      (SELECT SUM (fs.bytes ) size_free
          FROM dba_free_space fs) FREE_SPACE,
       (SELECT SUM (bytes) TOTAL FROM dba_segments) SEG,
	   (select sum (fra_size) as fra_size from 
        (
        select nvl(round(space_used / 1024 / 1024 / 1024,2),0)+0 fra_size 
        FROM v$recovery_file_dest 
        union all 
        select 0 from dual)
               ) fra,
	   (SELECT round(SUM(block_size * file_size_blks) / 1024  / 1024,2) ctl_file_size
FROM v$controlfile) ctl_file;


prompt 
prompt 
prompt ===========================================================
prompt == Top ten large Segments
prompt ===========================================================


col OWNER form a30
col SEGMENT_NAME form a30
col SEGMENT_TYPE form a30
col TABLESPACE_NAME form a30



SELECT * FROM (
select OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, ROUND(BYTES/1024/1024/1024,1) SIZE_GB from dba_segments
ORDER BY BYTES DESC)
WHERE ROWNUM <= 10;
       
	   
	   
