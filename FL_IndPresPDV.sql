Job: MONITORPDV.NAGJ_PALIAT_INDPRES_PDV

BEGIN
    
    -- Para cada nota no LOOP, atualiza o XML na tb_doctonfexml, faz insert do controle e commita
    
    FOR doc IN (SELECT A.NROEMPRESA, A.NROCHECKOUT, A.SEQDOCTO
                  FROM tb_docto a INNER JOIN tb_doctonfe b ON a.nroempresa  = b.nroempresa
                                                          AND a.nrocheckout = b.nrocheckout
                                                          AND a.seqdocto    = b.seqdocto
                 WHERE a.dtamovimento = TRUNC(SYSDATE)
                   AND b.protocoloenvio IS NULL
                   AND B.CODRETORNO = 217
                   -- Se ja corrigiu, nao entra no loop
                   AND NOT EXISTS (SELECT 1 FROM NAGT_DOCTONFE_INDPRES_LOG X WHERE X.NROEMPRESA = A.NROEMPRESA AND X.NROCHECKOUT = A.NROCHECKOUT AND X.SEQDOCTO = A.SEQDOCTO))
      LOOP
        
    UPDATE tb_doctonfexml c
       SET c.xml = REPLACE(c.xml,
                           '<indPres>4</indPres>',
                           '<indPres>1</indPres>')
                           
     WHERE C.NROEMPRESA  = doc.NROEMPRESA
       AND C.NROCHECKOUT = doc.NROCHECKOUT
       AND C.SEQDOCTO    = doc.SEQDOCTO;
       
    -- Grava log para controle do que foi atualizado
    
    INSERT INTO monitorpdv.NAGT_DOCTONFE_INDPRES_LOG VALUES (SYSDATE, DOC.NROEMPRESA, DOC.SEQDOCTO, DOC.NROCHECKOUT);
    
    COMMIT;
    
    END LOOP; 
    
END;
