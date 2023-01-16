/* Equipara Preço de Venda de Embalagens de Atacado com o Preço Unitário */

DECLARE
  i INTEGER := 0;
BEGIN
  FOR t IN (
           SELECT DISTINCT A.SEQPRODUTO
             FROM CONSINCO.MRL_PRODEMPSEG A LEFT JOIN (SELECT B.PRECOBASENORMAL / B.QTDEMBALAGEM PA, B.SEQPRODUTO, B.NROEMPRESA
                                                         FROM CONSINCO.MRL_PRODEMPSEG B 
                                                        WHERE B.QTDEMBALAGEM > 1  -- Pega apenas os preços de embalagens de atacado
                                                          AND B.NROEMPRESA   = &LJ
                                                          AND B.NROSEGMENTO  = &SEG) B 
                                                   ON B.SEQPRODUTO = A.SEQPRODUTO AND B.NROEMPRESA = A.NROEMPRESA    
            WHERE A.QTDEMBALAGEM      = 1 
              AND A.PRECOVALIDNORMAL != B.PA -- Apenas os códigos em que o Preço Unitário difere do Preço Uni. no Atacado |'PA'
              AND A.NROEMPRESA        = &LJ
              AND A.NROSEGMENTO       = &SEG
              AND B.PA               != 0
           )
  LOOP
    BEGIN
      i := i + 1;
   -- Seta os valores (Valid|Ger|Base) de acordo com o Preço Base Unitário
      UPDATE CONSINCO.MRL_PRODEMPSEG C
         SET C.PRECOVALIDNORMAL = (SELECT DISTINCT B.PRECOBASENORMAL 
                                     FROM CONSINCO.MRL_PRODEMPSEG B 
                                    WHERE C.SEQPRODUTO  = B.SEQPRODUTO 
                                      AND C.NROEMPRESA  = B.NROEMPRESA 
                                      AND QTDEMBALAGEM  = 1 
                                      AND B.NROSEGMENTO = C.NROSEGMENTO) * NVL(C.QTDEMBALAGEM,1),
             C.PRECOGERNORMAL   = (SELECT DISTINCT B.PRECOBASENORMAL 
                                     FROM CONSINCO.MRL_PRODEMPSEG B 
                                    WHERE C.SEQPRODUTO  = B.SEQPRODUTO 
                                      AND C.NROEMPRESA  = B.NROEMPRESA 
                                      AND QTDEMBALAGEM  = 1 
                                      AND B.NROSEGMENTO = C.NROSEGMENTO) * NVL(C.QTDEMBALAGEM,1),
             C.PRECOBASENORMAL  = (SELECT DISTINCT B.PRECOBASENORMAL 
                                     FROM CONSINCO.MRL_PRODEMPSEG B 
                                    WHERE C.SEQPRODUTO  = B.SEQPRODUTO 
                                      AND C.NROEMPRESA  = B.NROEMPRESA 
                                      AND QTDEMBALAGEM  = 1 
                                      AND B.NROSEGMENTO = C.NROSEGMENTO) * NVL(C.QTDEMBALAGEM,1),
             C.USUALTERACAO = 'EQUIP_EMB'
       WHERE C.NROEMPRESA  = &LJ
         AND C.NROSEGMENTO = &SEG
         AND C.PRECOBASENORMAL != 0
         AND C.SEQPRODUTO = T.SEQPRODUTO;
       IF i = 10 THEN COMMIT;
       i:= 0;
       END IF;
       
       EXCEPTION
         WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQPRODUTO);
       END;
   END LOOP;
   COMMIT;
END;  
       
        
                                      
