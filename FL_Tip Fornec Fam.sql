-- Corrige Tipo Familia para Industria nos Fornecs 502 e 503

ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

BEGIN
  FOR t IN (SELECT * FROM MAP_FAMFORNEC X WHERE X.SEQFORNECEDOR IN (502,503) AND NVL(X.TIPFORNECEDORFAM, 'X') != 'I')
    
  LOOP
    UPDATE MAP_FAMFORNEC Z SET Z.USUARIOALTERACAO  = 'TKT462434',
                               Z.DATAHORAALTERACAO = SYSDATE,
                               Z.TIPFORNECEDORFAM  = 'I'
                         WHERE Z.SEQFAMILIA = T.SEQFAMILIA
                           AND Z.SEQFORNECEDOR = T.SEQFORNECEDOR;
                           
   END LOOP;
   
END;
