DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQPRODUTO, STATUSVENDA, NROEMPRESA, NROSEGMENTO, QTDEMBALAGEM FROM CONSINCO.MRL_PRODEMPSEG G WHERE SEQPRODUTO = 5500) -- WHERE SEQPRODUTO =:NR1) -- AND STATUSVENDA != DECODE(#LS1,'Ativo','A','Inativo','I')
          
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MRL_PRODEMPSEG X SET X.STATUSVENDA                 = 'A',       --DECODE(#LS1,'Ativo','A','Inativo','I') ,  
                                             X.USUALTERACAO                = 'GIGOMES', --(SELECT SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')FROM DUAL),
                                             X.INDREPLICACAO               = 'S',
                                             X.DTAALTERACAO                = SYSDATE,
                                             X.MARGEMLUCROPRODEMPSEG       = NULL,
                                             X.DTAAPROVASTATUSVDA          = NULL,
                                             X.USUAPROVASTATUSVDA          = NULL  
                                             WHERE X.SEQPRODUTO = T.SEQPRODUTO AND X.NROEMPRESA = T.NROEMPRESA AND X.NROSEGMENTO = T.NROSEGMENTO AND X.QTDEMBALAGEM = T.QTDEMBALAGEM;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQPRODUTO||' - '||T.NROEMPRESA||' - Não pode ser alterado!');
      END;
     END LOOP;
    COMMIT;
   END;
   
DECLARE 
     i INTEGER := 0;
     
      BEGIN
        FOR t IN (SELECT SEQPRODUTO, STATUSCOMPRA, NROEMPRESA FROM CONSINCO.MRL_PRODUTOEMPRESA G WHERE SEQPRODUTO = 5500) -- WHERE SEQPRODUTO =:NR1)
          
    LOOP
      BEGIN
        i := i+1;
        UPDATE MRL_PRODUTOEMPRESA A SET A.STATUSCOMPRA = 'A' --DECODE(#LS2,'Ativo','A','Inativo','I', 'Suspenso','S')
                                  WHERE A.SEQPRODUTO = 5500;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQPRODUTO||' - '||T.NROEMPRESA||' - Não pode ser alterado!');
      END;
     END LOOP;
    COMMIT;
   END;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
