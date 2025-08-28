-- Script criado apenas para utilização nos CDs, pois ira retornar o saldo para o local DEPOSITO

BEGIN
  FOR t IN (SELECT QUANTIDADE, AI.SEQPRODUTO, AI.NROEMPRESA FROM MFL_DOCTOFISCAL A INNER JOIN MFL_DFITEM AI ON AI.SEQNF = A.SEQNF WHERE A.NFECHAVEACESSO = '35250807705530001407550010002422414456336047')
    
  LOOP
    UPDATE MRL_PRODLOCAL X SET X.ESTOQUE = ESTOQUE + t.QUANTIDADE
                         WHERE X.NROEMPRESA = t.NROEMPRESA
                           AND X.SEQPRODUTO = t.SEQPRODUTO
                           AND EXISTS (SELECT 1 
                                         FROM MRL_LOCAL A
                                        WHERE A.NROEMPRESA = X.NROEMPRESA
                                          AND A.LOCAL = 'DEPOSITO'
                                          AND A.SEQLOCAL = X.SEQLOCAL);
                                          
    UPDATE MRL_PRODUTOEMPRESA D SET D.ESTQDEPOSITO = ESTQDEPOSITO + t.QUANTIDADE
                              WHERE D.NROEMPRESA = t.NROEMPRESA
                                AND D.SEQPRODUTO = t.SEQPRODUTO;
    
 END LOOP;
END;
