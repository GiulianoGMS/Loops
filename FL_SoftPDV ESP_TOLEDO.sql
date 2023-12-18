DECLARE
      i INTEGER := 0;
      
      BEGIN
        FOR t IN (SELECT NROEMPRESA FROM MAX_EMPRESA A WHERE NOT EXISTS ( SELECT 1 FROM  MRL_EMPSOFTPDV B
                                                                           WHERE 1=1
                                                                             AND SOFTPDV LIKE '%ESP_TOLEDO%'
                                                                             AND A.NROEMPRESA = B.NROEMPRESA )
                 AND A.NROEMPRESA < 100)
   
    LOOP
      BEGIN
        i := i+1;
       INSERT INTO MRL_EMPSOFTPDV II (SELECT t.NROEMPRESA,
                                             I.SOFTPDV,
                                             I.DIRETIMPORTARQUIVO,
                                             '/u02/dados/versaonovaconsinco/loja'||TO_CHAR(LPAD(T.NROEMPRESA,2,0))||'/balanca' DIRETEXPORTARQUIVO,
                                             I.TIPOEXPORTACAO,
                                             I.DIRETTEMP,
                                             I.NOMEVIEW,
                                             I.TIPOCARGA,
                                             I.TIPOSOFT,
                                             I.STATUS,
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
                                         AND SOFTPDV LIKE '%ESP_TOLEDO%'
                                         AND NROEMPRESA = 1);
                                         
      IF i = 10 THEN COMMIT;
      i := 0;
      END IF;
      END;
     END LOOP;
    COMMIT;
   END;

/*
SELECT *
  FROM MRL_EMPSOFTPDV B
 WHERE 1 = 1
   AND SOFTPDV LIKE '%ESP_TOLEDO%' ORDER BY 1 
*/
