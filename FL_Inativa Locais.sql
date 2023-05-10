DECLARE 
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (

    SELECT DISTINCT Z.SEQLOCAL, Z.NROEMPRESA, LOCAL, STATUS FROM MRL_LOCAL Z LEFT JOIN MRL_PRODLOCAL Y ON Z.SEQLOCAL = Y.SEQLOCAL AND Z.NROEMPRESA = Y.NROEMPRESA
    WHERE STATUS = 'A' AND Y.ESTOQUE = 0 AND 
    LOCAL NOT IN ('LOJA','AVARIA','OCORRENCIAS','TRANSFORMACAO PACKS', 'CESTA') AND Z.NROEMPRESA < 100
 
             )
             
     LOOP
       BEGIN
         i := 1+1;
         UPDATE MRL_LOCAL X SET STATUS = 'I' WHERE X.SEQLOCAL = T.SEQLOCAL
                                               AND X.NROEMPRESA = T.NROEMPRESA;
                                                    
         IF i = 10 THEN COMMIT;
         i := 0;
         END IF;
         
         EXCEPTION
           WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('ERRO - Local possúi saldo: '||T.SEQLOCAL||' - '||T.LOCAL||' - '||T.NROEMPRESA);
         END;
     END LOOP;
    COMMIT;
   END;
