   /* Backup */

CREATE TABLE NAGT_BACKUP_GLN_NOMEECOMM AS

SELECT A.SEQPRODUTO,
       A.NOMEPRODUTOECOMM ANTIGO,
       B.NOMEPRODUTOECOMM NOVO_NOME
  FROM MAP_PRODUTO A INNER JOIN NAGT_DEPARAGLN B
    ON A.SEQPRODUTO = B.SEQPRODUTO;
  
    /* Tabela de Log do Loop */
  
CREATE TABLE GLN_LOG_PROCESSO_LOOP (
    MENSAGEM VARCHAR2(50) PRIMARY KEY,  -- Sempre será 'TOTAL_ALTERADO'
    DATA_LOG TIMESTAMP DEFAULT SYSTIMESTAMP,
    TOTAL NUMBER
);

DECLARE 
    i INTEGER := 0;
    total INTEGER := 0;
    /* Criei para registrar o log do loop enquanto está executando */
    /* Pode consultar na tabela GLN_LOG_PROCESSO_LOOP o andamento */
    PROCEDURE ATUALIZAR_LOG(p_total NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
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
    /*******/
    
BEGIN
    FOR rec IN (SELECT A.SEQPRODUTO,
                       A.NOMEPRODUTOECOMM ANTIGO,
                       B.NOMEPRODUTOECOMM NOVO_NOME
                  FROM MAP_PRODUTO A 
                 INNER JOIN NAGT_DEPARAGLN B 
                    ON A.SEQPRODUTO = B.SEQPRODUTO 
                   AND A.NOMEPRODUTOECOMM != B.NOMEPRODUTOECOMM)
    LOOP
        i := i + 1;
        total := total + 1;
        
        UPDATE MAP_PRODUTO P 
           SET P.NOMEPRODUTOECOMM = rec.NOVO_NOME,
               P.USUARIOALTERACAO = 'AT_DESC_HUM',
               P.DTAHORALTERACAO = SYSDATE
         WHERE P.SEQPRODUTO = rec.SEQPRODUTO;
        
        IF i = 10 THEN 
            COMMIT;
            ATUALIZAR_LOG(total);  -- Atualiza o total no log
            i := 0;
        END IF;
    END LOOP;

    COMMIT;
    ATUALIZAR_LOG(total); -- Atualiza o total final
END;
