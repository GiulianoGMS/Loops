DECLARE 
    i INTEGER := 0;
BEGIN
  FOR emp IN (SELECT NROEMPRESA FROM MAX_EMPRESA X WHERE NROEMPRESA < 100)
    LOOP
      FOR dia IN (SELECT DTA DIA FROM DIM_TEMPO X WHERE DTA BETWEEN DATE '2025-01-01' AND SYSDATE)
        LOOP
          FOR insr IN (SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
                                X.DTAESTOQUE DTA,
                                X.NROEMPRESA LOJA, SEQPRODUTO SKU, 
                                NAGF_PRECO_DIA_X_TIPO(X.NROEMPRESA, X.SEQPRODUTO, E.NROSEGMENTOPRINC, 1, X.DTAESTOQUE, 'N') PRECO_DE,
                                NAGF_PRECO_DIA_X_TIPO(X.NROEMPRESA, X.SEQPRODUTO, E.NROSEGMENTOPRINC, 1, X.DTAESTOQUE, 'P') PRECO_PARA
                              
                           FROM FATO_ESTOQUE X INNER JOIN MAX_EMPRESA E ON E.NROEMPRESA = X.NROEMPRESA
                          WHERE X.NROEMPRESA = emp.NROEMPRESA
                            AND DTAESTOQUE = dia.DIA
                            AND NAGF_PRECO_DIA_X_TIPO(X.NROEMPRESA, X.SEQPRODUTO, E.NROSEGMENTOPRINC, 1, X.DTAESTOQUE, 'P') > 0)
            LOOP
              INSERT INTO NAGT_BASE_PRECODIA VALUES (insr.DTA, insr.LOJA, insr.SKU, insr.PRECO_DE, insr.PRECO_PARA);
            i := i + 1;
            IF i = 100 THEN -- Define o Commit por quantidade de linhas
              COMMIT;
               i := 0;
            END IF;
              COMMIT;
            END LOOP;
         END LOOP;
       END LOOP;
     COMMIT;
   END;
   
SELECT COUNT(1), MAX(DTA) FROM NAGT_BASE_PRECODIA;

TRUNCATE TABLE NAGT_BASE_PRECODIA

CREATE INDEX idx_precodia_dta_loja
    ON nagt_base_precodia (dta, loja);

SELECT TO_CHAR(DTA, 'DD/MM/YYYY') DTA,
       LOJA, SKU, 
       PRECO_DE,
       PRECO_PARA
                              
 FROM NAGT_BASE_PRECODIA
WHERE 1=1
