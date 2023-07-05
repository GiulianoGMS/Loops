-- Comando para o Job: CONSINCO.NAG_SM_ENVIO_INCONSIST_CAD

declare
 
  vsHora           varchar2(2);
  vsSql            varchar2(2000);  
  
BEGIN
     -- XMLs já são processados pelo JOB CONSINCO.SM_GERA_RECEBTO_XML_AUTOMATICO
     -- Apenas vai pegar o departamento como variável
FOR X IN (  SELECT DEPARTAMENTO 
              FROM CONSINCO.NAGT_EMAILDEPTO X WHERE X.DEPARTAMENTO = 'CADASTRO'
                 )
                                   
               LOOP

     -- Envia e-mail com as notas inconsistentes que estão com inconsist. ref a Cadastro em HTML, 
     -- Apenas nos horários mencionados abaixo.
     -- Horario ja definido no JOB
     
     -- Caso apresente erro no disparo, não gera erro na execução do Job - Cipolla 11/02/2022
         vsSql := 'begin consinco.nagp_nfimpxml_incons_cad('||x.DEPARTAMENTO||');  EXCEPTION WHEN others THEN DBMS_OUTPUT.put_line('||x.DEPARTAMENTO||'); end;';
             
     execute immediate vsSql; 

    END LOOP; 
   END;

------------------------------------------------------

-- Procedure

CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_NFIMPXML_INCONS_CAD (pnDepartamento VARCHAR2) as

  vtexto         clob;
  vtitulo        clob;
  vemail         long;
  vmes           varchar2(100);
  vtexto1        clob;
  obj_param_smtp c5_tp_param_smtp;
  vdir           varchar2(2000);
  texto          sys.utl_file.file_type;
  varq           varchar2(2000);
  vlin           varchar2(4000);
  email_destino long;

  -- datas dos periodos de vendas
  vsDia                        varchar(2);
  vsmes                        varchar(2);
  vsano                        varchar(4);
  vnfilial                     number (3);
  --vnvlrtotoal                  number(38,5) :=0;
  --vnvlrsubtotoal                  number(38,5) :=0;


begin

   vtexto := '<HTML>
                              <BODY bgColor=#ffffff>

                            <TABLE width=60% cellspacing=0 cellpadding=0 >
                            <TR>
                                   <TD >

                                   </TD>
                                   <TR>
                                   <TD>
                                   </TD>
                                   </TR>
                                   <TR>
                                   <TD>
                                   </TD>
                                   </TR>

                            </TR>
                            </table>

                            <br />
                            <br />



                                <FONT size=1>
                                    <TABLE width=90% style=BORDER-COLLAPSE: collapse; margin-left:300px  width=900 border=1 cellspacing=0 cellpadding=0>
                                      <TBODY>


<thead>
    <TR>

    <th width="5%" bgColor=#4682b4 colspan=22>
      <B><FONT face=Calibri color=#FFFAFA size=5>Notas Inconsistentes no Recebimento</FONT></B>
    </th>
  </TR>


  <TR>
    <th width="6%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Empresa </FONT></B>
    </th>

    <th width="7%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Data do Lançamento</FONT></B>
    </th>

    <th width="6%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Número Nota</FONT></B>
    </th>

    <th width="20%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Fornecedor</FONT></B>
    </th>

    <th width="6%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Comprador</FONT></B>
    </th>

    <th width="7%" bgColor=#dceded >
      <B><FONT face=Calibri color=#336699 size=2> Tipo Inconsistência</FONT></B>
    </th>

  </TR>

</thead>';

  for xp in (
    -- Cadastro
 SELECT     DISTINCT (X.SEQAUXNOTAFISCAL),
                z.fantasia NROEMPRESA,
                to_char (X.DTAHORLANCTO,'DD/MM/YYYY HH24:MM:SS') DATA,
                X.NUMERONF,
               (SELECT GE.SEQPESSOA || ' - ' || GE.NOMERAZAO FROM consinco.GE_PESSOA GE WHERE GE.SEQPESSOA = X.SEQPESSOA) FORNECEDOR,

                (SELECT MAX(C.COMPRADOR)
                from CONSINCO.MAP_FAMDIVISAO A, CONSINCO.MAP_FAMILIA B, CONSINCO.MAX_COMPRADOR C , CONSINCO.MAP_PRODUTO P
                where 1 = 1
                AND A.NRODIVISAO = '1'
                AND A.SEQFAMILIA = B.SEQFAMILIA
                AND C.SEQCOMPRADOR = A.SEQCOMPRADOR
                AND P.SEQFAMILIA = B.SEQFAMILIA
                AND P.SEQPRODUTO = I.SEQPRODUTO  ) COMPRADOR,
                'CADASTRO' INCONSISTENCIA
FROM CONSINCO.MLF_AUXNOTAFISCAL X INNER JOIN CONSINCO.MLF_AUXNFITEM I ON (I.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL)
                                                                           inner join consinco.ge_empresa z on (z.nroempresa = x.nroempresa)

WHERE exists (SELECT 1 FROM CONSINCO.MLF_AUXNFINCONSISTENCIA Y
                                          WHERE 1=1
                                          AND Y.SEQAUXNOTAFISCAL = X.SEQAUXNOTAFISCAL
                                          AND (Y.TIPOINCONSIST = 'N' AND Y.Codinconsist IN (1,45,143,144,145,152,185,165,187,188,189,190,191,192,193,194,195,49,43,11,12,13,80,129)
                                           OR  Y.TIPOINCONSIST = 'P' AND Y.CODINCONSIST IN (1,176,177))
                                          AND Y.SEQAUXNFITEM <> 0  ) --- Inconsistencias de Cadatro
and       x.usulancto = 'CONSINCO' --- Apenas NF importadas automaticamente
AND      X.DTAHORLANCTO >= TO_DATE(SYSDATE, 'DD/MM/YYYY')-7
--and      x.nroempresa = pnNroEmpresa -- Não filtra a loja, envia todas para o Cadastro
 ORDER BY 5,6,7





) loop

   SELECT H.EMAIL
   INTO EMAIL_DESTINO
   FROM CONSINCO.NAGT_EMAILDEPTO H
   WHERE H.DEPARTAMENTO = pnDepartamento;

      vtexto := vtexto ||
              to_char(

                      '<TR>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  xp.nroempresa ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||   xp.data ||                 ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||   xp.numeronf ||       ' </FONT></TD>
                           <TD vAlign=top align=left ><FONT face=Calibri size=2> ' ||    SUBSTR(xp.fornecedor,1,70) ||     ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||   xp.comprador ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||   xp.inconsistencia ||    ' </FONT></TD>


                      <TR>');
  end loop;

---rodape
  vtexto := vtexto || '
                                          </tbody>
                                          </table>
                                          </font>
                                          <br>
                                          <br>
                                          <table width=80%>
                                          <tr>
                                              <tr>
                                              <td align=left>
                                              <FONT face=Calibri size=2><B>Este é um e-mail automático.<BR>
                                              </B></FONT><BR><BR>
                                          </td>
                                          </tr>


                                           <tr>
                                              <td align=left>
                                              <FONT face=Calibri color=#D3D3D3 size=2> Supermercados Nagumo - Depto TI - Sistemas. </FONT>
                                              </td>
                                           </tr>


                                           <tr>
                                              <td align=left>
                                              <FONT face=Calibri color=#D3D3D3 size=1> Desenvolvido por Cipolla </FONT>
                                              </td>
                                           </tr>


        </table>

                                            </BODY>
                                          </HTML>';




  vemail := email_destino;

  obj_param_smtp := c5_tp_param_smtp(1);

   sp_envia_email(obj_param      => obj_param_smtp,
                      psDestinatario => email_destino,
                      psAssunto      => 'Notas Inconsistentes no Recebimento - '|| TO_CHAR(SYSDATE,'DD/MM/YYYY'),
                      psMensagem     => vtexto,
                      psindusahtml   => 'S',
                      psAnexoBanco   => vdir || varq);

end;
