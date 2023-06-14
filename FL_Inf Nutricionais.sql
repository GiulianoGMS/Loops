-- Cria Backups

CREATE TABLE CONSINCO.NAGT_MAP_INFNUTRICTAB_BACKUP AS

SELECT * FROM MAP_INFNUTRICTAB;

CREATE TABLE CONSINCO.NAGT_MAP_INFNUTRIC_BACKUP AS

SELECT * FROM MAP_INFNUTRIC;

-- Corrige QtdPorcao EX: 0125 PARA 12,5G | Exceto Atributo 12 (Valor Energetico)

DECLARE 
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT A.DESCQTDPORCAO/10 NOVA_PORC, A.SEQINFNUTRIC, A.SEQATRIBUTOFIXO
                    FROM CONSINCO.NAGT_MAP_INFNUTRICTAB_BACKUP A INNER JOIN CONSINCO.MAP_INFNUTRICTAB B ON A.SEQINFNUTRIC    = B.SEQINFNUTRIC 
                                                                                                       AND A.SEQATRIBUTOFIXO = B.SEQATRIBUTOFIXO
                   WHERE 1=1
                     AND REGEXP_LIKE(B.DESCQTDPORCAO, '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$') -- Tira nao numericos
                     AND A.SEQATRIBUTOFIXO  != 12
                     AND A.DESCQTDPORCAO/10 != B.DESCQTDPORCAO
                     AND NVL(A.DESCQTDPORCAO,0)    != '0'
                 )
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAP_INFNUTRICTAB X SET X.DESCQTDPORCAO   = T.NOVA_PORC
                                         WHERE X.SEQINFNUTRIC    = T.SEQINFNUTRIC
                                           AND X.SEQATRIBUTOFIXO = T.SEQATRIBUTOFIXO;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQINFNUTRIC||' - '||T.SEQATRIBUTOFIXO);
      END;
     END LOOP;
    COMMIT;
   END;
   
   -- Retorna valores de acordo com Backup
   
   DECLARE 
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT A.DESCQTDPORCAO NOVA_PORC, A.SEQINFNUTRIC, A.SEQATRIBUTOFIXO
                    FROM CONSINCO.NAGT_MAP_INFNUTRICTAB_BACKUP A INNER JOIN CONSINCO.MAP_INFNUTRICTAB B ON A.SEQINFNUTRIC    = B.SEQINFNUTRIC 
                                                                                                       AND A.SEQATRIBUTOFIXO = B.SEQATRIBUTOFIXO
                   WHERE 1=1
                     AND REGEXP_LIKE(B.DESCQTDPORCAO, '^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$') -- Tira não numéricos
                     AND A.SEQATRIBUTOFIXO  != 12
                     AND A.DESCQTDPORCAO    != B.DESCQTDPORCAO
                     AND NVL(A.DESCQTDPORCAO,0)    != '0'
                 )
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAP_INFNUTRICTAB X SET X.DESCQTDPORCAO   = T.NOVA_PORC
                                         WHERE X.SEQINFNUTRIC    = T.SEQINFNUTRIC
                                           AND X.SEQATRIBUTOFIXO = T.SEQATRIBUTOFIXO;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQINFNUTRIC||' - '||T.SEQATRIBUTOFIXO);
      END;
     END LOOP;
    COMMIT;
   END;
