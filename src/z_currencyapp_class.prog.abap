*&---------------------------------------------------------------------*
*&  Include           Z_CURRENCYAPP_CLASS
*&---------------------------------------------------------------------*
class lcl_app definition.
  public section.
    types : lt_rangetype type range of tcurc-waers.
    class-methods main
      importing
        i_date type dats
        ir_cur type lt_rangetype.
endclass.

class lcl_app implementation.
  method main.

    data lr_url type string.
    data: lv_now      type d,
          lv_date(10),
          lnew_date    type char10,
          lday(2),
          lmonth(2),
          lyear(4).

    if not i_date = 00000000.
      write i_date to lv_date.
      lday(2) = lv_date(2).
      lmonth(2) = lv_date+3(2).
      lyear(4) = lv_date+6(4).
      lnew_date = |{ lyear }| && |{ lmonth }| && |{ lday }|.
    else.
      lv_now = sy-datum.
      write lv_now to lv_date.
      lday(2) = lv_date(2).
      lmonth(2) = lv_date+3(2).
      lyear(4) = lv_date+6(4).
      lnew_date = |{ lyear }| && |{ lmonth }| && |{ lday }|.
    endif.

    lr_url = |https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date={ lnew_date }&json|.

    data lo_httptext type ref to z_cl_gethttp.
    CREATE OBJECT lo_httptext.
    data lo_newjsn type ref to z_cl_convertjson.
    CREATE OBJECT lo_newjsn.
    data lo_newalv type ref to z_cl_displayalv.
    CREATE OBJECT lo_newalv.
    data lv_response type string.
    data lt_newjson type ZCURRTABTYPE.

    lv_response = lo_httptext->get_http( lr_url ).

    lt_newjson = lo_newjsn->convertjson(
       iv_JSONTEXT = lv_response
       IV_RANGE = ir_cur ).


    lo_newalv->display( lt_newjson ).
  endmethod.

endclass.
