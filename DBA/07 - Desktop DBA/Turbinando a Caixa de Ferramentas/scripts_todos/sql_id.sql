------------------------------------------------------------------------------
-- Criado por: Tanel Poder
-- www.mrdba.com.br
-- Descricao: Extrai o SQL a partir de um SQL_ID
-- Compatibilidae: Oracle 10g em diante
-- Ex. @sql_id SQLID
------------------------------------------------------------------------------


------------------------------------------------------------------------------
--
-- Copyright 2017 Tanel Poder ( tanel@tanelpoder.com | http://tanelpoder.com )
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
------------------------------------------------------------------------------

col sql_sql_text head SQL_TEXT format a850 word_wrap
col sql_child_number head "CH#" for 999

SET VERIFY OFF

prompt Show SQL text, child cursors and execution stats for SQLID &1 child &2

 select 
		sql_text sql_sql_text
from 
	dba_hist_sqltext
where 
	sql_id = ('&1')
order by
	sql_id
/



select * from TABLE(dbms_xplan.display_awr('&1'));


SET VERIFY ON