--Backup na MRL_PRODUTOEMPRESA_BACKUP_LOC

DECLARE 
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (

    SELECT SEQPRODUTO, NROEMPRESA
      FROM CONSINCO.MRL_PRODUTOEMPRESA A 
     WHERE A.LOCENTRADA != (SELECT SEQLOCAL FROM CONSINCO.MRL_LOCAL L1 WHERE L1.LOCAL = 'LOJA' AND L1.NROEMPRESA = A.NROEMPRESA) AND A.NROEMPRESA < 100
        OR A.LOCSAIDA   != (SELECT SEQLOCAL FROM CONSINCO.MRL_LOCAL L2 WHERE L2.LOCAL = 'LOJA' AND L2.NROEMPRESA = A.NROEMPRESA) AND A.NROEMPRESA < 100
 
             )
             
     LOOP
       BEGIN
         i := 1+1;
         UPDATE CONSINCO.MRL_PRODUTOEMPRESA X SET X.LOCENTRADA = (SELECT SEQLOCAL FROM CONSINCO.MRL_LOCAL L3 WHERE L3.LOCAL = 'LOJA' AND L3.NROEMPRESA = T.NROEMPRESA), -- Busca Seqlocal LOJA decada empresa
                                                  X.LOCSAIDA   = (SELECT SEQLOCAL FROM CONSINCO.MRL_LOCAL L3 WHERE L3.LOCAL = 'LOJA' AND L3.NROEMPRESA = T.NROEMPRESA)  -- Busca Seqlocal LOJA decada empresa
                                                  WHERE X.SEQPRODUTO = T.SEQPRODUTO
                                                    AND X.NROEMPRESA = T.NROEMPRESA;
                                                    
         IF i = 10 THEN COMMIT;
         i := 0;
         END IF;
         
         EXCEPTION
           WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQPRODUTO);
         END;
     END LOOP;
    COMMIT;
   END;
