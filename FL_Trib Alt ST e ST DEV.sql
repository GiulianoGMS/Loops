-- Backup

CREATE TABLE NAGT_MAP_TRIBUTACAOUF_BKP AS
SELECT * FROM CONSINCO.MAP_TRIBUTACAOUF

-- Loop de Retorno do Backup caso a alteracao nao esteja correta

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT DISTINCT X.NROTRIBUTACAO, X.SITUACAONF, X.SITUACAONFDEV, X.UFEMPRESA, X.UFCLIENTEFORNEC, X.TIPTRIBUTACAO, X.NROREGTRIBUTACAO 
                FROM NAGT_MAP_TRIBUTACAOUF_BKP X INNER JOIN MAP_TRIBUTACAOUF Q ON X.NROTRIBUTACAO = Q.NROTRIBUTACAO
                                                                              AND X.UFEMPRESA     = Q.UFEMPRESA
                                                                              AND X.UFCLIENTEFORNEC = Q.UFCLIENTEFORNEC
                                                                              AND X.TIPTRIBUTACAO = Q.TIPTRIBUTACAO
                                                                              AND X.NROREGTRIBUTACAO = Q.NROREGTRIBUTACAO
                      WHERE Q.SITUACAONF    != X.SITUACAONF
                         OR Q.SITUACAONFDEV != X.SITUACAONFDEV)
  LOOP
    BEGIN
       i := i+1;
    UPDATE CONSINCO.MAP_TRIBUTACAOUF U SET U.SITUACAONF       = T.SITUACAONF,
                                           U.SITUACAONFDEV    = T.SITUACAONFDEV
                                     WHERE U.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                       AND U.UFEMPRESA        = T.UFEMPRESA
                                       AND U.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                       AND U.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                       AND U.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
    IF i = 10 THEN COMMIT;
       i := 0;
    END IF;
            
      END;
  END LOOP;
 COMMIT;
END;  

-- Updates divididos por UF / Regra / ST e ST DEV 

-- 1
-- SP X SP e RJ XRJ  Quando tiver preenchido o campo Isento qualquer valor os campos  Situação tributaria  e  Situação tributaria Devolução vai ser 070

DECLARE
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP') -- SP
                 AND X.UFCLIENTEFORNEC IN ('SP')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '070',
                                              --Z.SITUACAONFDEV    = '070',
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
     
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('RJ')
                 AND X.UFCLIENTEFORNEC IN ('RJ')
                 AND NROREGTRIBUTACAO  IN (0,2)
                 AND (SITUACAONF = '060') -- SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '070',
                                              --Z.SITUACAONFDEV    = '070',
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
     
  -- DEV
  
     FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                  FROM CONSINCO.MAP_TRIBUTACAOUF X 
                 WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                   AND X.UFEMPRESA       IN ('SP')
                   AND X.UFCLIENTEFORNEC IN ('SP')
                   AND NROREGTRIBUTACAO  IN (0,2) 
                   AND (SITUACAONFDEV = '090')
                   AND NVL(X.PERISENTO,0) > 0
                   AND X.NROTRIBUTACAO IN (58)
                   )
                     
     LOOP
       BEGIN
         i := i+1;
         UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '070',
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
      
      FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                  FROM CONSINCO.MAP_TRIBUTACAOUF X 
                 WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                   AND X.UFEMPRESA       IN ('RJ')
                   AND X.UFCLIENTEFORNEC IN ('RJ')
                   AND NROREGTRIBUTACAO  IN (0,2) 
                   AND (SITUACAONFDEV = '090')
                   AND NVL(X.PERISENTO,0) > 0
                   AND X.NROTRIBUTACAO IN (58)
                   )
                     
     LOOP
       BEGIN
         i := i+1;
         UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '070',
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
      
-- 2
-- SP X SP e RJ XRJ Quando no campo isento tiver preenchido 0,00 os campos  Situação tributaria  e  Situação tributaria Devolução vai ser 010

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI')  
                 AND X.UFEMPRESA       IN ('SP')
                 AND X.UFCLIENTEFORNEC IN ('SP')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060')-- OR SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                             -- Z.SITUACAONFDEV    = '010',
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
     
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI')  
                 AND X.UFEMPRESA       IN ('RJ')
                 AND X.UFCLIENTEFORNEC IN ('RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060')-- OR SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                             -- Z.SITUACAONFDEV    = '010',
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
     
  -- DEV

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI')  
                 AND X.UFEMPRESA       IN ('SP')
                 AND X.UFCLIENTEFORNEC IN ('SP')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '010',
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
     
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI')  
                 AND X.UFEMPRESA       IN ('RJ')
                 AND X.UFCLIENTEFORNEC IN ('RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '010',
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
  
-- 3
-- SP e RJ X demais estados no campo isento tiver preenchido 0,00 e o campo Trib.ST qualquer valor de 0 a 100 os campos  
-- Situação tributaria  e  Situação tributaria Devolução vai ser 010

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND NVL(X.PERTRIBUTST,0) > 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                              --Z.SITUACAONFDEV    = '010',
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
     
  -- DEV 

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND NVL(X.PERTRIBUTST,0) > 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '010',
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
  
-- 4
-- SP e RJ X demais estados no campo Situação tributaria 060 vai ficar 010 e permanece 00 no campo Situação tributaria Devolução.


    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI', 'ED') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND SITUACAONFDEV = '000'
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                              --Z.SITUACAONFDEV    = '010',
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

/* Retirado - não sera mais necessário corrigir EM

-- 5 EM
-- Micro Empresa no Regime Normal e Fabricante Comercio Atacadista em SP e RJ.

-- Regime Normal e Atacado - SP e RJ X demais  e demais Quando tiver preenchido o campo Situação tributaria 060 fica 202 e  Situação tributaria Devolução quando tiver 090 fica 202 os demais campos não altera.

   FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EM') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.CALCICMSDESCSUFRAMA != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '202',
                                              --Z.SITUACAONFDEV    = '010',
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
     
-- DEV

   FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EM') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND SITUACAONFDEV = '090'
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '202',
                                              Z.SITUACAONFDEV    = 202,
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
-- Regime Atacado - SP X SP e RJ XRJ  Quando tiver preenchido o campo  Situação tributaria 060 fica 500 e Situação tributaria Devolução quando tiver 060 fica 500 os demais campos não altera.
     
   FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EM')
                 AND X.UFCLIENTEFORNEC IN ('SP','RJ') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '500',
                                              --Z.SITUACAONFDEV    = '010',
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

-- DEV

   FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EM')
                 AND X.UFCLIENTEFORNEC IN ('SP','RJ') 
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND NROREGTRIBUTACAO  IN (2) 
                 AND SITUACAONFDEV = '060'
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '500',
                                              Z.SITUACAONFDEV    = '500',
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
     */
     
-- 6

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('ED')  
                 AND X.UFEMPRESA       IN ('SP')
                 AND X.UFCLIENTEFORNEC IN ('SP')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '060',
                                              --Z.SITUACAONFDEV    = '070',
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
     
    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('ED')  
                 AND X.UFEMPRESA       IN ('RJ')
                 AND X.UFCLIENTEFORNEC IN ('RJ')
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) = 0
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '060',
                                              --Z.SITUACAONFDEV    = '070',
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

     
  -- DEV
  
     FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                  FROM CONSINCO.MAP_TRIBUTACAOUF X 
                 WHERE X.TIPTRIBUTACAO   IN ('ED')  
                   AND X.UFEMPRESA       IN ('SP')
                   AND X.UFCLIENTEFORNEC IN ('SP')
                   AND NROREGTRIBUTACAO  IN (0,2) 
                   AND (SITUACAONFDEV = '090')
                   AND NVL(X.PERISENTO,0) = 0
                   AND X.NROTRIBUTACAO IN (58)
                   )
                     
     LOOP
       BEGIN
         i := i+1;
         UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '070',
                                                Z.SITUACAONFDEV    = '060',
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
      
         FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                  FROM CONSINCO.MAP_TRIBUTACAOUF X 
                 WHERE X.TIPTRIBUTACAO   IN ('ED')  
                   AND X.UFEMPRESA       IN ('RJ')
                   AND X.UFCLIENTEFORNEC IN ('RJ')
                   AND NROREGTRIBUTACAO  IN (0,2) 
                   AND (SITUACAONFDEV = '090')
                   AND NVL(X.PERISENTO,0) = 0
                   AND X.NROTRIBUTACAO IN (58)
                   )
                     
     LOOP
       BEGIN
         i := i+1;
         UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '070',
                                                Z.SITUACAONFDEV    = '060',
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
      
 -- 7
 
 FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND NVL(X.PERTRIBUTST,0) > 0 AND NVL(X.PERTRIBUTST,0) < 100
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '070',
                                              --Z.SITUACAONFDEV    = '010',
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
     
  -- DEV 

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND NVL(X.PERTRIBUTST,0) > 0 AND NVL(X.PERTRIBUTST,0) < 100
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '010',
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
     
-- 8

FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONF = '060') -- OR SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND NVL(X.PERTRIBUTST,0) = 100
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.SITUACAONF       = '010',
                                              --Z.SITUACAONFDEV    = '010',
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
     
  -- DEV 

    FOR t IN (SELECT NROTRIBUTACAO, UFEMPRESA, UFCLIENTEFORNEC, TIPTRIBUTACAO, NROREGTRIBUTACAO, SITUACAONF, SITUACAONFDEV
                FROM CONSINCO.MAP_TRIBUTACAOUF X 
               WHERE X.TIPTRIBUTACAO   IN ('EI','ED')  
                 AND X.UFEMPRESA       IN ('SP','RJ')
                 AND X.UFCLIENTEFORNEC != X.UFEMPRESA
                 AND NROREGTRIBUTACAO  IN (0,2) 
                 AND (SITUACAONFDEV = '090')
                 AND NVL(X.PERISENTO,0) > 0
                 AND NVL(X.PERTRIBUTST,0) = 100
                 AND X.NROTRIBUTACAO IN (58)
                 )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET --Z.SITUACAONF       = '010',
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
