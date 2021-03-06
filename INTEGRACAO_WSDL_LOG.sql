PROMPT CREATE TABLE integracao_wsdl_log
CREATE TABLE integracao_wsdl_log (
  codigo         NUMBER(10,0)  NOT NULL,
  cod_integracao NUMBER(10,0)  NULL,
  data_envio     DATE          NULL,
  wsdl_log       CLOB          NULL,
  result2        XMLTYPE       AS () NULL,
  chave          VARCHAR2(20)  NULL,
  msg_resposta   VARCHAR2(300) NULL,
  campo_erro     VARCHAR2(40)  NULL,
  valor_campo    VARCHAR2(400) NULL,
  tip_reg        NUMBER(10,0)  NULL,
  result         CLOB          NULL
)
  STORAGE (
    NEXT       1024 K
  )
/

PROMPT ALTER TABLE integracao_wsdl_log ADD CONSTRAINT pk_integracao_wsdl_log PRIMARY KEY
ALTER TABLE integracao_wsdl_log
  ADD CONSTRAINT pk_integracao_wsdl_log PRIMARY KEY (
    codigo
  )
  USING INDEX
    STORAGE (
      NEXT       1024 K
    )
/

PROMPT CREATE OR REPLACE TRIGGER integwsdl_log_num
CREATE OR REPLACE TRIGGER integwsdl_log_num
before insert
ON integracao_wsdl_log
for each row
begin
select sq_integwsdl_log.nextval into :new.CODIGO from dual;
end;
/



PROMPT CREATE OR REPLACE VIEW vw_soap_candidatos_contratados
CREATE OR REPLACE VIEW vw_soap_candidatos_contratados (
  cod_candidato,
  cpf,
  xml
) AS
SELECT c.cod_candidato ,
      EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/CPF') ,
XMLELEMENT("soapenv:Body" ,
XMLELEMENT("rhow:RHOWS_RS_CANDIDATOInput"
       ,XMLELEMENT("rhow:P_ADICIONAL_A-VARCHAR2-IN")
       ,XMLELEMENT("rhow:P_ADICIONAL_B-VARCHAR2-IN")
       ,XMLELEMENT("rhow:P_ADICIONAL_C-VARCHAR2-IN")
       ,XMLELEMENT("rhow:P_ADICIONAL_D-VARCHAR2-IN")
       ,XMLELEMENT("rhow:P_BAIRRO-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/BAIRRO'), ' ') )
       ,XMLELEMENT("rhow:P_CATEG_CART_HABIL-VARCHAR2-IN", ( SELECT nome FROM tipo_documento WHERE codigo = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CNH/CNH_CATEGORIA')) )
       ,XMLELEMENT("rhow:P_CEP-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/CEP'), ' '))
       ,XMLELEMENT("rhow:P_CIDADE-VARCHAR2-IN", (SELECT nome FROM city WHERE codigo = EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/MUNICIPIO') ))
       ,XMLELEMENT("rhow:P_CIDADE_NASCTO-VARCHAR2-IN", (SELECT nome FROM city WHERE codigo = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/INFO_ADICIONAIS/CIDADE_NASC_ADICIONAL')))
       ,XMLELEMENT("rhow:P_COMPLEMENTO-VARCHAR2-IN",  LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/COMPLEMENTO'), ' '))
       ,XMLELEMENT("rhow:P_COMPL_CPF-VARCHAR2-IN", LTrim(SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/CPF'),10,2), ' '))
       ,XMLELEMENT("rhow:P_DAT_EXP_PIS_PASEP-VARCHAR2-IN", DECODE (EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_PIS') ,NULL, NULL,SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_PIS') ,9,2)||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_PIS') ,6,2)||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_PIS') ,1,4) ))
       ,XMLELEMENT("rhow:P_DAT_EXP_RG-VARCHAR2-IN", DECODE (EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_DATA_EMISAO'),NULL, NULL, SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_DATA_EMISAO') ,9,2) ||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_DATA_EMISAO') ,6,2)||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_DATA_EMISAO') ,1,4)))
       ,XMLELEMENT("rhow:P_DAT_NASCTO-VARCHAR2-IN", DECODE (EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/DATA_NASCIMENTO'),NULL, NULL, SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/DATA_NASCIMENTO') ,9,2) ||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/DATA_NASCIMENTO') ,6,2)||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/DATA_NASCIMENTO') ,1,4)))
       ,XMLELEMENT("rhow:P_DAT_VAL_CART_PROF-VARCHAR2-IN", Decode(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_CARTEIRA'),NULL, NULL, SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_CARTEIRA') ,9,2) ||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_CARTEIRA') ,6,2)||'/'||SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/DATA_VALIDADE_CARTEIRA') ,1,4)))
       ,XMLELEMENT("rhow:P_DDD_TEL-VARCHAR2-IN", EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/CONTATO/TELEFONES/VALOR[@ordem="1"]/DDD'))
       ,XMLELEMENT("rhow:P_DIG_RG-VARCHAR2-IN", null)
       ,XMLELEMENT("rhow:P_EMAIL-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/CONTATO/EMAIL'), ' '))
       ,XMLELEMENT("rhow:P_ENDERECO-VARCHAR2-IN", LTrim(LPad(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/ENDERECO'),60), ' '))
       ,XMLELEMENT("rhow:P_ESTADO-VARCHAR2-IN", (SELECT ACRREGION FROM region WHERE codigo =  EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/UF')))
       ,XMLELEMENT("rhow:P_ESTADO_EMIS_CART_PROF-VARCHAR2-IN",(SELECT ACRREGION FROM region WHERE codigo = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/CARTEIRA_TRABALHO_UF')) )
       ,XMLELEMENT("rhow:P_ESTADO_EMIS_RG-VARCHAR2-IN", (SELECT ACRREGION FROM region WHERE codigo = EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_UF')) )
       ,XMLELEMENT("rhow:P_ESTADO_NASCTO-VARCHAR2-IN", (SELECT ACRREGION FROM region WHERE fkcountry = 76 and codigo = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/INFO_ADICIONAIS/NATURALIDADE_ADICIONAL')))
       ,XMLELEMENT("rhow:P_EST_CIVIL-VARCHAR2-IN", (SELECT codigo_amx FROM lst_estado_civil WHERE CODIGO = EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/COD_ESTADO_CIVIL') ) )
       ,XMLELEMENT("rhow:P_GRAU_ESCOLARIDADE-VARCHAR2-IN", (SELECT cod_amx FROM lst_escolaridade WHERE CODIGO = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/INFO_ADICIONAIS/ESCOLARIDADE')))   -- lst_escolaridade
       ,XMLELEMENT("rhow:P_IDENTIFICACAO-VARCHAR2-IN", 'DEE315C7E8CBE23FFE7B9DE681881A97')
       ,XMLELEMENT("rhow:P_LETRA_CART_PROF-VARCHAR2-IN",  LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/CARTEIRA_TRABALHO_LETRA'), ' '))
   --  ,XMLELEMENT("rhow:P_NACIONALIDADE-VARCHAR2-IN", (SELECT COD_SIGLA FROM LST_NACIONALIDADE WHERE codigo = c.nacionalidade))
       ,XMLELEMENT("rhow:P_NACIONALIDADE-VARCHAR2-IN", (SELECT cod_sigla FROM lst_nacionalidade WHERE CODIGO = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/INFO_ADICIONAIS/NACIONALIDADE_ADICIONAL') ))
       ,XMLELEMENT("rhow:P_NOM_CANDIDATO-VARCHAR2-IN", LTrim(LPad(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/NOME_COMPLETO'),60), ' '))
       ,XMLELEMENT("rhow:P_NOM_MAE-VARCHAR2-IN", LTrim(LPad(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/NOME_MAE'),45), ' '))
       ,XMLELEMENT("rhow:P_NOM_PAI-VARCHAR2-IN", LTrim(LPad(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/NOME_PAI'),45), ' '))
       ,XMLELEMENT("rhow:P_NUMERO-VARCHAR2-IN",  LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/ENDERECO/ENDERECO_NUMERO'), ' '))
       ,XMLELEMENT("rhow:P_NUM_CART_HABIL-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CNH/CNH_NUMERO'), ' '))
       ,XMLELEMENT("rhow:P_NUM_CART_PROF-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/CARTEIRA_TRABALHO'), ' '))
       ,XMLELEMENT("rhow:P_NUM_CERT_RESERV-VARCHAR2-IN",  LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CERTIFICADO_RESERVISTA/CERTIFICADO_RESERVISTA'), ' '))
       ,XMLELEMENT("rhow:P_NUM_CPF-VARCHAR2-IN", LTrim(SUBSTR(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/CPF'),1,9), ' '))
       ,XMLELEMENT("rhow:P_NUM_REQUIS-NUMBER-IN", LTrim(EXTRACTVALUE(ps.dados,'/DADOS/NUMERO_VAGA_CLARO'), ' '))
       ,XMLELEMENT("rhow:P_NUM_RG-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG'), ' '))
       ,XMLELEMENT("rhow:P_NUM_TEL-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/CONTATO/TELEFONES/VALOR[@ordem="1"]/TELEFONE'), ' '))
       ,XMLELEMENT("rhow:P_NUM_TIT_ELEITOR-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/TITULO_ELEITOR/TITULO_ELEITOR'), ' '))
       ,XMLELEMENT("rhow:P_ORGAO_EMIS_RG-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/IDENTIDADE/RG_ORGAO_EXP'), ' '))
       ,XMLELEMENT("rhow:P_PAIS_NASCTO-VARCHAR2-IN", (SELECT cod_sigla FROM lst_nacionalidade WHERE CODIGO = EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/INFO_ADICIONAIS/NACIONALIDADE_ADICIONAL') ))
       ,XMLELEMENT("rhow:P_PIS_PASEP-VARCHAR2-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/NUMERO_PIS'), ' '))
       ,XMLELEMENT("rhow:P_RAMAL_TEL-VARCHAR2-IN")
       ,XMLELEMENT("rhow:P_RESULT-XMLTYPE-OUT", NULL)
       ,XMLELEMENT("rhow:P_SECAO_TIT_ELEITOR-NUMBER-IN", LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/TITULO_ELEITOR/SECAO_TITULO_ELEITOR'), ' '))
       ,XMLELEMENT("rhow:P_SERIE_CART_PROF-NUMBER-IN", num(LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/CARTEIRA_TRABALHO/CARTEIRA_TRABALHO_SERIE'), ' ')))
       ,XMLELEMENT("rhow:P_SEXO-VARCHAR2-IN", Decode((EXTRACTVALUE(c.dados,'/DADOS/INFORMACOES_PESSOAIS/INFOPESSOAL/SEXO')),1,'F',2,'M'))
       ,XMLELEMENT("rhow:P_ZONA_TIT_ELEITOR-NUMBER-IN",  LTrim(EXTRACTVALUE(c.dados,'/DADOS/DOCUMENTOS/TITULO_ELEITOR/ZONA_TITULO_ELEITOR'), ' '))
       ,XMLELEMENT("rhow:P_DAT_OCUPACAO-VARCHAR2-IN",  To_Char(CPS.data_admissao, 'DD/MM/YYYY') )
       ,XMLELEMENT("rhow:P_VAL_SAL-NUMBER-IN",REPLACE( NVL (NVL ((SELECT Trim(salario) FROM sal_carta_proposta WHERE codigo = (SELECT Max (codigo) FROM  sal_carta_proposta WHERE cod_proc_seletivo = PS.CODIGO)), (SELECT Trim(salario) FROM sal_movimentacao_interna WHERE codigo = (SELECT Max (codigo) FROM  sal_movimentacao_interna WHERE cod_proc_seletivo = PS.CODIGO))), 0),',','.'))
       ,XMLELEMENT("rhow:P_ID_FUNC-NUMBER-IN", (SELECT MATRICULA FROM FUNCIONARIO WHERE COD_CANDIDATO = C.cod_candidato))
)) xml
FROM candidato_dados c ,
     candidato_processo_seletivo cps,
     processo_seletivo           ps
WHERE c.cod_candidato = cps.cod_candidato
AND cps.cod_proc_seletivo       = ps.codigo
AND cps.cod_situacao_processo   = 6
AND ps.status IN (1,2)
AND cps.data_envio_ppl IS NULL
AND ( (SELECT doc_complementar_completa FROM CANDIDATO WHERE CODIGO = c.cod_candidato ) = 1
   OR (SELECT funcionario FROM CANDIDATO WHERE CODIGO = c.cod_candidato)  = 1)
AND REPLACE((NVL(NVL ((SELECT num(salario) FROM sal_carta_proposta WHERE codigo = (SELECT Max (codigo) FROM  sal_carta_proposta WHERE cod_proc_seletivo = PS.CODIGO)), (SELECT num(salario) FROM sal_movimentacao_interna WHERE codigo = (SELECT Max (codigo) FROM  sal_movimentacao_interna WHERE cod_proc_seletivo = PS.CODIGO))), 1)),',','.') <> 1
/



PROMPT CREATE OR REPLACE VIEW vw_log_contratados_wsdl
CREATE OR REPLACE VIEW vw_log_contratados_wsdl (
  codigo,
  data,
  msg_resposta,
  nome,
  cpf_ihunter,
  matricula_ihunter,
  situacao_ihunter,
  msg
) AS
SELECT codigo,
        To_Char(data_envio, 'YYYY/MM/DD hh24:mi:ss') DATA ,
        msg_resposta,
        (SELECT Upper(TiraAcento( NOME_COMPLETO))   FROM CANDIDATO WHERE CODIGO = NUM(valor_campo)) NOME,
        (SELECT CPF FROM CANDIDATO WHERE CODIGO =  valor_campo) CPF_IHUNTER ,
        (SELECT MATRICULA FROM FUNCIONARIO WHERE COD_CANDIDATO = valor_campo) MATRICULA_IHUNTER,
        (SELECT SITUACAO FROM FUNCIONARIO WHERE COD_CANDIDATO = valor_campo) SITUACAO_IHUNTER,
         EXTRACTVALUE(T.result2, '/ROWSET/CANDIDATO/COD_RETORNO') || ' - ' ||
         EXTRACTVALUE(T.result2, '/ROWSET/CANDIDATO/MESSAGE') MESSAGE
   FROM integracao_wsdl_log t
 WHERE COD_INTEGRACAO = 13
/



















