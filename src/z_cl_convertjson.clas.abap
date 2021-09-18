class Z_CL_CONVERTJSON definition
  public
  final
  create public .

  public section.
    types : lt_rangetype type range of tcurc-waers.

    methods CONVERTJSON
      importing
        value(iv_range) type lt_rangetype
        value(iv_JSONTEXT) type STRING
      returning
        value(rv_NEWJSONTABLE) type ZCURRTABTYPE .
  protected section.
  private section.
ENDCLASS.



CLASS Z_CL_CONVERTJSON IMPLEMENTATION.


  method convertjson.
    data lv_ajson type ref to zif_ajson.
    lv_ajson = zcl_ajson=>parse( iv_JSONTEXT ).
    lv_ajson->to_abap( importing ev_container = rv_NEWJSONTABLE ).
    delete rv_NEWJSONTABLE where not cc in iv_range.
    FIELD-SYMBOLS: <fs> TYPE ZCURRSTRUCTYPE.
    LOOP AT rv_NEWJSONTABLE ASSIGNING <fs>.
      CLEAR <fs>-R030.
    ENDLOOP.
  endmethod.
ENDCLASS.
