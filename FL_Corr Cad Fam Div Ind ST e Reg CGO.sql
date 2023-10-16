CREATE TABLE CONSINCO.NAGT_MAP_FAMDIVISAO_BKP_INDCGO AS

SELECT F.SEQFAMILIA, F.INDMERCENQUADST, F.INDUSADADOSREGCGO

  FROM  CONSINCO.MAP_FAMDIVISAO F
                     INNER JOIN CONSINCO.MAP_FAMILIA Z ON F.SEQFAMILIA =Z.SEQFAMILIA

 WHERE 1=1 
   AND (NVL(F.INDMERCENQUADST, 'X') != 'S'
    OR NVL(F.INDUSADADOSREGCGO, 'X') != 'S')
    
   --=================--
   
DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT F.SEQFAMILIA, F.INDMERCENQUADST, F.INDUSADADOSREGCGO
                  FROM  CONSINCO.MAP_FAMDIVISAO F
                                     INNER JOIN CONSINCO.MAP_FAMILIA Z ON F.SEQFAMILIA =Z.SEQFAMILIA

                 WHERE 1=1 
                   AND (NVL(F.INDMERCENQUADST, 'X') != 'S'
                    OR NVL(F.INDUSADADOSREGCGO, 'X') != 'S')
                    )
       LOOP
         BEGIN
           i := i+1;
       UPDATE CONSINCO.MAP_FAMDIVISAO X SET X.INDMERCENQUADST   = 'S',
                                            X.INDUSADADOSREGCGO = 'S',
                                            X.USUARIOALTERACAO  = 'TKT300360',
                                            X.DTAHORALTERACAO   =  SYSDATE
                                     
        WHERE 1=1 
          AND T.SEQFAMILIA = X.SEQFAMILIA; 
          IF i = 10 THEN COMMIT;
          i := 0;
          END IF;
          
         END;
       END LOOP;
   COMMIT;
 END;
    
