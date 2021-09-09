class Z_CL_CONVERTJSON definition
  public
  final
  create public .

public section.

  methods CONVERTJSON
    importing
      value(JSONTEXT) type STRING
    returning
      value(NEWJSONTABLE) type ZCURRTABTYPE .
protected section.
private section.
ENDCLASS.



CLASS Z_CL_CONVERTJSON IMPLEMENTATION.


  method convertjson.
    data lv_ajson type ref to zif_ajson.
    lv_ajson = zcl_ajson=>parse( JSONTEXT ).
    lv_ajson->to_abap( importing ev_container = NEWJSONTABLE ).
  endmethod.
ENDCLASS.
