CREATE TABLE CONSINCO.NAGT_BACKUP_545841 AS

SELECT * FROM MAP_PAUTAUFLOG A
             WHERE 1=1
               AND DTAFIM = DATE '2025-02-28';

BEGIN
  FOR t IN (SELECT * FROM MAP_PAUTAUFLOG A
             WHERE 1=1
               AND DTAFIM = DATE '2025-02-28')
               
  LOOP
    UPDATE MAP_PAUTAUFLOG X SET X.DTAFIM = DATE '2050-12-31',
                                X.USUALTERACAO = 'TKT545841',
                                X.DTAALTERACAO = SYSDATE
                          WHERE X.SEQPAUTAUFLOG = T.SEQPAUTAUFLOG
                            AND X.SEQPAUTA = T.SEQPAUTA
                            AND X.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO
                            AND X.UFORIGEM = T.UFORIGEM
                            AND X.UFDESTINO = T.UFDESTINO
                            AND X.DTAINICIO = T.DTAINICIO;
                            
   END LOOP;
   
END;
       
SELECT * FROM MAP_PAUTAUFLOG A
             WHERE 1=1
               AND (DTAFIM = DATE '2025-02-28')
