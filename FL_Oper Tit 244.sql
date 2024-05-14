ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

BEGIN
  FOR leo IN (SELECT *
                FROM FI_TITULO XI
               WHERE CODESPECIE IN ('IFOOD')
                 AND NROTITULO = 20240417
                 AND NROEMPRESA = 1
                 AND XI.PERCADMINISTRACAO = 8)
                  
                 LOOP
                                      
UPDATE FI_TITULO XX SET XX.VLRPAGO = LEO.VLRPAGO + (SELECT SUM(XI.VLRORIGINAL) FROM FI_TITULO XI WHERE CODESPECIE IN ('VOIFOO') AND NROTITULO = LEO.NROTITULO AND NROEMPRESA = LEO.NROEMPRESA)
                  WHERE XX.SEQTITULO = LEO.SEQTITULO;
                 
INSERT INTO FI_TITOPERACAO X (SELECT (SELECT MAX(X.SEQTITOPERACAO) +1 FROM FI_TITOPERACAO),
                                     X.SEQLANCTO,
                                     X.CODOPERACAO,
                                     LEO.SEQTITULO,
                                     SYSDATE,
                                     SYSDATE,
                                     (SELECT SUM(XI.VLRORIGINAL) 
                                        FROM FI_TITULO XI 
                                       WHERE CODESPECIE IN ('VOIFOO') 
                                         AND NROTITULO = LEO.NROTITULO 
                                         AND NROEMPRESA = LEO.NROEMPRESA),
                                     X.COLOPERACAO1,
                                     LEO.NRODOCUMENTO,
                                     X.OBSERVACAO,
                                     X.OBSERVACAO,
                                     X.TIPOASSUMIDO,
                                     X.SEQCTACORRENTE,
                                     (SELECT MAX(X.NROPROCESSO) +1 FROM FI_TITOPERACAO),
                                     X.DTACONCILIACAO,
                                     X.USUCONCILIOU,
                                     X.SITUACAO,
                                     X.DTAQUITACAOANT,
                                     X.OPCANCELADA,
                                     X.USUCANCELOU,
                                     X.DTACANCELOU,
                                     X.JUSTCANCEL,
                                     X.CODESPECIEANT,
                                     SYSDATE,
                                     'CRM_SM',
                                     X.NROEMPRCTAPARTIDA,
                                     SYSDATE,
                                     X.SEQTITDESCONTO,
                                     X.ORIGEM,
                                     X.DTAHORACANCELOU,
                                     X.USUARIOSO,
                                     X.IP,
                                     X.MAQUINA,
                                     X.MODULO,
                                     X.INDESOCIAL,
                                     X.SEQDEPOSITARIO,
                                     NULL 
                                   
                                     FROM CONSINCO.FI_TITOPERACAO X WHERE SEQTITULO = 1062290186 AND CODOPERACAO = 244 AND VLROPERACAO = 23.98);
                                     
            COMMIT;
      
            END LOOP;
            
END;
