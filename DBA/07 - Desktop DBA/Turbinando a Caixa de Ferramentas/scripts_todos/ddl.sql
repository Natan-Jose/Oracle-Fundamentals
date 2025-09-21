------------------------------------------------------------------------------
-- Criado por: Tanel Poder
-- www.mrdba.com.br
-- Descricao: Extrai o DDL do objeto 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @ddl OWNER.OBJECT_NAME
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

--------------------------------------------------------------------------------
--
-- File name:   ddl.sql
-- Purpose:     Extracts DDL statements for specified objects
--
-- Author:      Tanel Poder
-- Copyright:   (c) http://www.tanelpoder.com
--              
-- Usage:       @ddl [schema.]<object_name_pattern>
-- 	        @ddl mytable
--	        @ddl system.table
--              @ddl sys%.%tab%
--
--------------------------------------------------------------------------------

SET VERIFY OFF

SET LONG 900000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON

BEGIN
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SQLTERMINATOR', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'PRETTY', true);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'SEGMENT_ATTRIBUTES', false);
   DBMS_METADATA.set_transform_param (DBMS_METADATA.session_transform, 'STORAGE', false);

END;
/



select
     dbms_metadata.get_ddl(
        CASE
            WHEN object_type = 'MATERIALIZED VIEW'  THEN 'MATERIALIZED_VIEW'
            WHEN object_type = 'DATABASE LINK'      THEN 'DB_LINK'
            ELSE object_type
        END, object_name, owner) 
from 
	dba_objects 
where 
    object_type NOT LIKE '%PARTITION' AND object_type NOT LIKE '%BODY'
AND	upper(object_name) LIKE 
				upper(CASE 
					WHEN INSTR('&1','.') > 0 THEN 
					    SUBSTR('&1',INSTR('&1','.')+1)
					ELSE
					    '&1'
					END
				     )
AND	owner LIKE
		CASE WHEN INSTR('&1','.') > 0 THEN
			UPPER(SUBSTR('&1',1,INSTR('&1','.')-1))
		ELSE
			user
		END
/



SET PAGESIZE 14 LINESIZE 1000 FEEDBACK ON VERIFY ON

SET VERIFY ON