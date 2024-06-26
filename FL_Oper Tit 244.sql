ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

BEGIN
  FOR leo IN (SELECT *
                FROM FI_TITULO XI
               WHERE CODESPECIE IN ('IFOOD')
                 AND NROTITULO BETWEEN 20240417 AND 20240421
                 AND NROEMPRESA = 1
                 AND XI.PERCADMINISTRACAO = 8)
                  
                 LOOP
                                      
UPDATE FI_TITULO XX SET XX.VLRPAGO = LEO.VLRPAGO + (SELECT SUM(XI.VLRORIGINAL) FROM FI_TITULO XI WHERE CODESPECIE IN ('VOIFOO') AND NROTITULO = LEO.NROTITULO AND NROEMPRESA = LEO.NROEMPRESA)
                  WHERE XX.SEQTITULO = LEO.SEQTITULO;
                 
INSERT INTO FI_TITOPERACAO X (SELECT (SELECT MAX(SEQTITOPERACAO) +1 FROM FI_TITOPERACAO),
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
                                     (SELECT MAX(NROPROCESSO) +1 FROM FI_TITOPERACAO),
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

-- Deletando duplicidades

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

DECLARE
  vsSEQTITOPERACAO NUMBER;

BEGIN
  FOR leo IN (SELECT *
                FROM FI_TITULO XI
               WHERE CODESPECIE IN ('IFOOD')
                 AND NROTITULO BETWEEN 20240422 AND 20240424
                 AND NROEMPRESA = 1
                 AND XI.PERCADMINISTRACAO = 8)
                  
                 LOOP
                   
       SELECT MAX(SEQTITOPERACAO)    
       INTO vsSEQTITOPERACAO
       FROM FI_TITOPERACAO FP 
       WHERE FP.SEQTITULO = LEO.SEQTITULO
       AND CODOPERACAO = 244;
                 
UPDATE FI_TITULO XX SET XX.VLRPAGO = LEO.VLRPAGO - (SELECT SUM(XI.VLRORIGINAL) FROM FI_TITULO XI WHERE CODESPECIE IN ('VOIFOO') AND NROTITULO = LEO.NROTITULO AND NROEMPRESA = LEO.NROEMPRESA)
                  WHERE XX.SEQTITULO = LEO.SEQTITULO;
                  
DELETE FROM FI_TITOPERACAO FI WHERE SEQTITOPERACAO = vsSEQTITOPERACAO AND FI.SEQTITULO = LEO.SEQTITULO;
      
            END LOOP;
            
END;

/*SELECT SEQTITULO, VLRORIGINAL, VLRPAGO FROM FI_TITULO XX WHERE NROTITULO = 20240416 AND NROEMPRESA = 21 AND CODESPECIE = 'IFOOD' AND PERCADMINISTRACAO = 8;
SELECT * FROM FI_TITOPERACAO X WHERE SEQTITULO = 1062538033;*/

-- Conferindo

SELECT *
  FROM FI_TITOPERACAO XI
 WHERE EXISTS (SELECT SEQTITULO, COUNT(3)
          FROM FI_TITOPERACAO X
         WHERE CODOPERACAO = 244
           AND X.DTAOPERACAO > SYSDATE - 2
         GROUP BY SEQTITULO
        HAVING COUNT(3) = 2 AND XI.SEQTITULO = X.SEQTITULO)
   AND CODOPERACAO = 244
   AND XI.DTAOPERACAO > SYSDATE - 2
