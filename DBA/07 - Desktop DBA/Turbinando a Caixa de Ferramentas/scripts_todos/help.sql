------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informações sobre um determinado script
-- Compatibilidae: Oracle 8i em diante
-- Ex. @help nome_script.sql
------------------------------------------------------------------------------


host call  %SQLPATH%\help %SQLPATH%\&1