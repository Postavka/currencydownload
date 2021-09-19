class Z_CL_CONVERTJSON definition
  public
  final
  create public .

  public section.
    types : lt_rangetype type range of tcurc-waers.

    methods convertjson
      importing
        value(iv_range) type lt_rangetype
        value(iv_jsontext) type string
      returning
        value(rv_newjsontable) type zcurrtabtype .
  protected section.
  private section.
ENDCLASS.



CLASS Z_CL_CONVERTJSON IMPLEMENTATION.


  method convertjson.
    types: begin of lt_fulljson,
            cc type  tcurc-waers,
            txt type ztextcurr,
            rate type zvaluecurr,
            exchangedate type zdatecurr,
            r030 type tcurc-altwr,
           end of lt_fulljson.

    data: lv_ajson type ref to zif_ajson,
          lwa_full type lt_fulljson,
          lwa_new type zcurrstructype,
          lv_fulljson type standard table of lt_fulljson.

    lv_ajson = zcl_ajson=>parse( iv_jsontext ).
    lv_ajson->to_abap( importing ev_container = lv_fulljson ).

    delete lv_fulljson where not cc in iv_range.

    loop at lv_fulljson into lwa_full.
      lwa_new-cc = lwa_full-cc.
      lwa_new-txt = lwa_full-txt.
      lwa_new-rate = lwa_full-rate.
      lwa_new-exchangedate = lwa_full-exchangedate.
      append lwa_new to rv_newjsontable.
    endloop.

    clear lv_fulljson.
  endmethod.
ENDCLASS.
