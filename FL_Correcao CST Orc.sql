-- TIcket 613053

BEGIN
  FOR t IN (
    
SELECT *
  FROM MAP_TRIBUTACAOUF X
 WHERE NROTRIBUTACAO IN (2,67,74,242,245,246,247,248,252,257,266,270,271,272,
                         274,275,276,706,762,931,1073,1098,1156,1174)
   AND UFEMPRESA = UFCLIENTEFORNEC
   AND TIPTRIBUTACAO      IN ('EI','ED','EM')
   AND X.NROREGTRIBUTACAO IN (0,2)
   AND LPAD(X.SITUACAONF,3,'0') IN ('000','010','060', '090')
   
   )
   
   LOOP
     UPDATE MAP_TRIBUTACAOUF Z SET Z.SITUACAONF = '090'
                             WHERE Z.NROTRIBUTACAO = T.NROTRIBUTACAO
                               AND Z.UFEMPRESA = T.UFEMPRESA
                               AND Z.UFCLIENTEFORNEC = T.UFCLIENTEFORNEC
                               AND Z.TIPTRIBUTACAO = T.TIPTRIBUTACAO;
                               
    END LOOP;
    
END;
   
   
   
                         
