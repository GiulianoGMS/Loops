DECLARE 
  vsSeqTitulo NUMBER;

BEGIN
      FOR t IN (SELECT NROEMPRESA FROM MAX_EMPRESA EMP WHERE NROEMPRESA < 100)
          
      LOOP
        
      BEGIN
        
      FOR ti IN (SELECT SEQTITULONSU, NT.SEQTITULO, NT.DTAMOVIMENTO, TB.VALOR VALOR_TOT, TB2.VALOR VALOR_RETIRAR
                   FROM FI_TITULONSU N INNER JOIN FI_TITULO NT ON N.SEQTITULO = NT.SEQTITULO
                   
                                       INNER JOIN (SELECT B.SEQEDIPEDVENDA, A.NROEMPRESA, TRUNC(A.DTAINCLUSAO) DTAINCLUSAO, B.VALOR
                                                    FROM ECOMM_PDV_PAGTO B LEFT JOIN ECOMM_PDV_VENDA A ON A.SEQEDIPEDVENDA = B.SEQEDIPEDVENDA
                                                    WHERE B.NROFORMAPAGTO = 523
                                                      AND EXISTS (SELECT 1 FROM ECOMM_PDV_PAGTO C WHERE C.SEQEDIPEDVENDA = B.SEQEDIPEDVENDA AND C.NROFORMAPAGTO = 84)
                                                      AND TRUNC(A.DTAINCLUSAO) = DATE '2024-04-16'
                                                      AND 1=1 /*A.NROEMPRESA = 51*/) TB ON TB.VALOR       = N.VALOR 
                                                                                       AND TB.NROEMPRESA  = NT.NROEMPRESA
                                                                                       AND TB.DTAINCLUSAO = NT.DTAEMISSAO
                                                                                                                               
                                       INNER JOIN (SELECT B.SEQEDIPEDVENDA, A.NROEMPRESA, TRUNC(A.DTAINCLUSAO) DTAINCLUSAO, B.VALOR 
                                                     FROM ECOMM_PDV_PAGTO B LEFT JOIN ECOMM_PDV_VENDA A ON A.SEQEDIPEDVENDA = B.SEQEDIPEDVENDA
                                                    WHERE B.NROFORMAPAGTO = 84
                                                      AND EXISTS (SELECT 1 FROM ECOMM_PDV_PAGTO C WHERE C.SEQEDIPEDVENDA = B.SEQEDIPEDVENDA AND C.NROFORMAPAGTO = 523)) TB2 ON TB2.SEQEDIPEDVENDA = TB.SEQEDIPEDVENDA
                                                                                                                              
                  WHERE NT.CODESPECIE = 'IFOOD'
                    AND NT.NROEMPRESA = t.NROEMPRESA
                    AND NT.DTAEMISSAO = DATE '2024-04-16')
                    
       LOOP
         
       vsSeqTitulo := ti.SEQTITULO;
       
       UPDATE FI_TITULONSU NSU SET NSU.VALOR           =(ti.VALOR_TOT - ti.VALOR_RETIRAR)
                             WHERE NSU.SEQTITULONSU    = ti.SEQTITULONSU
                               AND NSU.SEQTITULO       = ti.SEQTITULO
                               AND NSU.VALOR           = ti.VALOR_TOT;
       END LOOP;                    
       END;
        
     END LOOP;
     
   END;
                               
                    
