CREATE OR REPLACE FUNCTION CONSINCO.NAGF_KILL_SESSIONS (p_usuario VARCHAR2) RETURN VARCHAR2 IS
                                                                   usuario_encontrado NUMBER;
BEGIN
  
  SELECT COUNT(*)
  INTO usuario_encontrado
  FROM GE_USUARIO
  WHERE CODUSUARIO = p_usuario;-- AND NVL(NIVEL, 3) <= 3;

  IF usuario_encontrado > 0 THEN
    FOR t IN (SELECT SID, SERIAL#, INST_ID
              FROM GV$SESSION 
             WHERE PROGRAM IN ('Recebimento.exe', 'Compras.exe')
               AND GV$SESSION.type != 'BACKGROUND'
               AND STATUS != 'ACTIVE'
               AND CLIENT_IDENTIFIER = p_usuario)
    LOOP
      BEGIN
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''||t.SID||', '||t.SERIAL#||', @'||t.INST_ID||''' IMMEDIATE';
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ERRO: ' || t.SID);
      END;
    END LOOP;

    RETURN 'Sessões do usuário '|| p_usuario ||' encerradas com sucesso.';
  ELSE
    RETURN 'Usuário '|| p_usuario ||' não encontrado! Verifique novamente.';
  END IF;
END;

SELECT CONSINCO.NAGF_KILL_SESSIONS(:LT1) STATUS FROM DUAL;
