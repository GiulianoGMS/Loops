-- Clonagem de tributacoes

-- Tabela Bkp:
NAGT_MAP_TRIBUTACAOUF_745029

-- Tabela De/Para
NAGT_DEPARA_TRIB_745029

-- Select do loop
SELECT X.*
  FROM MAP_TRIBUTACAOUF X INNER JOIN MON_REGIMETRIBUTACAO R ON R.nroregtributacao = X.NROREGTRIBUTACAO
                           LEFT JOIN NAGT_DEPARA_TRIB_745029 PP ON 1=1
 WHERE 1=1
   AND UFCLIENTEFORNEC = UFEMPRESA
   AND (X.NROTRIBUTACAO = 12
   AND (X.NROREGTRIBUTACAO = 14 AND TIPTRIBUTACAO = 'SC'
     OR X.NROREGTRIBUTACAO = 15 AND TIPTRIBUTACAO = 'SC')
     
     OR X.NROTRIBUTACAO = 704
   AND (X.NROREGTRIBUTACAO = 13 AND TIPTRIBUTACAO = 'SC'
     OR X.NROREGTRIBUTACAO = 12 AND TIPTRIBUTACAO IN ('EI', 'EM', 'ED','SC')
     OR X.NROREGTRIBUTACAO = 11 AND TIPTRIBUTACAO IN ('EI', 'EM', 'ED','SC') )) 
   
   AND NOT EXISTS (SELECT 1 FROM MAP_TRIBUTACAOUF D INNER JOIN NAGT_DEPARA_TRIB_745029 P ON D.NROTRIBUTACAO = P.NROTRIBUTACAO
                WHERE P.NROTRIBUTACAO = X.NROTRIBUTACAO
                  AND D.NROREGTRIBUTACAO = X.NROREGTRIBUTACAO
                  AND D.UFEMPRESA = X.UFEMPRESA
                  AND D.UFCLIENTEFORNEC = X.UFCLIENTEFORNEC
                  AND D.TIPTRIBUTACAO = X.TIPTRIBUTACAO)
     
     ORDER BY 1,2,3,4,5;
     
-- Insert
  
INSERT INTO MAP_TRIBUTACAOUF 
  SELECT DISTINCT PP.NROTRIBUTACAO, --X.NROTRIBUTACAO,
                                         X.UFEMPRESA,
                                         X.UFCLIENTEFORNEC,
                                         X.TIPTRIBUTACAO,
                                         X.NROREGTRIBUTACAO,
                                         X.PERTRIBUTADO,
                                         X.PERISENTO,
                                         X.PEROUTRO,
                                         X.PERALIQUOTA,
                                         X.PERACRESCST,
                                         X.PERALIQUOTAST,
                                         X.INDAPROPRIAST,
                                         X.INDPAUTAICMS,
                                         X.PERICMSANTECIPADO,
                                         X.PERICMSPRESUMIDO,
                                         X.OBSERVACAO,
                                         X.SITUACAONF,
                                         X.PERALIQICMSCALCPRECO,
                                         X.INDSOMAIPIBASEICMS,
                                         X.INDREPLICACAO,
                                         X.INDGEROUREPLICACAO,
                                         X.PERALIQFECP,
                                         X.PERBASEFECP,
                                         X.PERACRESCICMSANTEC,
                                         X.PERDESPICMS,
                                         X.INDSOMAIPIBASEST,
                                         X.PERALIQICMSDIF,
                                         X.INDREDUZBASEST,
                                         SYSDATE,
                                         'TKT745029',
                                         X.ALIQUOTAICMSPMC,
                                         X.RESSARCSTVENDA,
                                         X.PERALIQFECOP,
                                         X.PERCREDCALCVPE,
                                         X.PERALIQUOTAVPE,
                                         X.PERALIQUOTATARE,
                                         X.PERTRIBUTST,
                                         X.TIPREDUCICMSCALCST,
                                         X.TIPCALCICMSSELO,
                                         X.SITUACAONFPIS,
                                         X.SITUACAONFCOFINS,
                                         X.CODANTECIPST,
                                         X.DIAVENCTOST,
                                         X.INDCALCSTALIQCALCPRC,
                                         X.TIPOCALCICMSFISCI,
                                         X.INDBASEICMSLF,
                                         X.PERPISDIF,
                                         X.PERCOFINSDIF,
                                         X.PERALIQUOTASTCARGAGLIQ,
                                         X.INDCALCSTCONFENT,
                                         X.SITUACAONFIPI,
                                         X.CODOBSERVACAO,
                                         X.PERACRESICMSRET,
                                         X.PERALIQICMSRET,
                                         X.PERISENTOST,
                                         X.PEROUTROST,
                                         X.NROBASEEXPORTACAO,
                                         X.TIPCALCFECP,
                                         X.INDBASECEMPERCREDUZIDA,
                                         X.PERBASEPIS,
                                         X.PERBASECOFINS,
                                         X.SITUACAONFSIMPLESNAC,
                                         X.INDREDBASEICMSSTSEMDESP,
                                         X.CALCICMSDESCSUFRAMA,
                                         X.CALCICMSSTDESCSUFRAMA,
                                         X.PERPMC,
                                         X.SEQCONVPROTOCOLOGNRE,
                                         X.INDSOMAIPIBASEANTPRES,
                                         X.CODNATREC,
                                         X.SEQNATREC,
                                         X.INDCALCICMSVPE,
                                         X.INDDEDUZDESCBASEST,
                                         X.PERTRIBUTADOSUFRAMAICMS,
                                         X.PERACRESCICMSANTECIP,
                                         X.PERREDALIQ,
                                         X.INDBASECALCESTORNODIFALIQRJ,
                                         X.SITUACAONFDEV,
                                         X.PERICMSRESOLUCAO13,
                                         X.PERALIQICMSDIFER,
                                         X.INDSOMAIPIBASEICMSDIFER,
                                         X.INDSOMAFRETEBASEIPI,
                                         X.PERMAJORACAOCOFINSIMPORT,
                                         X.INDUTILCUSTOMESBASE,
                                         X.PERCARGATRIBMEDIA,
                                         X.PERACRESCSTRESOLUCAO13,
                                         X.PERMINICMSSTRET,
                                         X.PERCREGIMEATAC,
                                         X.PERTRIBUTADOCALC,
                                         X.PERISENTOCALC,
                                         X.PEROUTROCALC,
                                         X.CODOBSERVACAOCTE,
                                         X.PERTRIBUTADOANTEC,
                                         X.PERISENTOANTEC,
                                         X.PEROUTROANTEC,
                                         X.INDAPLICACRESCSTCARGALIQ,
                                         X.PERALIQSTCARGALIQRESOLUCAO13,
                                         X.INDCALCSTEMBUTPROD,
                                         X.PERALIQICMSSOLICIT,
                                         X.PERTRIBUTADORESOL13,
                                         X.PERISENTORESOL13,
                                         X.PEROUTRORESOL13,
                                         X.INDCALCICMSDESONOUTROS,
                                         X.INDCALCICMSCREDCUSTO,
                                         X.PERREDCARGATRIBDI,
                                         X.PERMAJORACAOPISIMPORT,
                                         X.PERALIQUOTADESTINO,
                                         X.TIPOCALCICMSPARTILHA,
                                         X.INDTIPOSOMAIPIICMSANTEC,
                                         X.INDUTILREDPRESUMST,
                                         X.TIPOCALCPRESUMIDO,
                                         X.INDREDICMSCAL,
                                         X.SITUACAONFCALC,
                                         X.PERALIQICMSDESON,
                                         X.INDCALCICMSANTCUSTO,
                                         X.CODOBSERVACAODEV,
                                         X.PERALIQICMSCALCRESOL13,
                                         X.SEQFORMULAFEEF,
                                         X.BASEFCPST,
                                         X.PERALIQFCPST,
                                         X.TIPCALCFCPST,
                                         X.BASEFCPICMS,
                                         X.PERALIQFCPICMS,
                                         X.TIPCALCFCPICMS,
                                         X.INDCALCICMSEFETIVO,
                                         X.PERREDBCICMSEFET,
                                         X.TIPOCALCICMSBONIF,
                                         X.SITUACAONFBONIF,
                                         X.INDCONTRAPARTIDAST,
                                         X.INDUTILICMSCALCREDFCPST,
                                         X.PERLIMREDPMC,
                                         X.CODAJUSTEINFAD,
                                         X.MOTIVODESONERACAO,
                                         X.PERDIFERIDO,
                                         X.CODAJUSTEINFADDEV,
                                         X.SEQTRIBUTACAOUFEDI,
                                         X.TIPAPROPICMSFRETE,
                                         X.INDCALCULOICMSANTECIPADO,
                                         X.INDCALCSTDIFAL,
                                         X.PERALIQICMSDIFERRESOL13,
                                         X.INDCREDDEBICMSOPST,
                                         X.CODMOTIVORESSARCRS,
                                         X.TIPCALCULODIFAL,
                                         X.PERICMSPRESUMIDORESOL13,
                                         X.NROBASEEXPORTACAOERP,
                                         X.SITUACAONFRESOL13
                  FROM MAP_TRIBUTACAOUF X INNER JOIN MON_REGIMETRIBUTACAO R ON R.nroregtributacao = X.NROREGTRIBUTACAO
                                           LEFT JOIN NAGT_DEPARA_TRIB_745029 PP ON 1=1 
                 WHERE 1=1
                   AND UFCLIENTEFORNEC = UFEMPRESA
                   AND (X.NROTRIBUTACAO = 12
                   AND (X.NROREGTRIBUTACAO = 14 AND TIPTRIBUTACAO = 'SC'
                     OR X.NROREGTRIBUTACAO = 15 AND TIPTRIBUTACAO = 'SC')
                     
                     OR X.NROTRIBUTACAO = 704
                    AND(X.NROREGTRIBUTACAO = 13 AND TIPTRIBUTACAO = 'SC'
                     OR X.NROREGTRIBUTACAO = 12 AND TIPTRIBUTACAO IN ('EI', 'EM', 'ED','SC')
                     OR X.NROREGTRIBUTACAO = 11 AND TIPTRIBUTACAO IN ('EI', 'EM', 'ED','SC') ))
                     
                   AND NOT EXISTS (SELECT 1 FROM MAP_TRIBUTACAOUF D 
                                WHERE 1=1
                                  AND D.NROTRIBUTACAO = PP.NROTRIBUTACAO
                                  AND D.NROREGTRIBUTACAO = X.NROREGTRIBUTACAO
                                  AND D.UFEMPRESA = X.UFEMPRESA
                                  AND D.UFCLIENTEFORNEC = X.UFCLIENTEFORNEC
                                  AND D.TIPTRIBUTACAO = X.TIPTRIBUTACAO);
                  
SELECT * FROM MAP_TRIBUTACAOUF X WHERE NROTRIBUTACAO = 911 AND NROREGTRIBUTACAO > 11 AND UFEMPRESA = UFCLIENTEFORNEC;

