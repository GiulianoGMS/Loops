CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_GERALOTECOMPRA AS
BEGIN
DECLARE
      i INTEGER := 0;
   -- Define como N a geração no dia da semana dos lotes que existem configuracao na tabela de controle
      BEGIN
        FOR g IN (SELECT D.SEQLOTEMODELO, D.HORAMIN FROM CONSINCO.NAGV_BUSCADTAPEDIDO D
                   WHERE EXISTS (SELECT SEQGERCOMPRA FROM CONSINCO.MAC_GERCOMPRA Z 
                                  WHERE Z.SEQGERCOMPRA = D.SEQLOTEMODELO
                                    AND(Z.AGENDADOMINGO = 'S' OR
                                        Z.AGENDASEGUNDA = 'S' OR
                                        Z.AGENDATERCA   = 'S' OR
                                        Z.AGENDAQUARTA  = 'S' OR
                                        Z.AGENDAQUINTA  = 'S' OR
                                        Z.AGENDASEXTA   = 'S' OR
                                        Z.AGENDASABADO  = 'S')))
                 
    LOOP
      BEGIN
        UPDATE CONSINCO.MAC_GERCOMPRA X SET X.AGENDADOMINGO = 'N',
                                            X.AGENDASEGUNDA = 'N',
                                            X.AGENDATERCA   = 'N',
                                            X.AGENDAQUARTA  = 'N',
                                            X.AGENDAQUINTA  = 'N',
                                            X.AGENDASEXTA   = 'N',
                                            X.AGENDASABADO  = 'N'
                                      WHERE X.SEQGERCOMPRA = G.SEQLOTEMODELO
                                        AND X.TIPOLOTE = 'M';
                                      
      COMMIT;
     END;
    END LOOP;
   -- Busca se existe lote configurado com data/hora e min igual a data atual para geração do lote
        FOR t IN (SELECT D.SEQLOTEMODELO, D.HORAMIN FROM CONSINCO.NAGV_BUSCADTAPEDIDO D 
                   WHERE 1=1
                     AND SYSDATE >= TO_DATE(TO_CHAR(D.DATA_VALIDA, 'DD/MM/YYYY')||' '||D.HORAMIN, 'DD/MM/YYYY HH24:MI')
                     AND NOT EXISTS (SELECT 1 FROM CONSINCO.MAC_GERCOMPRA Y WHERE Y.SEQGERMODELOCOMPRA = D.SEQLOTEMODELO AND TRUNC(DTAHORINCLUSAO) = TRUNC(SYSDATE))
                   ORDER BY HORAMIN ASC)

    LOOP
      BEGIN
   -- Cria o lote
      i := i+1;
      CONSINCO.NAGP_spMac_GeraLoteCompra(TRUNC(SYSDATE), 'N',t.SEQLOTEMODELO);
   -- Insere log na tabela de logs caso a geração seja realizada com sucesso
      INSERT INTO CONSINCO.NAGT_LOGGERAABASTAUTO VALUES (T.SEQLOTEMODELO, SYSDATE, 'JOBGERALOTE', 'GERADO', 'COMPRAS');
      IF i = 1 THEN COMMIT;
      i := 0;
   -- Teste - Envia email quando o lote for criado com sucesso
      CONSINCO.SP_ENVIA_EMAIL(CONSINCO.C5_TP_PARAM_SMTP(1),
                            'giuliano.gomes@nagumo.com.br',                         -- DESTINÁRIO                                                   
                            'Lote de Compras gerado com sucesso! - Lote Modelo: '           || T.SEQLOTEMODELO, -- ASSUNTO                                   
                            'Hora Configurada: '||T.HORAMIN                                 ||CHR(10)||
                            'Data: '||TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:Mi:ss')             ||CHR(10)||
                            '* O lote de compras foi gerado com sucesso! *', 'N');  -- MENSAGEM
      END IF;
      
      EXCEPTION
        
        WHEN OTHERS THEN
   -- Insere logs na tabela de logs caso conste erro
         INSERT INTO CONSINCO.NAGT_LOGGERAABASTAUTO VALUES (T.SEQLOTEMODELO, SYSDATE, 'JOBGERALOTE', 'ERRO', 'COMPRAS');
         COMMIT;
   -- Envia e-mail quando pedido apresentar erro na geração
         CONSINCO.SP_ENVIA_EMAIL(CONSINCO.C5_TP_PARAM_SMTP(1),
                            'giuliano.gomes@nagumo.com.br;ricardo.santana@nagumo.com.br',                         -- DESTINÁRIO                                                   
                            'Erro na geração de lote de compras - Lote Modelo: '              || T.SEQLOTEMODELO, -- ASSUNTO                                   
                            'Lote Modelo: '|| T.SEQLOTEMODELO                                 ||CHR(10)||
                            'Data:   '     || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:Mi:ss')       ||CHR(10)||
                            '* Erro na geração de lote de compras pelo Job *', 'N');  -- MENSAGEM
      COMMIT;
      END;
    END LOOP;
    COMMIT;
  END;
END;
