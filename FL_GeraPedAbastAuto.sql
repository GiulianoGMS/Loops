-- Rateamento | PD RATEIA_QTDSUGEST_CALC precisa estar como 'S'

CREATE OR REPLACE PROCEDURE NAGP_GERAPEDIDOABASTAUTO AS
BEGIN
DECLARE
      I INTEGER := 0;
   -- SELECIONA OS LOTES DE ABASTECIMENTO EM ABERTO NO DIA ATUAL PARA GERACAO
      BEGIN 
        FOR T IN (SELECT DISTINCT A.SEQGERCOMPRA, B.HORAMINCONFIG
                    FROM CONSINCO.MAC_GERCOMPRA A INNER JOIN CONSINCO.NAGT_CONTROLEABASTAUTO B ON A.SEQGERCOMPRA = B.SEQGERCOMPRA
                   WHERE 1=1
                     AND NVL(A.INDORDEMPRODFINALIZADA, 'S') = 'S'
                     AND A.TIPOLOTE = 'A'
                     AND TRUNC(A.DTAHORINCLUSAO) >= TRUNC(SYSDATE) AND TRUNC(A.DTAHORINCLUSAO) <= TRUNC(SYSDATE)
                     AND A.DTAHORFECHAMENTO IS NULL
                     AND NROEMPRESAGERALOTE IN (501,506)  
                     AND SYSDATE > TO_DATE(SYSDATE||B.HORAMINCONFIG, 'DD/MM/YY HH24:MI')
                   
                     ORDER BY B.HORAMINCONFIG ASC)

    LOOP
      BEGIN
        I := I+1;
     -- FECHA OS LOTES
        UPDATE MAC_GERCOMPRA 
           SET DTAHORFECHAMENTO = SYSDATE,
               USUFECHAMENTO    = 'JOBABASTAUTO',
               DTAGERPEDIDO     = TRUNC(SYSDATE),
               USUGERPEDIDO     = 'JOBABASTAUTO',
               SITUACAOLOTE     = 'F',
               INCREMENTOMEDIAVENDA = NULL,
               TIPOSUGCOMPRA    = 'P',
               INDMINMAXQTD     = 'N',
               INDMINMAXDIAVDA  = 'N'
         WHERE SEQGERCOMPRA     = T.SEQGERCOMPRA;
      --
      -- GERA OS LOTES DE COMPRA/PED VENDA
         BEGIN PKG_ADM_COMPRA.SP_GERACARGAPEDVENDA(T.SEQGERCOMPRA, NULL,'S','A'); END;
      --
      -- INSERE NA TABELA DE LOG SE O LOTE FOI GERADO COM SUCESSO
         INSERT INTO NAGT_LOGGERAABASTAUTO VALUES (T.SEQGERCOMPRA, SYSDATE, 'JOBABASTAUTO', 'GERADO');

      IF I = 1 THEN COMMIT;
      I := 0;
      END IF;

      EXCEPTION
        WHEN OTHERS THEN
      -- INSERE NA TABELA DE LOG SE OCORRER ERRO AO GERAR
         INSERT INTO NAGT_LOGGERAABASTAUTO VALUES (T.SEQGERCOMPRA, SYSDATE, 'JOBABASTAUTO', 'ERRO');
      END;
     END LOOP;
    COMMIT;
   END;
   END;

---------
  
CREATE TABLE CONSINCO.NAGT_LOGGERAABASTAUTO 
      (SEQGERCOMPRA NUMBER(20),
       DTAGERACAO   DATE,
       USUGERACAO   VARCHAR2(20),
       SITUACAO     VARCHAR2(20));

----------

 BEGIN 
  NAGP_GERAPEDIDOABASTAUTO;
  END;
