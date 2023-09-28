-- Utilizado na urgencia de reprocessar todas as notas com status de Erro de Integração
/*
SELECT COUNT(X.SEQNOTAFISCAL)
                FROM CONSINCO.MFL_DOCTOFISCAL X 
               WHERE X.DTAHOREMISSAO >= DATE '2023-09-27' AND STATUSNFE IN (19) AND STATUSDF != 'C';*/
   
DECLARE 
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (
              SELECT X.SEQNOTAFISCAL 
                FROM CONSINCO.MFL_DOCTOFISCAL X 
               WHERE X.DTAHOREMISSAO >= DATE '2023-09-27' AND STATUSNFE = 99 AND STATUSDF != 'C'
           )
              
           LOOP
       BEGIN
         i := 1+1;
         BEGIN CONSINCO.SP_EXPORTANFE(t.Seqnotafiscal,'E'); END; 
         IF i = 1 THEN COMMIT;
         i := 0;
         END IF;
         
         END;
     END LOOP;
    COMMIT;
   END;
