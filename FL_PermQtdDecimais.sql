ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

-- Correcao TKT394161 

DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT DISTINCT SEQFAMILIA 
                    FROM MAP_FAMILIA Z 
                   WHERE NVL(Z.PESAVEL, 'N') = 'N'
                     AND Z.PMTDECIMAL = 'S')
    LOOP
      BEGIN
        i := i+1;
        UPDATE MAP_FAMILIA X SET X.PMTDECIMAL = 'N',
                                 X.USUARIOALTERACAO = 'TKT394161',
                                 X.DTAHORALTERACAO = SYSDATE
                                 
                           WHERE X.SEQFAMILIA = t.SEQFAMILIA
                             AND NVL(X.PESAVEL, 'N') = 'N'
                             AND X.PMTDECIMAL = 'S'; 
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||t.SEQFAMILIA);
      END;
     END LOOP;
    COMMIT;
 
 END;
   
   -- Validando
   
   SELECT COUNT(1)FROM MAP_FAMILIA Z 
                 WHERE NVL(Z.PESAVEL, 'N') = 'N'
                   AND Z.PMTDECIMAL = 'S';
