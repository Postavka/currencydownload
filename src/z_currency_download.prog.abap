report z_currency_download.

tables: tcurc.
INCLUDE Z_CURRENCYAPP_CLASS.

parameters p_date type dats.
select-options s_cur for tcurc-waers no intervals.



start-of-selection.

  call method lcl_app=>main
    exporting
      i_date = p_date
      ir_cur = s_cur[].
