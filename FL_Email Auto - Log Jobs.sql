CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_LOGERROSEXECJOBS as

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

    <th width="5%" bgColor=#590404 colspan=22>
      <B><FONT face=Calibri color=#FFFAFA size=4>LOG - Jobs Failed to Execute</FONT></B>
    </th>
  </TR>


  <TR>
    <th width="6%" bgColor=#FFE8E8 >
      <B><FONT face=Calibri color=#760909 size=2>LOG_DATE</FONT></B>
    </th>

    <th width="7%" bgColor=#FFE8E8 >
      <B><FONT face=Calibri color=#760909 size=2>OWNER</FONT></B>
    </th>

    <th width="6%" bgColor=#FFE8E8 >
      <B><FONT face=Calibri color=#760909 size=2>JOB_NAME</FONT></B>
    </th>

    <th width="6%" bgColor=#FFE8E8 >
      <B><FONT face=Calibri color=#760909 size=2>STATUS</FONT></B>
    </th>

    <th width="20%" bgColor=#9C0A0A >
      <B><FONT face=Calibri color=#FFFAFA size=2>ERRORS</FONT></B>
    </th>

  </TR>

</thead>';

  FOR T IN (SELECT LOG_DATE, OWNER, JOB_NAME, STATUS, ERRORS FROM (
            SELECT DISTINCT LOG_DATE, OWNER, JOB_NAME, STATUS, ERRORS,
                   ROW_NUMBER() OVER(PARTITION BY (JOB_NAME) ORDER BY JOB_NAME) ODR

              FROM ALL_SCHEDULER_JOB_RUN_DETAILS X
             WHERE STATUS = 'FAILED'
               AND LOG_DATE > TRUNC(SYSDATE) - 1)

            --WHERE LOG_DATE > SYSDATE - INTERVAL '5' MINUTE
            HAVING MAX(ODR) = 1

            GROUP BY LOG_DATE, OWNER, JOB_NAME, STATUS, ERRORS)

        LOOP

   EMAIL_DESTINO := 'giuliano.gomes@nagumo.com.br';

      vtexto := vtexto ||
              to_char(

                      '<TR>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  t.LOG_DATE ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  t.OWNER    ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  t.JOB_NAME ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  t.STATUS   ||    ' </FONT></TD>
                           <TD vAlign=top align=middle ><FONT face=Calibri size=2> ' ||  SUBSTR(t.ERRORS,1,70) ||    ' </FONT></TD>


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
                                              <FONT face=Calibri color=#D3D3D3 size=1> Desenvolvido por Cipolla | Plagiado por Giuliano </FONT>
                                              </td>
                                           </tr>


        </table>

                                            </BODY>
                                          </HTML>';




  vemail := email_destino;

  obj_param_smtp := c5_tp_param_smtp(1);

   sp_envia_email(obj_param      => obj_param_smtp,
                      psDestinatario => email_destino,
                      psAssunto      => 'LOG - Jobs Failed to Execute - '|| TO_CHAR(SYSDATE,'DD/MM/YYYY'),
                      psMensagem     => vtexto,
                      psindusahtml   => 'S',
                      psAnexoBanco   => vdir || varq);

end;
