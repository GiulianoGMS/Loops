DECLARE 
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (

    SELECT SEQLOCAL, NROEMPRESA, LOCAL, STATUS FROM MRL_LOCAL WHERE STATUS = 'A' AND 
    LOCAL NOT IN ('LOJA','AVARIA','OCORRENCIAS','TRANSFORMACAO PACKS', 'CESTA') 
 
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
