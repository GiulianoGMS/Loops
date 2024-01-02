-- Ticket 338287

CREATE TABLE CONSINCO.NAGT_MAP_TRIBUTACAOUF_BK2 AS
SELECT * FROM CONSINCO.MAP_TRIBUTACAOUF;

-- De/Para trib a serem alteradas + UFs

CREATE TABLE CONSINCO.NAGT_DP_TRIB (NROTRIBUTACAO NUMBER(5), UF VARCHAR2(2));
SELECT * FROM CONSINCO.NAGT_DP_TRIB

-------------

SELECT *
  FROM CONSINCO.MAP_TRIBUTACAOUF X
 WHERE X.NROTRIBUTACAO = 12
   AND X.NROREGTRIBUTACAO = 7
   AND UFEMPRESA = 'SP'
   --AND UFCLIENTEFORNEC = 'SP'
   AND TIPTRIBUTACAO IN ('EI', 'ED', 'SI', 'SC', 'SN')

-------------

-- SP

DECLARE
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (SELECT *
                FROM CONSINCO.MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO = 12
                 AND X.NROREGTRIBUTACAO = 7
                 AND UFEMPRESA = 'SP'
                 AND TIPTRIBUTACAO IN ('EI', 'ED', 'SI', 'SC', 'SN')
              )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERTRIBUTADO = T.PERTRIBUTADO,
                                              Z.PERISENTO = T.PERISENTO,
                                              Z.PEROUTRO = T.PEROUTRO,
                                              Z.PERALIQUOTA = T.PERALIQUOTA,
                                              Z.PERACRESCST = T.PERACRESCST,
                                              Z.PERALIQUOTAST = T.PERALIQUOTAST,
                                              Z.INDAPROPRIAST = T.INDAPROPRIAST,
                                              Z.INDPAUTAICMS = T.INDPAUTAICMS,
                                              Z.PERICMSANTECIPADO = T.PERICMSANTECIPADO,
                                              Z.PERICMSPRESUMIDO = T.PERICMSPRESUMIDO,
                                              Z.OBSERVACAO = T.OBSERVACAO,
                                              Z.SITUACAONF = T.SITUACAONF,
                                              Z.PERALIQICMSCALCPRECO = T.PERALIQICMSCALCPRECO,
                                              Z.INDSOMAIPIBASEICMS = T.INDSOMAIPIBASEICMS,
                                              Z.INDREPLICACAO = T.INDREPLICACAO,
                                              Z.INDGEROUREPLICACAO = T.INDGEROUREPLICACAO,
                                              Z.PERALIQFECP = T.PERALIQFECP,
                                              Z.PERBASEFECP = T.PERBASEFECP,
                                              Z.PERACRESCICMSANTEC = T.PERACRESCICMSANTEC,
                                              Z.PERDESPICMS = T.PERDESPICMS,
                                              Z.INDSOMAIPIBASEST = T.INDSOMAIPIBASEST,
                                              Z.PERALIQICMSDIF = T.PERALIQICMSDIF,
                                              Z.INDREDUZBASEST = T.INDREDUZBASEST,
                                              Z.DTAALTERACAO = T.DTAALTERACAO,
                                              Z.USUALTERACAO = T.USUALTERACAO,
                                              Z.ALIQUOTAICMSPMC = T.ALIQUOTAICMSPMC,
                                              Z.RESSARCSTVENDA = T.RESSARCSTVENDA,
                                              Z.PERALIQFECOP = T.PERALIQFECOP,
                                              Z.PERCREDCALCVPE = T.PERCREDCALCVPE,
                                              Z.PERALIQUOTAVPE = T.PERALIQUOTAVPE,
                                              Z.PERALIQUOTATARE = T.PERALIQUOTATARE,
                                              Z.PERTRIBUTST = T.PERTRIBUTST,
                                              Z.TIPREDUCICMSCALCST = T.TIPREDUCICMSCALCST,
                                              Z.TIPCALCICMSSELO = T.TIPCALCICMSSELO,
                                              Z.SITUACAONFPIS = T.SITUACAONFPIS,
                                              Z.SITUACAONFCOFINS = T.SITUACAONFCOFINS,
                                              Z.CODANTECIPST = T.CODANTECIPST,
                                              Z.DIAVENCTOST = T.DIAVENCTOST,
                                              Z.INDCALCSTALIQCALCPRC = T.INDCALCSTALIQCALCPRC,
                                              Z.TIPOCALCICMSFISCI = T.TIPOCALCICMSFISCI,
                                              Z.INDBASEICMSLF = T.INDBASEICMSLF,
                                              Z.PERPISDIF = T.PERPISDIF,
                                              Z.PERCOFINSDIF = T.PERCOFINSDIF,
                                              Z.PERALIQUOTASTCARGAGLIQ = T.PERALIQUOTASTCARGAGLIQ,
                                              Z.INDCALCSTCONFENT = T.INDCALCSTCONFENT,
                                              Z.SITUACAONFIPI = T.SITUACAONFIPI,
                                              Z.CODOBSERVACAO = T.CODOBSERVACAO,
                                              Z.PERACRESICMSRET = T.PERACRESICMSRET,
                                              Z.PERALIQICMSRET = T.PERALIQICMSRET,
                                              Z.PERISENTOST = T.PERISENTOST,
                                              Z.PEROUTROST = T.PEROUTROST,
                                              Z.NROBASEEXPORTACAO = T.NROBASEEXPORTACAO,
                                              Z.TIPCALCFECP = T.TIPCALCFECP,
                                              Z.INDBASECEMPERCREDUZIDA = T.INDBASECEMPERCREDUZIDA,
                                              Z.PERBASEPIS = T.PERBASEPIS,
                                              Z.PERBASECOFINS = T.PERBASECOFINS,
                                              Z.SITUACAONFSIMPLESNAC = T.SITUACAONFSIMPLESNAC,
                                              Z.INDREDBASEICMSSTSEMDESP = T.INDREDBASEICMSSTSEMDESP,
                                              Z.CALCICMSDESCSUFRAMA = T.CALCICMSDESCSUFRAMA,
                                              Z.CALCICMSSTDESCSUFRAMA = T.CALCICMSSTDESCSUFRAMA,
                                              Z.PERPMC = T.PERPMC,
                                              Z.SEQCONVPROTOCOLOGNRE = T.SEQCONVPROTOCOLOGNRE,
                                              Z.INDSOMAIPIBASEANTPRES = T.INDSOMAIPIBASEANTPRES,
                                              Z.CODNATREC = T.CODNATREC,
                                              Z.SEQNATREC = T.SEQNATREC,
                                              Z.INDCALCICMSVPE = T.INDCALCICMSVPE,
                                              Z.INDDEDUZDESCBASEST = T.INDDEDUZDESCBASEST,
                                              Z.PERTRIBUTADOSUFRAMAICMS = T.PERTRIBUTADOSUFRAMAICMS,
                                              Z.PERACRESCICMSANTECIP = T.PERACRESCICMSANTECIP,
                                              Z.PERREDALIQ = T.PERREDALIQ,
                                              Z.INDBASECALCESTORNODIFALIQRJ = T.INDBASECALCESTORNODIFALIQRJ,
                                              Z.SITUACAONFDEV = T.SITUACAONFDEV,
                                              Z.PERICMSRESOLUCAO13 = T.PERICMSRESOLUCAO13,
                                              Z.PERALIQICMSDIFER = T.PERALIQICMSDIFER,
                                              Z.INDSOMAIPIBASEICMSDIFER = T.INDSOMAIPIBASEICMSDIFER,
                                              Z.INDSOMAFRETEBASEIPI = T.INDSOMAFRETEBASEIPI,
                                              Z.PERMAJORACAOCOFINSIMPORT = T.PERMAJORACAOCOFINSIMPORT,
                                              Z.INDUTILCUSTOMESBASE = T.INDUTILCUSTOMESBASE,
                                              Z.PERCARGATRIBMEDIA = T.PERCARGATRIBMEDIA,
                                              Z.PERACRESCSTRESOLUCAO13 = T.PERACRESCSTRESOLUCAO13,
                                              Z.PERMINICMSSTRET = T.PERMINICMSSTRET,
                                              Z.PERCREGIMEATAC = T.PERCREGIMEATAC,
                                              Z.PERTRIBUTADOCALC = T.PERTRIBUTADOCALC,
                                              Z.PERISENTOCALC = T.PERISENTOCALC,
                                              Z.PEROUTROCALC = T.PEROUTROCALC,
                                              Z.CODOBSERVACAOCTE = T.CODOBSERVACAOCTE,
                                              Z.PERTRIBUTADOANTEC = T.PERTRIBUTADOANTEC,
                                              Z.PERISENTOANTEC = T.PERISENTOANTEC,
                                              Z.PEROUTROANTEC = T.PEROUTROANTEC,
                                              Z.INDAPLICACRESCSTCARGALIQ = T.INDAPLICACRESCSTCARGALIQ,
                                              Z.PERALIQSTCARGALIQRESOLUCAO13 = T.PERALIQSTCARGALIQRESOLUCAO13,
                                              Z.INDCALCSTEMBUTPROD = T.INDCALCSTEMBUTPROD,
                                              Z.PERALIQICMSSOLICIT = T.PERALIQICMSSOLICIT,
                                              Z.PERTRIBUTADORESOL13 = T.PERTRIBUTADORESOL13,
                                              Z.PERISENTORESOL13 = T.PERISENTORESOL13,
                                              Z.PEROUTRORESOL13 = T.PEROUTRORESOL13,
                                              Z.INDCALCICMSDESONOUTROS = T.INDCALCICMSDESONOUTROS,
                                              Z.INDCALCICMSCREDCUSTO = T.INDCALCICMSCREDCUSTO,
                                              Z.PERREDCARGATRIBDI = T.PERREDCARGATRIBDI,
                                              Z.PERMAJORACAOPISIMPORT = T.PERMAJORACAOPISIMPORT,
                                              Z.PERALIQUOTADESTINO = T.PERALIQUOTADESTINO,
                                              Z.TIPOCALCICMSPARTILHA = T.TIPOCALCICMSPARTILHA,
                                              Z.INDTIPOSOMAIPIICMSANTEC = T.INDTIPOSOMAIPIICMSANTEC,
                                              Z.INDUTILREDPRESUMST = T.INDUTILREDPRESUMST,
                                              Z.TIPOCALCPRESUMIDO = T.TIPOCALCPRESUMIDO,
                                              Z.INDREDICMSCAL = T.INDREDICMSCAL,
                                              Z.SITUACAONFCALC = T.SITUACAONFCALC,
                                              Z.PERALIQICMSDESON = T.PERALIQICMSDESON,
                                              Z.INDCALCICMSANTCUSTO = T.INDCALCICMSANTCUSTO,
                                              Z.CODOBSERVACAODEV = T.CODOBSERVACAODEV,
                                              Z.PERALIQICMSCALCRESOL13 = T.PERALIQICMSCALCRESOL13,
                                              Z.SEQFORMULAFEEF = T.SEQFORMULAFEEF,
                                              Z.BASEFCPST = T.BASEFCPST,
                                              Z.PERALIQFCPST = T.PERALIQFCPST,
                                              Z.TIPCALCFCPST = T.TIPCALCFCPST,
                                              Z.BASEFCPICMS = T.BASEFCPICMS,
                                              Z.PERALIQFCPICMS = T.PERALIQFCPICMS,
                                              Z.TIPCALCFCPICMS = T.TIPCALCFCPICMS,
                                              Z.INDCALCICMSEFETIVO = T.INDCALCICMSEFETIVO,
                                              Z.PERREDBCICMSEFET = T.PERREDBCICMSEFET,
                                              Z.TIPOCALCICMSBONIF = T.TIPOCALCICMSBONIF,
                                              Z.SITUACAONFBONIF = T.SITUACAONFBONIF,
                                              Z.INDCONTRAPARTIDAST = T.INDCONTRAPARTIDAST,
                                              Z.INDUTILICMSCALCREDFCPST = T.INDUTILICMSCALCREDFCPST,
                                              Z.PERLIMREDPMC = T.PERLIMREDPMC,
                                              Z.CODAJUSTEINFAD = T.CODAJUSTEINFAD,
                                              Z.MOTIVODESONERACAO = T.MOTIVODESONERACAO,
                                              Z.PERDIFERIDO = T.PERDIFERIDO,
                                              Z.CODAJUSTEINFADDEV = T.CODAJUSTEINFADDEV,
                                              Z.SEQTRIBUTACAOUFEDI = T.SEQTRIBUTACAOUFEDI,
                                              Z.TIPAPROPICMSFRETE = T.TIPAPROPICMSFRETE,
                                              Z.INDCALCULOICMSANTECIPADO = T.INDCALCULOICMSANTECIPADO,
                                              Z.INDCALCSTDIFAL = T.INDCALCSTDIFAL,
                                              Z.PERALIQICMSDIFERRESOL13 = T.PERALIQICMSDIFERRESOL13,
                                              Z.INDCREDDEBICMSOPST = T.INDCREDDEBICMSOPST,
                                              Z.CODMOTIVORESSARCRS = T.CODMOTIVORESSARCRS,
                                              Z.TIPCALCULODIFAL = T.TIPCALCULODIFAL,
                                      
                                        WHERE 1=1
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO
                                          AND Z.UFEMPRESA = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC = T.UFCLIENTEFORNEC
                                          AND Z.NROTRIBUTACAO IN (SELECT SP.NROTRIBUTACAO FROM CONSINCO.NAGT_DP_TRIB SP WHERE SP.UF = 'SP')
                                          AND Z.TIPTRIBUTACAO = T.TIPTRIBUTACAO
                                          
            IF i = 10 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
     COMMIT;
     END;
     
 -- RJ
 
 DECLARE
  i INTEGER := 0;
  
  BEGIN 
    FOR t IN (SELECT *
                FROM CONSINCO.MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO = 12
                 AND X.NROREGTRIBUTACAO = 7
                 AND UFEMPRESA = 'RJ'
                 AND TIPTRIBUTACAO IN ('EI', 'ED', 'SI', 'SC', 'SN')
              )
                 
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERTRIBUTADO = T.PERTRIBUTADO,
                                              Z.PERISENTO = T.PERISENTO,
                                              Z.PEROUTRO = T.PEROUTRO,
                                              Z.PERALIQUOTA = T.PERALIQUOTA,
                                              Z.PERACRESCST = T.PERACRESCST,
                                              Z.PERALIQUOTAST = T.PERALIQUOTAST,
                                              Z.INDAPROPRIAST = T.INDAPROPRIAST,
                                              Z.INDPAUTAICMS = T.INDPAUTAICMS,
                                              Z.PERICMSANTECIPADO = T.PERICMSANTECIPADO,
                                              Z.PERICMSPRESUMIDO = T.PERICMSPRESUMIDO,
                                              Z.OBSERVACAO = T.OBSERVACAO,
                                              Z.SITUACAONF = T.SITUACAONF,
                                              Z.PERALIQICMSCALCPRECO = T.PERALIQICMSCALCPRECO,
                                              Z.INDSOMAIPIBASEICMS = T.INDSOMAIPIBASEICMS,
                                              Z.INDREPLICACAO = T.INDREPLICACAO,
                                              Z.INDGEROUREPLICACAO = T.INDGEROUREPLICACAO,
                                              Z.PERALIQFECP = T.PERALIQFECP,
                                              Z.PERBASEFECP = T.PERBASEFECP,
                                              Z.PERACRESCICMSANTEC = T.PERACRESCICMSANTEC,
                                              Z.PERDESPICMS = T.PERDESPICMS,
                                              Z.INDSOMAIPIBASEST = T.INDSOMAIPIBASEST,
                                              Z.PERALIQICMSDIF = T.PERALIQICMSDIF,
                                              Z.INDREDUZBASEST = T.INDREDUZBASEST,
                                              Z.DTAALTERACAO = T.DTAALTERACAO,
                                              Z.USUALTERACAO = T.USUALTERACAO,
                                              Z.ALIQUOTAICMSPMC = T.ALIQUOTAICMSPMC,
                                              Z.RESSARCSTVENDA = T.RESSARCSTVENDA,
                                              Z.PERALIQFECOP = T.PERALIQFECOP,
                                              Z.PERCREDCALCVPE = T.PERCREDCALCVPE,
                                              Z.PERALIQUOTAVPE = T.PERALIQUOTAVPE,
                                              Z.PERALIQUOTATARE = T.PERALIQUOTATARE,
                                              Z.PERTRIBUTST = T.PERTRIBUTST,
                                              Z.TIPREDUCICMSCALCST = T.TIPREDUCICMSCALCST,
                                              Z.TIPCALCICMSSELO = T.TIPCALCICMSSELO,
                                              Z.SITUACAONFPIS = T.SITUACAONFPIS,
                                              Z.SITUACAONFCOFINS = T.SITUACAONFCOFINS,
                                              Z.CODANTECIPST = T.CODANTECIPST,
                                              Z.DIAVENCTOST = T.DIAVENCTOST,
                                              Z.INDCALCSTALIQCALCPRC = T.INDCALCSTALIQCALCPRC,
                                              Z.TIPOCALCICMSFISCI = T.TIPOCALCICMSFISCI,
                                              Z.INDBASEICMSLF = T.INDBASEICMSLF,
                                              Z.PERPISDIF = T.PERPISDIF,
                                              Z.PERCOFINSDIF = T.PERCOFINSDIF,
                                              Z.PERALIQUOTASTCARGAGLIQ = T.PERALIQUOTASTCARGAGLIQ,
                                              Z.INDCALCSTCONFENT = T.INDCALCSTCONFENT,
                                              Z.SITUACAONFIPI = T.SITUACAONFIPI,
                                              Z.CODOBSERVACAO = T.CODOBSERVACAO,
                                              Z.PERACRESICMSRET = T.PERACRESICMSRET,
                                              Z.PERALIQICMSRET = T.PERALIQICMSRET,
                                              Z.PERISENTOST = T.PERISENTOST,
                                              Z.PEROUTROST = T.PEROUTROST,
                                              Z.NROBASEEXPORTACAO = T.NROBASEEXPORTACAO,
                                              Z.TIPCALCFECP = T.TIPCALCFECP,
                                              Z.INDBASECEMPERCREDUZIDA = T.INDBASECEMPERCREDUZIDA,
                                              Z.PERBASEPIS = T.PERBASEPIS,
                                              Z.PERBASECOFINS = T.PERBASECOFINS,
                                              Z.SITUACAONFSIMPLESNAC = T.SITUACAONFSIMPLESNAC,
                                              Z.INDREDBASEICMSSTSEMDESP = T.INDREDBASEICMSSTSEMDESP,
                                              Z.CALCICMSDESCSUFRAMA = T.CALCICMSDESCSUFRAMA,
                                              Z.CALCICMSSTDESCSUFRAMA = T.CALCICMSSTDESCSUFRAMA,
                                              Z.PERPMC = T.PERPMC,
                                              Z.SEQCONVPROTOCOLOGNRE = T.SEQCONVPROTOCOLOGNRE,
                                              Z.INDSOMAIPIBASEANTPRES = T.INDSOMAIPIBASEANTPRES,
                                              Z.CODNATREC = T.CODNATREC,
                                              Z.SEQNATREC = T.SEQNATREC,
                                              Z.INDCALCICMSVPE = T.INDCALCICMSVPE,
                                              Z.INDDEDUZDESCBASEST = T.INDDEDUZDESCBASEST,
                                              Z.PERTRIBUTADOSUFRAMAICMS = T.PERTRIBUTADOSUFRAMAICMS,
                                              Z.PERACRESCICMSANTECIP = T.PERACRESCICMSANTECIP,
                                              Z.PERREDALIQ = T.PERREDALIQ,
                                              Z.INDBASECALCESTORNODIFALIQRJ = T.INDBASECALCESTORNODIFALIQRJ,
                                              Z.SITUACAONFDEV = T.SITUACAONFDEV,
                                              Z.PERICMSRESOLUCAO13 = T.PERICMSRESOLUCAO13,
                                              Z.PERALIQICMSDIFER = T.PERALIQICMSDIFER,
                                              Z.INDSOMAIPIBASEICMSDIFER = T.INDSOMAIPIBASEICMSDIFER,
                                              Z.INDSOMAFRETEBASEIPI = T.INDSOMAFRETEBASEIPI,
                                              Z.PERMAJORACAOCOFINSIMPORT = T.PERMAJORACAOCOFINSIMPORT,
                                              Z.INDUTILCUSTOMESBASE = T.INDUTILCUSTOMESBASE,
                                              Z.PERCARGATRIBMEDIA = T.PERCARGATRIBMEDIA,
                                              Z.PERACRESCSTRESOLUCAO13 = T.PERACRESCSTRESOLUCAO13,
                                              Z.PERMINICMSSTRET = T.PERMINICMSSTRET,
                                              Z.PERCREGIMEATAC = T.PERCREGIMEATAC,
                                              Z.PERTRIBUTADOCALC = T.PERTRIBUTADOCALC,
                                              Z.PERISENTOCALC = T.PERISENTOCALC,
                                              Z.PEROUTROCALC = T.PEROUTROCALC,
                                              Z.CODOBSERVACAOCTE = T.CODOBSERVACAOCTE,
                                              Z.PERTRIBUTADOANTEC = T.PERTRIBUTADOANTEC,
                                              Z.PERISENTOANTEC = T.PERISENTOANTEC,
                                              Z.PEROUTROANTEC = T.PEROUTROANTEC,
                                              Z.INDAPLICACRESCSTCARGALIQ = T.INDAPLICACRESCSTCARGALIQ,
                                              Z.PERALIQSTCARGALIQRESOLUCAO13 = T.PERALIQSTCARGALIQRESOLUCAO13,
                                              Z.INDCALCSTEMBUTPROD = T.INDCALCSTEMBUTPROD,
                                              Z.PERALIQICMSSOLICIT = T.PERALIQICMSSOLICIT,
                                              Z.PERTRIBUTADORESOL13 = T.PERTRIBUTADORESOL13,
                                              Z.PERISENTORESOL13 = T.PERISENTORESOL13,
                                              Z.PEROUTRORESOL13 = T.PEROUTRORESOL13,
                                              Z.INDCALCICMSDESONOUTROS = T.INDCALCICMSDESONOUTROS,
                                              Z.INDCALCICMSCREDCUSTO = T.INDCALCICMSCREDCUSTO,
                                              Z.PERREDCARGATRIBDI = T.PERREDCARGATRIBDI,
                                              Z.PERMAJORACAOPISIMPORT = T.PERMAJORACAOPISIMPORT,
                                              Z.PERALIQUOTADESTINO = T.PERALIQUOTADESTINO,
                                              Z.TIPOCALCICMSPARTILHA = T.TIPOCALCICMSPARTILHA,
                                              Z.INDTIPOSOMAIPIICMSANTEC = T.INDTIPOSOMAIPIICMSANTEC,
                                              Z.INDUTILREDPRESUMST = T.INDUTILREDPRESUMST,
                                              Z.TIPOCALCPRESUMIDO = T.TIPOCALCPRESUMIDO,
                                              Z.INDREDICMSCAL = T.INDREDICMSCAL,
                                              Z.SITUACAONFCALC = T.SITUACAONFCALC,
                                              Z.PERALIQICMSDESON = T.PERALIQICMSDESON,
                                              Z.INDCALCICMSANTCUSTO = T.INDCALCICMSANTCUSTO,
                                              Z.CODOBSERVACAODEV = T.CODOBSERVACAODEV,
                                              Z.PERALIQICMSCALCRESOL13 = T.PERALIQICMSCALCRESOL13,
                                              Z.SEQFORMULAFEEF = T.SEQFORMULAFEEF,
                                              Z.BASEFCPST = T.BASEFCPST,
                                              Z.PERALIQFCPST = T.PERALIQFCPST,
                                              Z.TIPCALCFCPST = T.TIPCALCFCPST,
                                              Z.BASEFCPICMS = T.BASEFCPICMS,
                                              Z.PERALIQFCPICMS = T.PERALIQFCPICMS,
                                              Z.TIPCALCFCPICMS = T.TIPCALCFCPICMS,
                                              Z.INDCALCICMSEFETIVO = T.INDCALCICMSEFETIVO,
                                              Z.PERREDBCICMSEFET = T.PERREDBCICMSEFET,
                                              Z.TIPOCALCICMSBONIF = T.TIPOCALCICMSBONIF,
                                              Z.SITUACAONFBONIF = T.SITUACAONFBONIF,
                                              Z.INDCONTRAPARTIDAST = T.INDCONTRAPARTIDAST,
                                              Z.INDUTILICMSCALCREDFCPST = T.INDUTILICMSCALCREDFCPST,
                                              Z.PERLIMREDPMC = T.PERLIMREDPMC,
                                              Z.CODAJUSTEINFAD = T.CODAJUSTEINFAD,
                                              Z.MOTIVODESONERACAO = T.MOTIVODESONERACAO,
                                              Z.PERDIFERIDO = T.PERDIFERIDO,
                                              Z.CODAJUSTEINFADDEV = T.CODAJUSTEINFADDEV,
                                              Z.SEQTRIBUTACAOUFEDI = T.SEQTRIBUTACAOUFEDI,
                                              Z.TIPAPROPICMSFRETE = T.TIPAPROPICMSFRETE,
                                              Z.INDCALCULOICMSANTECIPADO = T.INDCALCULOICMSANTECIPADO,
                                              Z.INDCALCSTDIFAL = T.INDCALCSTDIFAL,
                                              Z.PERALIQICMSDIFERRESOL13 = T.PERALIQICMSDIFERRESOL13,
                                              Z.INDCREDDEBICMSOPST = T.INDCREDDEBICMSOPST,
                                              Z.CODMOTIVORESSARCRS = T.CODMOTIVORESSARCRS,
                                              Z.TIPCALCULODIFAL = T.TIPCALCULODIFAL
                                      
                                        WHERE 1=1
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO
                                          AND Z.UFEMPRESA = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC = T.UFCLIENTEFORNEC
                                          AND Z.NROTRIBUTACAO IN (SELECT SP.NROTRIBUTACAO FROM CONSINCO.NAGT_DP_TRIB SP WHERE SP.UF = 'RJ')
                                          AND Z.TIPTRIBUTACAO = T.TIPTRIBUTACAO;
                                          
            IF i = 10 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
     COMMIT;
     END;
