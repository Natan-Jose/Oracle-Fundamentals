------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre o ASM
-- Compatibilidae: Oracle 19c em diante
-- Ex. @asm 
------------------------------------------------------------------------------

col NAME form a20
col TYPE form a20
col "Total Alocado" form a15
col "Total Ocupado" form a15
col "Livre" form a15
col "Ocupado %" form 999,999,999.99
col "Graph" form a30



select 
NAME,   TYPE,
 CASE
          WHEN LENGTH (TOTAL_MB) >= 7
                THEN              TO_CHAR (ROUND (TOTAL_MB / 1024 / 1024 , 2) || ' TB')
          WHEN LENGTH (TOTAL_MB) < 7          
                THEN             TO_CHAR (ROUND (TOTAL_MB / 1024, 2) || ' GB')
       END  "Total Alocado",
 CASE
          WHEN LENGTH (TOTAL_MB - FREE_MB) >= 7
                THEN              TO_CHAR (ROUND ((TOTAL_MB - FREE_MB) / 1024 / 1024 , 2) || ' TB')
          WHEN LENGTH (TOTAL_MB - FREE_MB) < 7          
                THEN             TO_CHAR (ROUND ((TOTAL_MB - FREE_MB) / 1024, 2) || ' GB')
       END  "Total Ocupado"      ,
CASE
        WHEN LENGTH (FREE_MB) >= 7
                THEN              TO_CHAR (ROUND (FREE_MB / 1024 / 1024 , 2) || ' TB')
          WHEN LENGTH (FREE_MB) < 7          
                THEN             TO_CHAR (ROUND (FREE_MB / 1024, 2) || ' GB')
       END  "Livre",
       case when (TOTAL_MB - FREE_MB) = 0 then 0
    else 
     ROUND ( (TOTAL_MB - FREE_MB) / TOTAL_MB * 100, 2)  
    end "Ocupado %",
    case when (TOTAL_MB - FREE_MB) = 0 then null
    else 
     '|'||rpad(lpad('#',ceil((1-nvl(FREE_MB,0)/decode(TOTAL_MB,0,1,TOTAL_MB))*20),'#'),20,' ')||'|' 
    end "Graph"
FROM V$ASM_DISKGROUP;
