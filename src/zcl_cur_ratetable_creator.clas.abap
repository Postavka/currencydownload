class ZCL_CUR_RATETABLE_CREATOR definition
  public
  final
  create public .

  public section.

    types:
      lt_rangetype type range of tcurc-waers .

    methods CREATE_TABLE
      importing
        value(IV_RANGE) type LT_RANGETYPE
        value(IV_JSONTEXT) type STRING
      returning
        value(RV_RATETABLE) type ZCURRTABTYPE
      raising
        ZCX_CURRENCY_ERROR .
  protected section.
  private section.

    types:
      begin of ty_fulltable,
        cc type  tcurc-waers,
        txt type ztextcurr,
        rate type zvaluecurr,
        exchangedate type zdatecurr,
        r030 type tcurc-altwr,
      end of ty_fulltable.

    types tty_fulljson type standard table of ty_fulltable with default key.

    methods parse
      importing
        iv_jsontext type string
      returning
        value(rt_raw_table) type tty_fulljson.


    methods filter_table
      importing
        iv_fulltable type tty_fulljson
        value(iv_filter) type lt_rangetype
      returning
        value(rv_filteredtable) type zcurrtabtype.
ENDCLASS.



CLASS ZCL_CUR_RATETABLE_CREATOR IMPLEMENTATION.


  method CREATE_TABLE.

    data lt_fulljson type tty_fulljson.

    lt_fulljson = parse( iv_jsontext ).

    if sy-subrc <> 0.
      RAISE EXCEPTION type zcx_currency_error
        EXPORTING
          msg = 'Error while parsing json'.
    endif.

    rv_ratetable = filter_table(
      iv_fulltable = lt_fulljson
      iv_filter =  iv_range ).

    if sy-subrc <> 0.
      RAISE EXCEPTION type zcx_currency_error
        EXPORTING
          msg = 'Error while filtering the table'.
    endif.
  endmethod.


  method FILTER_TABLE.

    data ls_full like line of iv_fulltable.
    data ls_new like line of rv_filteredtable.

    loop at iv_fulltable into ls_full.
      move-corresponding ls_full to ls_new.
      append ls_new to rv_filteredtable.
    endloop.

    delete rv_filteredtable where not cc in iv_filter.
  endmethod.


  method PARSE.

    data lv_ajson type ref to zif_ajson.

    lv_ajson = zcl_ajson=>parse( iv_jsontext ).
    lv_ajson->to_abap( importing ev_container = rt_raw_table ).

  endmethod.
ENDCLASS.
