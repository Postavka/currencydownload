class ZCX_CURRENCY_ERROR definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  data MSG type STRING read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !MSG type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_CURRENCY_ERROR IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
me->MSG = MSG .
endmethod.
ENDCLASS.
