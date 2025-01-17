-- Ticket 493362
-- Regra 2

BEGIN
  DECLARE i INTEGER := 0;

BEGIN
  FOR T IN (SELECT CODACESSO
              FROM MAP_PRODCODIGO X
             WHERE 1=1 --X.TIPCODIGO != 'E'
               AND X.INDEANTRIBNFE = 'S'
               AND X.INDUTILVENDA = 'S'
               AND X.QTDEMBALAGEM > 1
               AND EXISTS (SELECT 1 FROM MAP_PRODCODIGO Z 
                                   WHERE Z.INDEANTRIBNFE = 'S' 
                                     AND INDUTILVENDA = 'S'
                                     AND QTDEMBALAGEM = 1 
                                     AND Z.SEQPRODUTO = X.SEQPRODUTO))
  LOOP
    BEGIN
      i := i+1;
      UPDATE MAP_PRODCODIGO X SET X.INDEANTRIBNFE = 'N',
                                  X.USUARIOALTERACAO = 'TKT493362',
                                  X.DATAHORAALTERACAO = SYSDATE
                            WHERE X.CODACESSO = T.CODACESSO;
      IF i = 100 THEN COMMIT;
      i := 0;
      END IF;
    END;
  END LOOP;
 COMMIT;
END;
END;         
