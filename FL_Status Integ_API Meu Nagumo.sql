-- Ativa cadastros que tiveram status alterados pela API Meu Nagumo para Prospect 'P')

DECLARE

  i INTEGER := 0; -- Variavel para dar Commit parcial
  
BEGIN
  
  FOR t IN (SELECT DISTINCT SEQIDENTIFICA FROM GEV_PESSOALOGALTERACAO B 
             WHERE USUALTERACAO = 'IMPORTACAO' 
               AND HISTORICO LIKE '%Status%' 
               AND TO_CHAR(DTAHORALTERACAO, 'DD/MM/YYYY') = '20/12/2022')
               
   LOOP
     BEGIN
       i := i + 1;  -- Adiciona +1 na variavel para Commit parcial
       
       UPDATE GE_PESSOA A
          SET A.STATUS = 'A',
              USUALTERACAO = 'IMPORTACAO'
        WHERE STATUS = 'P'
          AND A.SEQPESSOA = T.SEQIDENTIFICA;
          
        IF i = 10 THEN COMMIT; -- Commit parcial 
        i := 0; -- Zera o contador do Commit parcial
        END IF;
        
        EXCEPTION 
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQIDENTIFICA);
            
        END;
   END LOOP;
   COMMIT;
END;
