-- Altera Fornec Princ 503 para 502

DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQFAMILIA FROM MAP_FAMFORNEC Z WHERE Z.SEQFORNECEDOR = 503 AND Z.PRINCIPAL = 'S')
          
        LOOP
          BEGIN
            i := i+1;
            UPDATE MAP_FAMFORNEC Z SET Z.PRINCIPAL = 'N' WHERE SEQFAMILIA = T.SEQFAMILIA 
                                                           AND Z.SEQFORNECEDOR = 503
                                                           AND Z.PRINCIPAL = 'S';
            UPDATE MAP_FAMFORNEC Z SET Z.PRINCIPAL = 'S' WHERE SEQFAMILIA = T.SEQFAMILIA 
                                                           AND Z.SEQFORNECEDOR = 502
                                                           AND Z.PRINCIPAL = 'N';
          
           IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      END;
     END LOOP;
    COMMIT;
   END;
                                                           
                                                           
