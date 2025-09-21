------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Mostras informacoes de todos os usuarios do banco
-- Compatibilidae: Oracle 11g em diante
-- Ex. @users11 username | @users11 1
------------------------------------------------------------------------------


variable order_col varchar2(30)
BEGIN
    :order_col := nvl('&1', 'USERNAME');
END;
/
col USERNAME	form a30
col ACCOUNT_STATUS	form a20
col DEFAULT_TABLESPACE	form a30
col TEMPORARY_TABLESPACE	form a30
col PROFILE 	form a30
select USERNAME, ACCOUNT_STATUS,LOCK_DATE,EXPIRY_DATE, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE,CREATED, PROFILE
from dba_users
order by created;