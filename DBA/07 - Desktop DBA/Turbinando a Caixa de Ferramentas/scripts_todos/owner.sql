------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe os schemas do banco
-- Compatibilidae: Oracle 12c em diante
-- Ex. owner
------------------------------------------------------------------------------


COL USERNAME                FORM A30
COL "Default Tablespace"    FORM A30
COL "Temporary Tablespace"  FORM A30
COL "Data de Criacao"       FORM A20
COL "Ultimo Objeto Criado"  FORM A20
COL "Total de Objetos"      FORM A20
COL "Ocupacao"              FORM A20


column "Default Tablespace"         heading 'Default|Tablespace'
column "Temporary Tablespace"       heading 'Temporary|Tablespace'
column "Data de Criacao"            heading 'Data|de Criacao'
column "Ultimo Objeto Criado"       heading 'Ultimo|Objeto Criado'
column "Total de Objetos"            heading 'Total|de Objetos'

Prompt Printing information about schema ocupation


SELECT a.username,
       default_tablespace "Default Tablespace",
 --      temporary_tablespace "Temporary Tablespace",
       to_char(created,'DD/MM/RRRR') "Data de Criacao",
       to_char(last_objetct,'DD/MM/RRRR') "Ultimo Objeto Criado",
      TO_CHAR(NVL (b.tot,0),'999,999,999') "Total de Objetos",                
        CASE
          WHEN LENGTH (c.tamanho) >= 13
                THEN TO_CHAR (ROUND (c.tamanho / 1024 / 1024 / 1024 / 1024, 2) || ' TB')
          WHEN LENGTH (c.tamanho)  between 10 and  12
                THEN TO_CHAR (ROUND (c.tamanho / 1024 / 1024 / 1024, 2) || ' GB')
          WHEN LENGTH (c.tamanho) < 10
                THEN TO_CHAR (ROUND (c.tamanho / 1024 / 1024, 2) || ' MB')
       END "Ocupacao",
       ROUND(RATIO_TO_REPORT((c.tamanho)) OVER()*100, 2) "% Ocupacao"
  FROM dba_users a,
       (  SELECT owner, COUNT (1) tot,Max(created) last_objetct 
            FROM dba_objects
        GROUP BY owner) b, 
        (SELECT owner, sum(bytes) tamanho
            FROM dba_segments
        GROUP BY owner) c      
 WHERE a.username = b.owner(+)
 and a.username = c.owner(+)
 and c.tamanho > 0
 and a.username NOT IN
  ('CONNECT', 'RESOURCE', 'DBA', 'SELECT_CATALOG_ROLE',
    'EXECUTE_CATALOG_ROLE', 'DELETE_CATALOG_ROLE', 'EXP_FULL_DATABASE',
    'IMP_FULL_DATABASE', 'RECOVERY_CATALOG_OWNER',
    'GATHER_SYSTEM_STATISTICS', 'LOGSTDBY_ADMINISTRATOR',
    'AQ_ADMINISTRATOR_ROLE', 'AQ_USER_ROLE', 'GLOBAL_AQ_USER_ROLE',
    'SCHEDULER_ADMIN', 'HS_ADMIN_ROLE', 'OEM_ADVISOR', 'OEM_MONITOR',
    'WM_ADMIN_ROLE', 'JAVAUSERPRIV', 'JAVAIDPRIV', 'JAVASYSPRIV',
    'JAVADEBUGPRIV', 'EJBCLIENT', 'JAVA_ADMIN', 'JAVA_DEPLOY',
    'XDBADMIN', 'CTXAPP', 'AUTHENTICATEDUSER', 'XDBWEBSERVICES',
    'OLAPI_TRACE_USER', 'OLAP_DBA', 'CWM_USER', 'OLAP_USER',
    'MGMT_USER', 'SYS', 'DBSNMP', 'EXFSYS', 'XDB', 'SYSTEM', 'SYSMAN',
    'MDSYS', 'ORDSYS', 'OLAPSYS',    'WMSYS',
    'ORDPLUGINS', 'DMSYS', 'SCOTT', 'CTXSYS', 'BI', 'OUTLN',
    'DIP', 'TSMSYS', 'PM', 'MDDATA', 'ANONYMOUS', 'ORACLE_OCM',
    'SI_INFORMTN_SCHEMA','MGMT_VIEW','ORDDATA','APEX_030200','GSMADMIN_INTERNAL',
	'OJVMSYS','LBACSYS','DVSYS','AUDSYS','DVSYS','DATAPUMP_IMP_FULL_DATABASE',
	'AUDIT_ADMIN','SYSBACKUP','GGSYS','RECOVERY_CATALOG_OWNER_VPD','DV_REALM_OWNER'
	,'EM_EXPRESS_ALL','SYSDG','APPQOSSYS', 'DBSFWUSER','SQLTXPLAIN','APEX_050000', 'T10027723704', 'APEX_040200')
 order by 7 desc;
 
 
 
