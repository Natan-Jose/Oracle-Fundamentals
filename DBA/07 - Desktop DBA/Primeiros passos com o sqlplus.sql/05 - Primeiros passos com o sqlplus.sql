Referência: https://docs.oracle.com/en/database/oracle/oracle-database/19/sqpug/using-SQL-Plus.html#GUID-2A2C72F4-2B92-4432-92A2-C1B642451F66

=======================================================
== Easy Connect
=======================================================
sqlplus system/"Wellcome1"@//192.168.68.128:1521/pdb1


=======================================================
== Comando DESC
=======================================================
SQL> desc emp


=======================================================
== Comando show user
=======================================================
SQL> show user;


=======================================================
== Formatando as colunas
=======================================================
SQL> select owner,object_name, created, object_type from dba_objects
where object_type = 'TABLE'
and owner = 'MDSYS';

SQL> col owner form a10
SQL> col object_name form a30

-- 
SQL> COLUMN SAL FORMAT $99,999 HEADING 'MONTHLY SALARY'
SQL> SELECT EMPNO,  SAL FROM emp WHERE SAL > 1200;

-- Limpando a formatação das colunas
SQL> clear columns  


=======================================================
== Formatando a tela
=======================================================
SQL> set lines 200
SQL> set pagesize 80
SQL> set heading ON
SQL> set feedback ON
SQL> set trimspool ON
SQL> set timing on
SQL> set time on
SQL> set sqlprompt "SQL_PROD> "


select owner,object_name, created, object_type from dba_objects
where object_type = 'TABLE'
and owner = 'MDSYS';

=======================================================
== Limpando a tela
=======================================================
SQL> clear screen
SQL> cl scr


=======================================================
== Variáveis
=======================================================
SQL> SELECT EMPNO,  SAL,JOB FROM emp WHERE EMPNO = 7839;
SQL> SELECT EMPNO,  SAL FROM emp WHERE EMPNO = &X;
Enter value for X:  20


SQL> ACCEPT MYJOB PROMPT 'JOB: '
SQL> SELECT EMPNO,  SAL,JOB FROM emp WHERE JOB = '&MYJOB';


=======================================================
== Listando a última query
=======================================================
SQL> list
SQL> l

=======================================================
== Executando última query
=======================================================
SQL> run
SQL> /

=======================================================
== Incluindo linhas na última query
=======================================================
SQL> include order by 1
SQL> i 

=======================================================
== Excluindo linhas na última query
=======================================================
SQL> del 


=======================================================
== Executando scripts no sqlplus
=======================================================
@caminho/arquivo.sql

-- Executando um script que esteja dentro do caminho da variável SQLPATH
@script.sql


=======================================================
== Gerando log
=======================================================
spool caminho/arquivo.log

spool off