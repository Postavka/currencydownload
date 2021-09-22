class ZCL_CUR_DISPLAY_TABLE definition
  public
  final
  create public .

public section.

  data LT_JSON type ZCURRTABTYPE .

  methods DISPLAY
    importing
      value(I_JSONTABLE) type ZCURRTABTYPE .
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_CUR_DISPLAY_TABLE IMPLEMENTATION.


  method DISPLAY.
    data: o_alv type ref to cl_salv_table.
    data: lx_msg type ref to cx_salv_msg.
    try.
        cl_salv_table=>factory(
          importing
            r_salv_table = o_alv
          changing
            t_table      = i_jsontable ).
      catch cx_salv_msg into lx_msg.
    endtry.

    o_alv->get_functions( )->set_default( abap_true ).
    o_alv->set_screen_status(
      pfstatus      =  'SALV_STANDARD'
      report        =  'SALV_DEMO_TABLE_SELECTIONS'
      set_functions = o_alv->c_functions_all ).

    o_alv->display( ).
  endmethod.
ENDCLASS.
