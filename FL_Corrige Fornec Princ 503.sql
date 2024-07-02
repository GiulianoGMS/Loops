ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

BEGIN
  -- Tira os principais que nao sao 503
  FOR t IN (
SELECT *
  FROM MAP_FAMFORNEC X
 WHERE EXISTS (SELECT 1 FROM MAP_FAMFORNEC A 
                       WHERE A.SEQFORNECEDOR = 503
                         AND A.SEQFAMILIA = X.SEQFAMILIA) -- 503
   AND NOT EXISTS (SELECT 1 FROM MAP_FAMFORNEC A 
                           WHERE A.SEQFORNECEDOR = 503 
                           AND A.SEQFAMILIA = X.SEQFAMILIA
                           AND A.SEQFORNECEDOR = X.SEQFORNECEDOR
                           AND A.PRINCIPAL = 'S')
   AND PRINCIPAL = 'S')
   
   LOOP
     UPDATE MAP_FAMFORNEC Z SET Z.PRINCIPAL = 'N',
                                Z.USUARIOALTERACAO = '503PRINC'
                          WHERE Z.SEQFAMILIA = T.SEQFAMILIA;
                          
   COMMIT;
   END LOOP;
   -- Adiciona a 503 como principal
   FOR t2 IN (
SELECT *
  FROM MAP_FAMFORNEC X
 WHERE EXISTS (SELECT 1 FROM MAP_FAMFORNEC A 
                       WHERE A.SEQFORNECEDOR = 503
                         AND A.SEQFAMILIA = X.SEQFAMILIA)
   AND SEQFORNECEDOR = 503
   AND NVL(PRINCIPAL,'N') != 'S')
   
   LOOP
     UPDATE MAP_FAMFORNEC Z SET Z.PRINCIPAL = 'S',
                                Z.USUARIOALTERACAO = '503PRINC'
                          WHERE Z.SEQFAMILIA = T2.SEQFAMILIA
                            AND Z.SEQFORNECEDOR = T2.SEQFORNECEDOR;
  
   COMMIT;

   END LOOP;
  
   END;
