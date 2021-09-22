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

    lr_url = |https://bank.gov.ua/nbustatservice/v1/statdirectory/exchange?date={ lnew_date }&json|.

    data lo_httptext type ref to zcl_cur_rate_downloader.
    create object lo_httptext.
    data lo_ratetable type ref to zcl_cur_ratetable_creator.
    create object lo_ratetable.
    data lo_alv type ref to zcl_cur_display_table.
    create object lo_alv.
    data lv_response type string.
    data lt_ratetable type zcurrtabtype.

    data lx type ref to zcx_currency_error.

    try.
      lv_response = lo_httptext->get_by_url( lr_url ).
    catch zcx_currency_error into lx.
      message lx->msg type 'e'.
    endtry.

    try.
    lt_ratetable = lo_ratetable->create_table(
      iv_jsontext = lv_response
      iv_range = ir_cur ).
    catch zcx_currency_error into lx.
      message lx->msg type 'e'.
    endtry.


    lo_alv->display( lt_ratetable ).
  endmethod.

endclass.
