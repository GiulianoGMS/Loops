-- 1
-- SP X SP e RJ XRJ  Quando tiver preenchido o campo Isento qualquer valor os campos  Situação tributaria  e  Situação tributaria Devolução vai ser 070

DECLARE
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI', 'ED', 'EM') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND SITUACAONF = '060' AND SITUACAONFDEV = '090'
                 AND NVL(X.PERISENTO,0) > 0)
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '070',
                                              Z.SITUACAONFDEV    = '070',
                                              Z.USUALTERACAO     = 'TKT313247'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
     COMMIT;
  
   END;

-- 2
-- SP X SP e RJ XRJ Quando no campo isento tiver preenchido 0,00 os campos  Situação tributaria  e  Situação tributaria Devolução vai ser 010

DECLARE
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI', 'ED', 'EM') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND SITUACAONF = '060' AND SITUACAONFDEV = '090'
                 AND NVL(X.PERISENTO,0) = 0)
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                              Z.SITUACAONFDEV    = '010',
                                              Z.USUALTERACAO     = 'TKT313247'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
           END IF;
            
      END;
      END LOOP;
      
     COMMIT;
  
   END;
   
-- 3
-- SP e RJ X demais estados no campo isento tiver preenchido 0,00 e o campo Trib.ST qualquer valor de 0 a 100 os campos  
-- Situação tributaria  e  Situação tributaria Devolução vai ser 010


DECLARE
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI', 'ED', 'EM') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC NOT IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND SITUACAONF = '060' AND SITUACAONFDEV = '090'
                 AND NVL(X.PERISENTO,0) = 0
                 AND NVL(X.PERTRIBUTST,0) > 0)
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                              Z.SITUACAONFDEV    = '010',
                                              Z.USUALTERACAO     = 'TKT313247'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
           END IF;
            
      END;
      END LOOP;
      
     COMMIT;
  
   END;
