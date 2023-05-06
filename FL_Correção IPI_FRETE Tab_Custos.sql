DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT SEQFORNECEDOR, SEQFAMILIA, MAX(TO_DATE(DTAULTALTERACAO, 'DD/MM/YY')) DATA
                  FROM CONSINCO.MAC_CUSTOFORNECLOG
                  WHERE NVL(INDCALCFRETECUSTODESC, 'N') = 'N'
                  AND SEQFAMILIA NOT IN (SELECT Z.SEQFAMILIA FROM CONSINCO.MAC_CUSTOFORNECLOG Z WHERE NVL(Z.INDCALCFRETECUSTODESC, 'N') = 'S')
                  GROUP BY SEQFORNECEDOR, SEQFAMILIA)
    LOOP
      BEGIN
        i := i+1;
        UPDATE CONSINCO.MAC_CUSTOFORNECLOG X SET INDCALCFRETECUSTODESC = 'S', 
                                                 INDCALCDESPCUSTODESC  = 'S', 
                                                 INDSOMAFRETETOTALNF   = 'S', 
                                                 INDSOMADESPTOTALNF    = 'S', 
                                                 INDSOMAFRETEBASEIPI   = 'S', 
                                                 INDSOMADESPBASEIPI    = 'S' 
                                           WHERE X.SEQFORNECEDOR = T.SEQFORNECEDOR
                                             AND TO_DATE(X.DTAULTALTERACAO, 'DD/MM/YY') = T.DATA
                                             AND X.SEQFAMILIA = T.SEQFAMILIA;
      IF i = 100 THEN COMMIT;
      i := 0;
      END IF;
      
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQFORNECEDOR);
      END;
     END LOOP;
    COMMIT;
   END;
   
----------------------------
-- Confere Alteracoes
----------------------------

SELECT 'Fornecedores Alterados' Info, COUNT(Z.SEQFAMILIA) FROM CONSINCO.MAC_CUSTOFORNECLOG Z WHERE NVL(Z.INDCALCFRETECUSTODESC, 'N') = 'S'
UNION ALL
SELECT 'Não alterados', COUNT(Z.SEQFAMILIA) FROM CONSINCO.MAC_CUSTOFORNECLOG Z WHERE NVL(Z.INDCALCFRETECUSTODESC, 'N') = 'N'
AND SEQFAMILIA NOT IN (SELECT SEQFAMILIA FROM CONSINCO.MAC_CUSTOFORNECLOG Z WHERE NVL(Z.INDCALCFRETECUSTODESC, 'N') = 'S')
