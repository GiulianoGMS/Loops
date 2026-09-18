-- Bkp

CREATE TABLE NAGT_BKP_MRL_PRODUTOEMPRESA_NEG AS 
SELECT * FROM MRL_PRODUTOEMPRESA X WHERE X.QTDRESERVADAVDA < 0;

-- Correcao do soluço

DECLARE
  i INTEGER := 0;
  
BEGIN
  FOR CD IN (SELECT NROEMPRESA FROM MAX_EMPRESA E WHERE NROEMPRESA BETWEEN 500 AND 599)
    LOOP
  FOR empProdloop IN (SELECT EMP, SUM(QTDATENDIDA) QTY, SEQPRODUTO 
                        FROM (
                      SELECT nroempresaestq EMP,
                             MADV_COMPOSICAORESERVAVDA.QTDATENDIDA,
                             SEQPRODUTOBASE SEQPRODUTO
                        FROM MADV_COMPOSICAORESERVAVDA

                       WHERE MADV_COMPOSICAORESERVAVDA.DTAINCLUSAO BETWEEN SYSDATE - 100 AND SYSDATE
                         AND  TO_NUMBER(MADV_COMPOSICAORESERVAVDA.nroempresaestq) = CD.NROEMPRESA

                      UNION ALL

                      SELECT nroempresaestq,
                             MADV_COMPOSICAORESERVAVDA.QTDATENDIDA,
                             SEQPRODUTO
                        FROM MADV_COMPOSICAORESERVAVDA
                       WHERE MADV_COMPOSICAORESERVAVDA.DTAINCLUSAO BETWEEN SYSDATE - 100 AND SYSDATE
                         AND nroempresaestq =  CD.NROEMPRESA
                      ) base
                      WHERE EXISTS (SELECT 1 FROM MRL_PRODUTOEMPRESA Y WHERE Y.QTDRESERVADAVDA < 0 AND Y.SEQPRODUTO = base.SEQPRODUTO AND Y.NROEMPRESA = base.EMP)
                      GROUP BY EMP, SEQPRODUTO)
  LOOP
    i := i + 1;
    UPDATE MRL_PRODUTOEMPRESA X SET X.QTDRESERVADAVDA = empProdLoop.Qty
                              WHERE X.NROEMPRESA      = empProdLoop.EMP
                                AND X.SEQPRODUTO      = empProdLoop.Seqproduto;
    IF i = 100 THEN 
               COMMIT;
       i := 0;
    END IF;
        
  END LOOP;
  -- Se restou e nao corrigiu, entao nao tem reserva.. precisa zerar o negativo
  UPDATE MRL_PRODUTOEMPRESA X SET X.QTDRESERVADAVDA = 0
                              WHERE X.NROEMPRESA      = CD.NROEMPRESA
                                AND X.QTDRESERVADAVDA < 0;
  END LOOP;
  COMMIT;
END;
 
