------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre todas as instancias
-- Compatibilidae: Oracle 19c em diante
-- Ex. @instance 
------------------------------------------------------------------------------


BREAK ON VERSION_FULL;
BREAK ON VERSION;
BREAK ON STATUS;
BREAK ON LOGINS;
BREAK ON DATABASE_STATUS;
BREAK ON ACTIVE_STATE;
BREAK ON DATABASE_TYPE;


col INSTANCE_NAME form a20
col HOST_NAME form a25
col status form a20
col DATABASE_STATUS form a20
col VERSION_FULL form a20
col VERSION form a20
col DATABASE_TYPE	form a20


SELECT
    instance_name,
    host_name,
    version,
    version_full,
    startup_time,
    status,
    logins,
    database_status,
    active_state,
    database_type
FROM
    gv$instance
ORDER BY
    1;