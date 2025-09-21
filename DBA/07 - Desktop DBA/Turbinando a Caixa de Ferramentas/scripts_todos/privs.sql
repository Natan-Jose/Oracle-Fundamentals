------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras os privilegios dos usuarios
-- Compatibilidae: Oracle 11g em diante
-- Ex. @privs NOME_USUARIO | @privs teste (privilegios do usuario teste)
------------------------------------------------------------------------------


set verify off
col grantee for a25
col owner for a25
col table_name for a30

col grantee form a20
col granted_role    form a20
col default_role    form a20
col PRIVILEGE form a30

prompt 
prompt PRIVILEGS FROM &1 IN DBA_ROLE_PRIVS
prompt 

SELECT
    grantee,
    granted_role,
    admin_option,
    default_role
FROM
    dba_role_privs
WHERE
    upper(grantee) LIKE upper('&1');

prompt 
prompt PRIVILEGS FROM &1 IN  DBA_SYS_PRIVS
prompt 

SELECT
    grantee,
    privilege,
    admin_option
FROM
    dba_sys_privs
WHERE
    upper(grantee) LIKE upper('&1');

prompt 
prompt PRIVILEGS FROM &1 IN  DBA_TAB_PRIVS
prompt
 
SELECT
    grantee,
    owner,
    table_name,
    privilege,GRANTABLE
FROM
    dba_tab_privs
WHERE
    upper(grantee) LIKE upper('&1');