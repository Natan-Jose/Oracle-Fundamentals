------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras informacoes de todos os usuarios do banco
-- Compatibilidae: Oracle 19c em diante
-- Ex. @users username | @users 1 (ordena pela primeria coluna)
------------------------------------------------------------------------------

col USERNAME	form a35
col ACCOUNT_STATUS	form a20
col DEFAULT_TABLESPACE	form a30
col TEMPORARY_TABLESPACE	form a30
col PROFILE 	form a30
COL LAST_LOGIN FORM A22


SELECT
    username,
    account_status,
    to_char(last_login, 'DD/MM/RRRR HH24:MI:SS') last_login,
    common,
    lock_date,
    expiry_date,
    default_tablespace,
    temporary_tablespace,
    created,
    profile,
    oracle_maintained
FROM
    dba_users
ORDER BY
   &1;