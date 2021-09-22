class ZCL_CUR_RATE_DOWNLOADER definition
  public
  final
  create public .

public section.

  methods GET_BY_URL
    importing
      !I_HTTP_URL type STRING optional
    returning
      value(R_TEXT) type STRING
    raising
      ZCX_CURRENCY_ERROR .
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_CUR_RATE_DOWNLOADER IMPLEMENTATION.


  method GET_BY_URL.

    data lo_http_client type ref to if_http_client .
    cl_http_client=>create_by_url(
      exporting
        url                = I_HTTP_URL
        ssl_id             = 'ANONYM'
      importing
        client             = lo_http_client
      exceptions
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        others             = 4
    ).
    if sy-subrc <> 0.
      raise exception type zcx_currency_error
        exporting
          msg = 'error in create_by_url'.
    endif.

    lo_http_client->request->set_header_field(
        name  = '~request_method'
        value = 'GET' ).

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
      data lv_err_string type string.
      data lv_ret_code type sy-subrc.

      lo_http_client->response->get_status(
        importing
          code   = lv_ret_code
          reason = lv_err_string
             ).
      raise exception type zcx_currency_error
        exporting
          msg = lv_err_string.
    endif.

    R_TEXT  = lo_http_client->response->get_cdata( ).
  endmethod.
ENDCLASS.
