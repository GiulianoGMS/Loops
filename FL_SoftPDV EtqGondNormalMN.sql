DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT NROEMPRESA FROM MAX_EMPRESA A WHERE NOT EXISTS ( SELECT 1 FROM  MRL_EMPSOFTPDV B
                                                                           WHERE 1=1
                                                                             AND SOFTPDV LIKE '%ETQGONDNORMAL_MN%'
                                                                             AND A.NROEMPRESA = B.NROEMPRESA )
                 AND A.NROEMPRESA < 56
                 AND A.NROEMPRESA NOT IN (31,41,54))
   
    LOOP
      BEGIN
        i := i+1;
       INSERT INTO MRL_EMPSOFTPDV II (SELECT I.NROEMPRESA,
                                             'ETQGONDNORMAL_MN',
                                             I.DIRETIMPORTARQUIVO,
                                             I.DIRETEXPORTARQUIVO,
                                             I.TIPOEXPORTACAO,
                                             I.DIRETTEMP,
                                             'mrlv_etiq_nagumo_varejo_vm2', --I.NOMEVIEW,
                                             I.TIPOCARGA,
                                             I.TIPOSOFT,
                                             'A',
                                             I.DTAALTERACAO,
                                             I.USUALTERACAO,
                                             I.DTAIMPORTEXPORT,
                                             I.USUIMPORTEXPORT,
                                             I.NROGONDOLA,
                                             I.SEQEXPORTACAO,
                                             I.DIRETDESTINO,
                                             I.TIPODADOLINHA,
                                             I.NROCARGAPDV,
                                             I.INDCORTADIGBALANCA,
                                             I.INDDESCBALANCA,
                                             I.DIRETEXPORTARQPRECOPROMOC,
                                             I.INDGERATXTNFE,
                                             I.SUFIXO_ARQUIVO_EDI,
                                             I.NOMEQRPETIQUETA,
                                             I.QTDCOLUNASETIQ,
                                             I.PREFIXO_ARQUIVO_EDI,
                                             I.VERSAOLAYOUT,
                                             I.NOMEJOBNFE,
                                             I.NOMEJOBMDFE,
                                             I.INDETIQWEB,
                                             I.NOMEVIEWETIQWEB,
                                             I.NOMEIMPETIQWEB,
                                             NULL,
                                             I.NOMEJOBNFSE,
                                             I.INDUSUARIOFTPBALANCA,
                                             I.DIRETIMPORTADOS,
                                             I.DIRETREJEITADOS,
                                             I.SEQETIQUETALAYOUT,
                                             I.TIPOQUEBRALINHA FROM MRL_EMPSOFTPDV I
                                       WHERE 1=1
                                         AND SOFTPDV = 'ETQGONDNORMAL'
                                         AND NROEMPRESA = T.NROEMPRESA);
                                         
      UPDATE MRL_EMPSOFTPDV O SET STATUS = 'I' WHERE O.SOFTPDV = 'ETQGONDNORMAL' AND O.NROEMPRESA = T.NROEMPRESA;
                                         
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      
      END;
     END LOOP;
     
    COMMIT;
   END;
