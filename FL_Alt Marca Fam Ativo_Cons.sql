DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQPRODUTO, X.SEQFAMILIA, DESCCOMPLETA, M.MARCA, M.SEQMARCA
                    FROM CONSINCO.MAP_PRODUTO X INNER JOIN CONSINCO.MAP_FAMILIA Z ON X.SEQFAMILIA = Z.SEQFAMILIA 
                                                INNER JOIN CONSINCO.MAP_MARCA   M ON M.SEQMARCA   = Z.SEQMARCA
                   WHERE 1 = 1 
                     -- X.DESCCOMPLETA LIKE '%USO ATIV%' AND M.SEQMARCA != 5953
                     AND X.DESCCOMPLETA LIKE '%USO CONS%' AND M.SEQMARCA != 5077
                      
                  ORDER BY DESCCOMPLETA )
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAP_FAMILIA X SET SEQMARCA = 5077
                                    WHERE X.SEQFAMILIA = T.SEQFAMILIA;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQFAMILIA);
      END;
     END LOOP;
    COMMIT;
   END;
