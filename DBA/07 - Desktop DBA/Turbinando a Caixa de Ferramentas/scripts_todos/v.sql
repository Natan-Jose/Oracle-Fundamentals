------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe a versao do Oracle
-- Compatibilidae: Oracle 19c em diante
-- Ex. @v
------------------------------------------------------------------------------
col banner_full form a80

select banner_full from v$version;

