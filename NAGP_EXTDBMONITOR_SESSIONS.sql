CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_EXTDBMONITOR_SESSIONS as

   v_file UTL_FILE.file_type;
   v_output VARCHAR2(4000); 
   
BEGIN
   -- Remove o arquivo anterior
   UTL_FILE.fremove('/u02/app_acfs/arquivos/AdmGi - Data', 'dbdata_sessions.TXT');
   
   -- Abre o arquivo para gravação 
   v_file := UTL_FILE.fopen('/u02/app_acfs/arquivos/AdmGi - Data', 'dbdata_sessions.TXT', 'w');

   -- Dados para extracao
   FOR rec IN (SELECT X.FIRSTROW,
       X.SESSION_USERNAME,
       X.SID,
       X.SERIAL#,
       X.AMBIENTE,
       X.AUDSID,
       X.SPID,
       X.TIP_SV,
       X.COL_ND,
       X.COL_ND1,
       X.COL_ND2,
       X.COL_ND3,
       X.COL_ND4,
       X.SESSION_TIME,
       X.INST_ID,
       X.STATUS,
       X.COL_ND5,
       X.PROCESS_DESC,
       X.USUARIO_OS,
       X.TERMINAL_OS,
       X.PROGRAMA,
       X.LOGON_TIME,
       X.CLIENT_INFO,
       X.CLIENT_IDENTIFIER,
       X.JOB_NAME,
       X.ACTION,
       X.CLIENT_VERSION,
       X.CHARSET
  FROM CONSINCO.NAGV_DBMONITOR X) LOOP
      -- Constroi a linha de texto a ser gravada no arquivo
      v_output := rec.FIRSTROW||';'||
                  rec.SESSION_USERNAME||';'||
                  rec.SID||';'||
                  rec.SERIAL#||';'||
                  rec.AMBIENTE||';'||
                  rec.AUDSID||';'||
                  rec.SPID||';'||
                  rec.TIP_SV||';'||
                  rec.COL_ND||';'||
                  rec.COL_ND1||';'||
                  rec.COL_ND2||';'||
                  rec.COL_ND3||';'||
                  rec.COL_ND4||';'||
                  rec.SESSION_TIME||';'||
                  rec.INST_ID||';'||
                  rec.STATUS||';'||
                  rec.COL_ND5||';'||
                  rec.PROCESS_DESC||';'||
                  rec.USUARIO_OS||';'||
                  rec.TERMINAL_OS||';'||
                  rec.PROGRAMA||';'||
                  rec.LOGON_TIME||';'||
                  rec.CLIENT_INFO||';'||
                  rec.CLIENT_IDENTIFIER||';'||
                  rec.JOB_NAME||';'||
                  rec.ACTION||';'||
                  rec.CLIENT_VERSION||';'||
                  rec.CHARSET;

      -- Escreve a linha no arquivo
      UTL_FILE.put_line(v_file, v_output);
   END LOOP;

   -- Fecha o arquivo
   UTL_FILE.fclose(v_file);
EXCEPTION
  WHEN OTHERS THEN

      DBMS_OUTPUT.put_line('Erro: ' || SQLERRM);
      IF UTL_FILE.is_open(v_file) THEN
         UTL_FILE.fclose(v_file);
      END IF;
END;

