------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre o banco de dados
-- Compatibilidae: Oracle 19c em diante
-- Ex. @aonde 
------------------------------------------------------------------------------

Prompt Print information about database

col resume form a150


select 
'Name.....................: '||NAME||chr(10)||
'Unique Name..............: '||DB_UNIQUE_NAME||chr(10)||
'Cluster Database.........: '||(select database_type from v$instance)||chr(10)||
'CDB......................: '||CDB||chr(10)||
'Container Name...........: '||(SELECT SYS_CONTEXT('userenv', 'con_name') FROM dual)||chr(10)||
'DBID.....................: '||DBID||chr(10)||
'Created..................: '||CREATED||chr(10)||
'Log Mode.................: '||LOG_MODE||chr(10)||
'Open Mode................: '||OPEN_MODE||chr(10)||
'Protection Mode..........: '||PROTECTION_MODE||chr(10)||
'Protection Level.........: '||PROTECTION_LEVEL||chr(10)||
'Database Role............: '||DATABASE_ROLE||chr(10)||
'Switchover Status........: '||SWITCHOVER_STATUS||chr(10)||
'Dataguard Broker.........: '||DATAGUARD_BROKER||chr(10)||
'Plataform Name...........: '||PLATFORM_NAME||chr(10)||
'Force Logging............: '||FORCE_LOGGING||chr(10)||
'Flashback on.............: '||FLASHBACK_ON "Resume"
from v$database
union all
select 
'Version..................: '||VERSION_FULL||chr(10)||
'Total Active Instance....: '||count(1)||chr(10)||
'Hostname.................: '||LISTAGG(host_name, ' | ') WITHIN GROUP (ORDER BY host_name)||chr(10)||
'Instances................: '||LISTAGG(instance_name||' ('||floor(sysdate - startup_time) || 'd ' ||       trunc( 24*((sysdate-startup_time) -        trunc(sysdate-startup_time))) || ':' ||        mod(trunc(1440*((sysdate-startup_time) -       trunc(sysdate-startup_time))), 60) ||':'||') ', '') WITHIN GROUP (ORDER BY instance_name)
from gv$instance
group by VERSION_FULL, edition
union all
select '==========================================' from dual
union all
select '== Server Information' from dual
union all
select '==========================================' from dual
union all
select 
'Number of CPUs...........: '||value 
from v$parameter where name = 'cpu_count'
union all
SELECT
'Total Memory (GB)........: '||round(total_memory.value / 1024, 1)||chr(10)||
'Free Memory (GB).........: '||round(free_memory.value / 1024, 1)||chr(10)||
'Memory Usage (%).........: '||round((total_memory.value - free_memory.value) / total_memory.value * 100, 1)
FROM
    (        SELECT round(value / 1024 / 1024, 1) value
        FROM
            v$osstat
        WHERE
            stat_name IN ('FREE_MEMORY_BYTES')
    ) free_memory,
    (        SELECT
            round(value / 1024 / 1024, 1) value
        FROM
            v$osstat
        WHERE
            stat_name IN ('PHYSICAL_MEMORY_BYTES')
    ) total_memory;
