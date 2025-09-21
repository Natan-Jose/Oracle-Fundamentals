------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Faz uma serie de ajuses de parametros
-- Compatibilidae: Oracle 10g em diante
-- Ex. @init
------------------------------------------------------------------------------

set feedback off
def SQLPATH=""
def SQLPATH=%SQLPATH%
def tempdir=%SQLPATH%\tmp
def _EDITOR="C:\Program Files\Sublime Text\sublime_text.exe"
alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
set feedback on

set linesize 999
set pagesize 5000
set arraysize 100
set verify off
set trimspool on
set trimout on
set tab off


col owner           for a30 wrap
col object_name     for a30 wrap
col segment_name    for a30 wrap
col username        for a20 wrap
col instance_name   for a20 wrap
col host_name       for a20 wrap

set sqlprompt "&_user@&_connect_identifier> "