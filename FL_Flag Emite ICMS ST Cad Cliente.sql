CREATE TABLE CONSINCO.NAGT_MRL_CLIENTE_BKP AS
SELECT * FROM CONSINCO.MRL_CLIENTE;

-- Corrige Flag Emissao ICMS ST Ult Entrada/Op Propria no Cliente

DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQPESSOA FROM CONSINCO.MRL_CLIENTE X WHERE NVL(X.INDEMITESTREFULTENTRADA, 'N') = 'N')
          
        LOOP
          BEGIN
            i := i+1;
            UPDATE CONSINCO.MRL_CLIENTE Z SET Z.INDEMITESTREFULTENTRADA = 'S',
                                              Z.DTAALTERACAO = SYSDATE,
                                              Z.USUALTERACAO = 'TKT344782'
                                        WHERE Z.SEQPESSOA = T.SEQPESSOA;
      IF i = 1000 THEN COMMIT;
      i := 0;
      END IF;
      
      END;
     END LOOP;
    COMMIT;
   END;
   
-- Confere

SELECT COUNT(1) FROM CONSINCO.MRL_CLIENTE X WHERE NVL(X.INDEMITESTREFULTENTRADA, 'N') = 'N'
