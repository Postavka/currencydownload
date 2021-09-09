report z_currency_download.

tables: tcurc.
data lv_url type string.
data: lv_now      type d,
      lv_date(10),
      new_date    type char10,
      day(2),
      month(2),
      year(4).


parameters p_date type dats.
select-options s_cur for tcurc-waers no intervals.

start-of-selection.

  if not p_date = 00000000.
    write p_date to lv_date.
    day(2) = lv_date(2).
    month(2) = lv_date+3(2).
    year(4) = lv_date+6(4).
    new_date = |{ year }| && |{ month }| && |{ day }|.
  else.
    lv_now = sy-datum.
    write lv_now to lv_date.
    day(2) = lv_date(2).
    month(2) = lv_date+3(2).
    year(4) = lv_date+6(4).
    new_date = |{ year }| && |{ month }| && |{ day }|.
  endif.

  lv_url = |https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?date={ new_date }&json|.

  data lo_httptext type ref to z_cl_gethttp.
  create object lo_httptext.
  data newjsn type ref to z_cl_convertjson.
  create object newjsn.
  data newalv type ref to z_cl_displayalv.
  create object newalv.

  data(lv_response) = lo_httptext->get_http( lv_url ).
  data(lt_newjson) = newjsn->convertjson( lv_response ).
  delete lt_newjson where not cc in s_cur.
  newalv->display( lt_newjson ).
