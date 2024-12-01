BEGIN
  FOR T IN (SELECT NROEMPRESA 
              FROM dwnagt_dadosempresa A 
             WHERE TIPO = 'CD' 
               AND NROEMPRESA NOT IN (504, 505))
  LOOP
    BEGIN
      CONSINCO.NAGP_GERA_ARQ_CD_FROMDEP(T.NROEMPRESA);
      CONSINCO.NAGP_GERA_ARQ_CD_TODEP(T.NROEMPRESA);

    EXCEPTION
      WHEN OTHERS THEN

        DBMS_OUTPUT.PUT_LINE('Erro ao processar empresa: ' || T.NROEMPRESA || 
                             ' - ' || SQLERRM);
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Processamento concluído!');
END;
