------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre o banco de dados
-- Compatibilidae: Oracle 10g em diante
-- Ex. @aonde11
------------------------------------------------------------------------------


Prompt Print information about database

col resume form a200



select 
'Name.....................: '||NAME||chr(10)||
'Unique Name .............: '||DB_UNIQUE_NAME||chr(10)||
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
'Version..................: '||version||chr(10)||
'Total Active Instance....: '||count(1)||chr(10)||
'Hostname.................: '||LISTAGG(host_name, ' | ') WITHIN GROUP (ORDER BY host_name)||chr(10)||
'Instances................: '||LISTAGG(instance_name||' (days up: '||floor(sysdate - startup_time) || ' days - ' ||       trunc( 24*((sysdate-startup_time) -        trunc(sysdate-startup_time))) || ' hours - ' ||        mod(trunc(1440*((sysdate-startup_time) -       trunc(sysdate-startup_time))), 60) ||' minutes'||') ', '') WITHIN GROUP (ORDER BY instance_name)
from gv$instance
group by version;