BEGIN
  DECLARE 
    i INTEGER := 0;
    
  BEGIN
  FOR T IN (SELECT * FROM NAGT_BASE_DESCHUM)
  
  LOOP
    i := i + 1;
    UPDATE MAP_PRODUTO P
       SET P.DTAHORALTERACAO  = TRUNC(SYSDATE - 10),
           P.USUARIOALTERACAO = 'DESC_CRM',
           P.DESCECOMMERCE    = T.DESC_HUM
     WHERE P.SEQPRODUTO = T.SEQPRODUTO
       AND NVL(P.DESCECOMMERCE,0) != T.DESC_HUM;
        IF i = 100 THEN -- Define o Commit por quantidade de linhas
            COMMIT;
            i := 0;
        END IF;
  END LOOP;
 END;
END;
