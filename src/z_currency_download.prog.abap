report z_currency_download.

tables: tcurc.

data lv_ajson type ref to zif_ajson.
data payload type ref to zif_ajson.
data: o_alv type ref to cl_salv_table.
data: lx_msg type ref to cx_salv_msg.
types: begin of ls_json,
         cc           type tcurc-waers,
         txt          type ztextcurr,
         rate         type zvaluecurr,
         exchangedate type zdatecurr,
         r030         type tcurc-altwr,
       end of ls_json.
types tt_json_typ type standard table of ls_json.
data: lt_json type tt_json_typ.
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

  data lo_httptext type ref to Z_CL_GETHTTP.
  call method lo_httptext->GET_HTTP( lv_url ).
  data lo_http_client type ref to if_http_client .
  cl_http_client=>create_by_url(
    exporting
      url                = lv_url
      ssl_id             = 'ANONYM'
    importing
      client             = lo_http_client
    exceptions
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      others             = 4
  ).

  call method lo_http_client->request->set_header_field
    exporting
      name  = '~request_method'
      value = 'GET'.

  lo_http_client->send(
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      others                     = 5
  ).



  lo_http_client->receive(
    exceptions
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      others                     = 4
  ).

  if sy-subrc ne 0.
    data(lv_err_string) = value string( ).
    data(lv_ret_code) = value sy-subrc( ).
    lo_http_client->response->get_status(
      importing
        code   = lv_ret_code
        reason = lv_err_string
           ).
    message lv_err_string type 'I'.
  endif.


  data(lv_response) = lo_http_client->response->get_cdata( ).

  lv_ajson = zcl_ajson=>parse( lv_response ).

  lv_ajson->to_abap( importing ev_container = lt_json ).

  delete lt_json where not cc in s_cur.

  try.
      cl_salv_table=>factory(
        importing
          r_salv_table = o_alv
        changing
          t_table      = lt_json ).
    catch cx_salv_msg into lx_msg.
  endtry.

  o_alv->get_columns( )->get_column( 'R030' )->set_visible( if_salv_c_bool_sap=>false ).
  o_alv->get_functions( )->set_default( abap_true ).
  o_alv->set_screen_status(
      pfstatus      =  'SALV_STANDARD'
      report        =  'SALV_DEMO_TABLE_SELECTIONS'
      set_functions = o_alv->c_functions_all ).

  o_alv->display( ).
