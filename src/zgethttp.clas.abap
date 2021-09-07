class ZGETHTTP definition
  public
  final
  create public
  for testing .

public section.

  methods GETTEXT .
protected section.
private section.
ENDCLASS.



CLASS ZGETHTTP IMPLEMENTATION.


  method GETTEXT.
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
  endmethod.
ENDCLASS.
