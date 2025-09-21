------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Executa o Sql Tuning Advisor para um sql_id especifico 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @adv_sql sql_id | executa o Sql Tuning advisor para uma query id  
------------------------------------------------------------------------------


set verify off

Prompt "Creating Task AdviceSQL_&1..." 


-- column TASK_NAME new_value p_task
-- select to_char(sysdate,'DD')||'_&1' TASK_NAME from dual;



DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_id      => '&1',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 800,
                          task_name   => 'AdviceSQL_&1',
                          description => 'Tuning task1 for statement &1');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

Prompt "Executing Task AdviceSQL_&1..." 

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => 'AdviceSQL_&1'); 


col task_name form a30

Prompt "Status of Tasking"
select task_id,task_name, status from dba_advisor_tasks where task_name = 'AdviceSQL_&1';


Prompt "Recomendation..." 

SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
col recomandation form a200
select dbms_sqltune.report_tuning_task('AdviceSQL_&1') recomandation from dual;

set verify on


PROMPT "For deleting task:  EXEC DBMS_ADVISOR.DELETE_TASK('AdviceSQL_&1');"
