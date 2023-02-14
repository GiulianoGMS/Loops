-- Backup na CONSINCO.NAGT_BACKUPIFOOD

DECLARE

 i INTEGER := 0;
 
 BEGIN
   FOR t IN(SELECT A.SEQTITULO FROM CONSINCO.FI_TITULO A WHERE CODESPECIE = 'IFOOD' AND (PERMULTA > 0 OR PERJUROMORA > 0 OR VLRJUROMORA > 0 OR VLRMULTA > 0) AND A.ABERTOQUITADO = 'A')
     LOOP
        BEGIN
          i := i+1;
          UPDATE CONSINCO.FI_TITULO X SET PERMULTA = 0,
                                          VLRMULTA = 0,
                                          PERJUROMORA = 0,
                                          VLRJUROMORA = 0
                                    WHERE X.SEQTITULO = T.SEQTITULO;
             IF i = 10 THEN COMMIT;
       i:= 0;
       END IF;
       
       EXCEPTION
         WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('ERRO: '||T.SEQTITULO);
       END;
   END LOOP;
   COMMIT;
END;  


-- Confere 

SELECT COUNT(A.SEQTITULO) FROM CONSINCO.FI_TITULO A WHERE CODESPECIE = 'IFOOD' AND
    (PERMULTA > 0 OR PERJUROMORA > 0 OR VLRJUROMORA > 0 OR VLRMULTA > 0) AND A.ABERTOQUITADO = 'A'
                    ;
