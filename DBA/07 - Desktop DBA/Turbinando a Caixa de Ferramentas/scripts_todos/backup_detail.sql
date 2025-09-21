------------------------------------------------------------------------------
-- Criado por: Marcio Mandarino
-- www.mrdba.com.br
-- Descricao: Exibe informacoes detalhadas de um backup especifico. 
-- Compatibilidae: Oracle 10g em diante
-- Ex. @backup_detail recid stamp  (Exibe os detalhes do backup)
------------------------------------------------------------------------------


col handle form a100
col status form a15
col SIZE_BYTES_DISPLAY form a20
col tag form a30
col DEVICE_TYPE form a20


SELECT
    session_recid,
    session_stamp,
    device_type,
    tag,
    status,
    start_time,
    completion_time,
	  FLOOR (ROUND ( ( (completion_time - START_TIME ) * 1440), 2) / 60 )
         || 'h'
         || TRUNC (MOD (ROUND ( ( (completion_time - START_TIME ) * 1440), 2), 60))
         || 'min'
            tempo ,
    deleted,
    compressed,
    size_bytes_display,
    handle
FROM
    v$backup_piece_details
WHERE
    session_recid = &1
    AND session_stamp = &2
ORDER BY start_time;
