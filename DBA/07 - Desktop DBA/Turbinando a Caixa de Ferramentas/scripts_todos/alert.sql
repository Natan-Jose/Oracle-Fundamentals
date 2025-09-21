------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe os caminhos dos alerts
-- Compatibilidae: Oracle 10g em diante
-- Ex. @alert 
------------------------------------------------------------------------------


show parameter DIAGNOSTIC_DEST;
Col name format a25
Col value format a70
Select name, value from v$diag_info;