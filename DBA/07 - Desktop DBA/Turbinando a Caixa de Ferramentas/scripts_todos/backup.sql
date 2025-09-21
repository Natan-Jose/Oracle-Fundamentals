------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre o backup do banco. 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @backup 7 (Exibe 7 dias de backup)
------------------------------------------------------------------------------

set verify off
set feedback off

col tempo                   form a20
col "Destination"           form a20
col "Size"                  form a20
col status                  form a20
col backup_type             form a25
col start_time              form a22
col DAY 					form a15


SET VERIFY OFF
col backup_type form a15
col data_inicio form a12
col inicio form a12
col fim form a22
col tempo form a15
col SIZE form a20
col backup_status form a30
col DEVICE form a15


prompt
prompt
prompt Rman Configuration

COL NAME FORM A50
COL VALUE FORM A80
SELECT name, value FROM V$RMAN_CONFIGURATION;


col "Backup Type" form a40
prompt
prompt
prompt View last backup of database

COL "Backup Type" FORM A20
COL "Last Backup"  FORM A20
COL BKP_SIZE FORM A15
COL TEMPO FORM a15



select input_type||' '||b.incremental_level "Backup Type" ,
max(end_time) "Last Backup" , 
round(sysdate-max(end_time),1) "Days since last backup", 
max(OUTPUT_BYTES_DISPLAY) BKP_SIZE,
            FLOOR (ROUND ( ( (max(end_time) - max(START_TIME) ) * 1440), 2) / 60 )
         || 'h'
         || TRUNC (MOD (ROUND ( ( (max(end_time) - max(START_TIME) ) * 1440), 2), 60))
         || 'min'
            tempo 
from 
    v$rman_backup_job_details r
    INNER JOIN (SELECT DISTINCT session_stamp, incremental_level 
                FROM v$backup_set_details ) b 
    ON r.session_stamp = b.session_stamp
where        incremental_level IS NOT NULL
and r.input_type = 'DB INCR'
and status = 'COMPLETED'
    group by input_type||' '||b.incremental_level
UNION ALL
SELECT
    input_type ,
max(end_time) "Last Backup" , 
round(sysdate-max(end_time),1) "Days since last backup", 
max(OUTPUT_BYTES_DISPLAY),
            FLOOR (ROUND ( ( (max(end_time) - max(START_TIME) ) * 1440), 2) / 60 )
         || 'h'
         || TRUNC (MOD (ROUND ( ( (max(end_time) - max(START_TIME) ) * 1440), 2), 60))
         || 'min'
            tempo 
FROM
    v$rman_backup_job_details r
     WHERE input_type  in ( 'ARCHIVELOG','DB FULL')
--and status = 'RUNNING'
    group by input_type;



    
prompt 
prompt 
prompt View last Control File backup    

select autobackup_count, autobackup_done, max(end_time) "Last Backup"
from 
    v$rman_backup_job_details r
    INNER JOIN (SELECT DISTINCT session_stamp, incremental_level ,controlfile_included
                FROM v$backup_set_details ) b 
    ON r.session_stamp = b.session_stamp
    where controlfile_included = 'YES'
    and status = 'COMPLETED'
    group by autobackup_count, autobackup_done;
    
set feedback on







-- prompt 
-- prompt 
-- Prompt Archived Log backup history
-- 
-- select
-- to_char( first_time,'RRRR-MM-DD') DATE_ARCH, archived, deleted, status, backup_count, ROUND(SUM(BLOCKS * BLOCK_SIZE)/1024/1024/1024,2) SIZE_GB, count(1) from V$ARCHIVED_LOG 
-- WHERE first_time >= TRUNC (SYSDATE) - 10
-- group by to_char( first_time,'RRRR-MM-DD'), archived, deleted, status, backup_count
-- ORDER BY 1 DESC;
-- 
 
prompt 
prompt 
Prompt Detailed Report




SELECT j.session_recid,j.session_stamp,
TO_CHAR ( j. start_time, 'DAY' ) DAY ,
TO_CHAR ( j. start_time, 'RRRR-MM-DD HH24:MI:SS' ) start_time ,
 TO_CHAR (END_TIME , 'RRRR-MM-DD HH24:MI:SS') fim,
            FLOOR (ROUND ( ( (END_TIME - START_TIME ) * 1440), 2) / 60 )
         || 'h'
         || TRUNC (MOD (ROUND ( ( (END_TIME - START_TIME ) * 1440), 2), 60))
         || 'min'
            tempo ,
        case
            when (j.input_type = 'DB INCR' and "Incremental 0" > 0) then 'DB INCR 0'
            when (j.input_type = 'DB INCR' and "Incremental 1" >0 ) then 'DB INCR 1'
            when (j.input_type = 'DB INCR' and "Incremental 2" >0 ) then 'DB INCR 2'
         ELSE
            j.input_type
        END BACKUP_TYPE,
        j.OUTPUT_DEVICE_TYPE DEVICE,
         OUTPUT_BYTES_DISPLAY AS BKP_SIZE,
		-- round( (OUTPUT_BYTES/1024/1024/1024)/(ELAPSED_SECONDS/60),2) "WRITE GB MIN",
        -- round( (INPUT_BYTES/1024/1024/1024)/(ELAPSED_SECONDS/60),2) "READ GB MIN",
         INITCAP (j .status ) backup_status,
          x.Logfiles,ro.inst_id output_instance
    FROM V$RMAN_BACKUP_JOB_DETAILS j
         LEFT OUTER JOIN
         (SELECT d .session_recid ,
                   d .session_stamp ,
                   SUM (CASE WHEN d .controlfile_included = 'YES' THEN d.pieces  ELSE 0 END)"Controlfile" ,
                   SUM ( CASE WHEN     d .controlfile_included = 'NO' AND d.backup_type || d. incremental_level = 'D' THEN d.pieces ELSE  0 END)"Datafile" ,
                   SUM (CASE WHEN d .backup_type || d .incremental_level = 'I0' THEN d. pieces ELSE 0 END) "Incremental 0",
                   SUM (CASE WHEN d .backup_type || d .incremental_level = 'I1' THEN d. pieces ELSE 0 END) "Incremental 1",
                   SUM (CASE WHEN d .backup_type || d .incremental_level = 'I2' THEN d. pieces ELSE 0 END) "Incremental 2",
                   SUM (CASE WHEN d .backup_type = 'D' AND d .incremental_level is null THEN d. pieces ELSE 0 END) "Full",
                   SUM (CASE WHEN d .backup_type = 'L' THEN d .pieces ELSE 0 END) Logfiles
FROM V$BACKUP_SET_DETAILS d 
GROUP BY d .session_recid , d .session_stamp ) x
            ON     x .session_recid = j .session_recid
               AND x .session_stamp = j .session_stamp
         LEFT OUTER JOIN
         (  SELECT o .session_recid , o .session_stamp , MIN (inst_id ) inst_id
              FROM GV$RMAN_OUTPUT o
          GROUP BY o .session_recid , o .session_stamp ) ro
            ON     ro .session_recid = j .session_recid
               AND ro .session_stamp = j .session_stamp
   WHERE j.start_time >= TRUNC (SYSDATE) - &1
ORDER BY j. start_time DESC;



prompt
prompt
prompt Space on Fast Recover Area


@FRA



prompt
prompt
prompt Backup in progress


SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%'
AND OPNAME NOT LIKE '%aggregate%'
AND TOTALWORK != 0
AND SOFAR <> TOTALWORK;
