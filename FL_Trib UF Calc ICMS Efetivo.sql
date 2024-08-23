-- Giuliano - 23/08/2024
-- Solicitação Danielle - TKT_436663

CREATE TABLE CONSINCO.NAGT_436663_BKP AS

SELECT *
  FROM MAP_TRIBUTACAOUF X
 WHERE 1=1
   AND X.TIPTRIBUTACAO = 'SC'
   AND UFEMPRESA IN ('SP', 'RJ')
   AND UFCLIENTEFORNEC IN ('SP', 'RJ')
   AND X.INDCALCICMSEFETIVO = 'S';

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT *
                FROM MAP_TRIBUTACAOUF X
               WHERE 1=1
                 AND X.TIPTRIBUTACAO = 'SC'
                 AND UFEMPRESA IN ('SP', 'RJ')
                 AND UFCLIENTEFORNEC IN ('SP', 'RJ')
                 AND X.INDCALCICMSEFETIVO = 'S')
LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.INDCALCICMSEFETIVO = 'N',
                                              Z.PERREDBCICMSEFET = NULL,
                                              Z.USUALTERACAO = 'TKT_436663',
                                              Z.DTAALTERACAO = SYSDATE
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 100 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
   
END;
