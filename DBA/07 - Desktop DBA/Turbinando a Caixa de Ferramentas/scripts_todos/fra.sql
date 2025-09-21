------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe as informacoes da Fast Recovery Area
-- Compatibilidae: Oracle 10g em diante
-- Ex. @fra 
------------------------------------------------------------------------------

col name form a20
col "Capacidade em GB" form a30
col "Usado em GB" form a30
col "Livre em GB" form a30
col "Graph" form a30


SELECT name,
         TO_CHAR (FLOOR (space_limit / 1024 / 1024 / 1024), '99G999G999G999D99','NLS_NUMERIC_CHARACTERS='',.''' ) "Capacidade em GB",
         TO_CHAR (CEIL (space_used / 1024 / 1024 / 1024), '99G999G999G999D99','NLS_NUMERIC_CHARACTERS='',.''' ) "Usado em GB",
         TO_CHAR (ROUND (( space_limit - space_used)/ 1024 / 1024 / 1024), '99G999G999G999D99','NLS_NUMERIC_CHARACTERS='',.''' )  "Livre em GB",
         ROUND (space_used / nullif (space_limit,0) * 100, 2) "Percentual Utilizado",
         '|'||rpad(lpad('#',ceil((1-nvl((space_limit - space_used),0)/decode(space_limit,0,1,space_limit))*20),'#'),20,' ')||'|' "Graph"
    FROM v$recovery_file_dest
ORDER BY name;


col file_type form a25
select * from v$flash_recovery_area_usage;