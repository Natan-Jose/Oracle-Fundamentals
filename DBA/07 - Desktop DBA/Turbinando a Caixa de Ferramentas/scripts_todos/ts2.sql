------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe as informacoes de uma tablespace especifica
-- Compatibilidae: Oracle 12c em diante
-- Ex. @ts2 TABLESPACE_NAME 
------------------------------------------------------------------------------


CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES
set linesize 250

SET SPACE 1


set trimspool off
set pagesize 80


prompt
prompt ===========================================================
prompt == Grafico das tablespaces 
prompt ===========================================================

BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF "TamanhoMaximoGB"    ON REPORT
COMPUTE SUM LABEL TOTAL OF "TamanhoAlocadoGB"   ON REPORT
COMPUTE SUM LABEL TOTAL OF "EspacoUtilizadoGB"  ON REPORT
COMPUTE SUM LABEL TOTAL OF "LivreGB"            ON REPORT
COMPUTE SUM LABEL TOTAL OF "TotalSegs"          ON REPORT
COMPUTE SUM LABEL TOTAL OF "TOT_FILES"          ON REPORT







column tablespace_name    FORM A30

col "Pct_Usado" format 99.99
col Graph format a30

col "TamanhoMaximoGB"  	form 999,999,999,999.99
col "TamanhoAlocadoGB" 	form 999,999,999,999.99
col "EspacoUtilizadoGB"	form 999,999,999,999.99
col "LivreGB"          	form 999,999,999,999.99
col "TotalSegs"        	form 999,999,999,999
col contents form a20




select  
tb.tablespace_name, 
    '|'||rpad(lpad('#',ceil((1-nvl((((tbm.TABLESPACE_SIZE-tbm.used_space)*tb.block_size)),0)/decode((tbm.TABLESPACE_SIZE*tb.block_size),0,1,(tbm.TABLESPACE_SIZE*tb.block_size)))*20),'#'),20,' ')||'|' "Graph",
round(tbm.USED_PERCENT,2) "Pct_Usado", 
round((tbm.TABLESPACE_SIZE*tb.block_size)/1024/1024/1024,2) "TamanhoMaximoGB", 
round((df.bytes_alloc)/1024/1024/1024,2) "TamanhoAlocadoGB", 
round((tbm.used_space*tb.block_size)/1024/1024/1024,2) "EspacoUtilizadoGB", 
round(((tbm.TABLESPACE_SIZE-tbm.used_space)*tb.block_size)/1024/1024/1024,2) "LivreGB",
case
    when tbm.USED_PERCENT > 80 then round(round((tbm.used_space*tb.block_size)/1024/1024/1024,2)-(round((tbm.TABLESPACE_SIZE*tb.block_size)/1024/1024/1024,2) * 0.7999),1)
    else null
end "Suggest",
tot_files,nvl(tot_segs,0) "TotalSegs",  tb.bigfile, tb.status
FROM
    dba_tablespace_usage_metrics   tbm
,   dba_tablespaces                tb
,   (    SELECT f.tablespace_name, count(1) tot_files,
                            SUM (f.bytes) bytes_alloc,
                            SUM (
                               case
                               when  f.autoextensible = 'YES' and  f.maxbytes >  f.bytes then  f.maxbytes
                               else  f.bytes end)
                               maxbytes
                       FROM dba_data_files f
                   GROUP BY tablespace_name
    ) df ,
    (
    select tablespace_name, count(1) tot_segs
from dba_segments
group by tablespace_name
    ) sg
where tb.tablespace_name = tbm.tablespace_name
and tb.tablespace_name = df.tablespace_name
and tb.tablespace_name = sg.tablespace_name(+)
and tb.tablespace_name = '&1'
union all
select  
tb.tablespace_name, 
    '|'||rpad(lpad('#',ceil((1-nvl((((tbm.TABLESPACE_SIZE-tbm.used_space)*tb.block_size)),0)/decode((tbm.TABLESPACE_SIZE*tb.block_size),0,1,(tbm.TABLESPACE_SIZE*tb.block_size)))*20),'#'),20,' ')||'|' "Graph",
round(tbm.USED_PERCENT,2) "Pct_Usado", 
round((tbm.TABLESPACE_SIZE*tb.block_size)/1024/1024/1024,2) "TamanhoMaximo", 
round((df.bytes_alloc)/1024/1024/1024,2) "TamanhoAlocado", 
round((tbm.used_space*tb.block_size)/1024/1024/1024,2) "EspacoUtilizado", 
round(((tbm.TABLESPACE_SIZE-tbm.used_space)*tb.block_size)/1024/1024/1024,2) "Livre",
case
    when tbm.USED_PERCENT > 80 then round(round((tbm.used_space*tb.block_size)/1024/1024/1024,2)-(round((tbm.TABLESPACE_SIZE*tb.block_size)/1024/1024/1024,2) * 0.7999),1)
    else null
end "Suggest",
tot_files,0,  tb.bigfile, tb.status
FROM
    dba_tablespace_usage_metrics   tbm
,   dba_tablespaces                tb
,   (    SELECT f.tablespace_name, count(1) tot_files,
                            SUM (f.bytes) bytes_alloc,
                            SUM (
                               case
                               when  f.autoextensible = 'YES' and  f.maxbytes >  f.bytes then  f.maxbytes
                               else  f.bytes end)
                               maxbytes
                       FROM dba_temp_files f
                   GROUP BY tablespace_name
    ) df 
where tb.tablespace_name = tbm.tablespace_name
and tb.tablespace_name = df.tablespace_name
and tb.tablespace_name = '&1'
order by 3;