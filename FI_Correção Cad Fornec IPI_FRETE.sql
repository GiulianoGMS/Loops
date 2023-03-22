DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQFORNECEDOR
                    FROM CONSINCO.MAF_FORNECDIVISAO WHERE NVL(INDSOMADESPBASEIPI, 'N') = 'N' AND SEQFORNECEDOR IN (SELECT DISTINCT SEQPESSOA FROM CONSINCO.GE_PESSOA Z WHERE (Z.NOMERAZAO LIKE '%SPAL%' OR Z.NOMERAZAO LIKE '%AMBEV%') AND FISICAJURIDICA = 'J'))
          
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAF_FORNECDIVISAO X SET -- INDCALCFRETECUSTODESC = 'S', 
                                                INDCALCDESPCUSTODESC  = 'S', 
                                               -- INDSOMAFRETETOTALNF   = 'S', 
                                               -- INDSOMADESPTOTALNF    = 'S', 
                                               -- INDSOMAFRETEBASEIPI   = 'S', 
                                                INDSOMADESPBASEIPI    = 'S' 
                                          WHERE X.SEQFORNECEDOR = T.SEQFORNECEDOR;
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQFORNECEDOR);
      END;
     END LOOP;
    COMMIT;
   END;

SELECT COUNT(1) FROM CONSINCO.MAF_FORNECDIVISAO X LEFT JOIN CONSINCO.GE_PESSOA Z ON X.SEQFORNECEDOR = Z.SEQPESSOA
WHERE X.INDSOMADESPBASEIPI = 'S'
