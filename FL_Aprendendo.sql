DECLARE

  i INTEGER := 0; -- Recebe 0 como valor inicial;
  
BEGIN
  
  FOR t IN (SELECT DISTINCT SEQPESSOA FROM GE_PESSOA A WHERE A.SEQPESSOA <= 10) -- Tipo While
    
  LOOP
    BEGIN
      i := i+1;
      
      DBMS_OUTPUT.PUT_LINE('Teste : '||T.SEQPESSOA);
      
      IF i BETWEEN 4 AND 8 THEN
        DBMS_OUTPUT.PUT_LINE('Teste IF <>');
       -- i := 0;
        
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(T.SEQPESSOA||' Erro');
          END;

   END LOOP;
END;
