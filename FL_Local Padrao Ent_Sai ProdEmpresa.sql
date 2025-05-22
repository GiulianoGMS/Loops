DECLARE 
    i INTEGER := 0;
    total INTEGER := 0;
    /* Criei para registrar o log do loop enquanto está executando */
    /* Pode consultar na tabela GLN_LOG_PROCESSO_LOOP o andamento */
    PROCEDURE ATUALIZAR_LOG(p_total NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION; -- acho que nao precisa mas ta ai
    
    BEGIN
        MERGE INTO GLN_LOG_PROCESSO_LOOP L
        USING (SELECT 'TOTAL_ALTERADO' AS ID FROM DUAL) D
        ON (L.MENSAGEM = D.ID)
        WHEN MATCHED THEN 
            UPDATE SET L.DATA_LOG = SYSTIMESTAMP, L.TOTAL = p_total
        WHEN NOT MATCHED THEN 
            INSERT (MENSAGEM, DATA_LOG, TOTAL) 
            VALUES ('TOTAL_ALTERADO', SYSTIMESTAMP, p_total);

        COMMIT;
    END ATUALIZAR_LOG;
    
BEGIN
    FOR rec IN (SELECT X.NROEMPRESA, SEQPRODUTO
                  FROM MRL_PRODUTOEMPRESA X INNER JOIN MRL_LOCAL ENT ON ENT.SEQLOCAL = X.LOCENTRADA AND ENT.NROEMPRESA = X.NROEMPRESA
                                            INNER JOIN MRL_LOCAL SAI ON SAI.SEQLOCAL = X.LOCENTRADA AND SAI.NROEMPRESA = X.NROEMPRESA
                 WHERE X.NROEMPRESA = 603
                   AND (X.LOCENTRADA != 168 OR X.LOCSAIDA != 168)
                )
    LOOP
        i := i + 1;
        total := total + 1;
        
        UPDATE MRL_PRODUTOEMPRESA X SET X.LOCENTRADA = 168,
                                        X.LOCSAIDA   = 168
                                  WHERE X.SEQPRODUTO = rec.SEQPRODUTO
                                    AND X.NROEMPRESA = rec.NROEMPRESA;
        
        IF i = 100 THEN -- Define o Commit por quantidade de linhas
            COMMIT;
            ATUALIZAR_LOG(total);  -- Atualiza o total no log
            i := 0;
        END IF;
    END LOOP;

    COMMIT;
    ATUALIZAR_LOG(total); -- Atualiza o total final
END;
