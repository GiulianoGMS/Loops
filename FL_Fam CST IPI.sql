DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQFAMILIA FROM CONSINCO.MAP_FAMILIA XX WHERE NVL(XX.SITUACAONFIPISAI,0) NOT IN (50,53))
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAP_FAMILIA X SET X.SITUACAONFIPISAI = 53 ,
                                          X.USUARIOALTERACAO = 'TKT339895',
                                          X.DTAHORALTERACAO  = SYSDATE
                                          
                                    WHERE X.SEQFAMILIA = T.SEQFAMILIA;
      IF i = 1000 THEN COMMIT;
      i := 0;
      END IF;
      
      END;
     END LOOP;
    COMMIT;
   END;
   
