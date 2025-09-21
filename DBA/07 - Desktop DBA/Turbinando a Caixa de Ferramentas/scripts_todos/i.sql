------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes sobre a sua sessao
-- Compatibilidae: Oracle 10g em diante
-- Ex. @i
------------------------------------------------------------------------------

col sid form a6
col serial form a8
col version form a20
col startup_day form a20
col username form a20
col host_name form a30
col instance_name form a15

SELECT
    s.username                                     username,
    (CASE WHEN TO_NUMBER(SUBSTR(i.version, 1, instr(i.version,'.',1)-1)) >= 12 THEN (SELECT SYS_CONTEXT('userenv', 'con_name') FROM dual)||'-'||i.instance_name ELSE i.instance_name END) instance_name, 
    i.host_name                                    host_name,
    i.instance_number                              inst,
    to_char(s.sid)                                 sid,
    to_char(s.serial#)                             serial,
    (SELECT substr(banner, instr(banner, 'Release ') + 8, 10) FROM v$version WHERE ROWNUM = 1 )  version,
    to_char(startup_time, 'DD/MM/RRRR HH24:MI:SS') startup_day
FROM
    v$session  s,
    v$instance i
WHERE
    sid = (SELECT sid  FROM v$mystat WHERE ROWNUM = 1 );


host title &_user@&_connect_identifier