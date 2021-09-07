class Z_CL_GETHTTP definition
  public
  final
  create public .

public section.

  class-methods GET_HTTP
    importing
      !HTTP_URL type /IWFND/SUB_BASE_URL
    returning
      value(TEXT) type /IWFND/MED_MDL_DEFAULT_VALUE .
protected section.
private section.
ENDCLASS.



CLASS Z_CL_GETHTTP IMPLEMENTATION.


  method GET_HTTP.

    data lo_http_client type ref to if_http_client .
  cl_http_client=>create_by_url(
    exporting
      url                = HTTP_URL
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


  TEXT  = lo_http_client->response->get_cdata( ).
  endmethod.
ENDCLASS.
