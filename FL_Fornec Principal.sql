ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Retorna os ajustes feito pela Flaviane no campo PRINCIPAL na MAP_FAMFORNEC no dia 28/02/2024

BEGIN
  
  FOR t IN (SELECT SEQIDENTIFICA SEQFAMILIA, VLRANTERIOR, VLRATUAL, USUAUDITORIA, IDENTIFICADOR, SUBSTR(IDENTIFICADOR, 9) FORNEC
              FROM MAP_AUDITORIA X
             WHERE X.DTAAUDITORIA = DATE '2024-02-28'
               AND USUAUDITORIA = 'FSFBARRETO'
               AND CAMPO = 'PRINCIPAL' 
               --AND SEQIDENTIFICA = 14230
               AND VLRANTERIOR = 'S')
               
  LOOP
    UPDATE MAP_FAMFORNEC C SET C.PRINCIPAL  = 'N'
                         WHERE C.SEQFAMILIA = T.SEQFAMILIA
                           AND C.PRINCIPAL  = 'S';
    UPDATE MAP_FAMFORNEC D SET D.PRINCIPAL  = 'S'
                         WHERE D.SEQFAMILIA = T.SEQFAMILIA
                           AND D.SEQFORNECEDOR = T.FORNEC
                           AND D.PRINCIPAL = 'N';
                           
  COMMIT;
  
  END LOOP;
  
END;

SELECT * FROM MAP_FAMFORNEC Z WHERE SEQFAMILIA = 14230
