CLASS zcl_load_inc_data_073 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_load_inc_data_073 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DELETE FROM zdt_status_073.
    DELETE FROM zdt_priority_073.

* Load data for DB Status
    MODIFY zdt_status_073 FROM TABLE @( VALUE #( ( status_code = 'OP'
                                                   status_description = 'Open' )
                                                 ( status_code = 'IP'
                                                   status_description = 'In Progress' )
                                                 ( status_code = 'PE'
                                                   status_description = 'Pending' )
                                                 ( status_code = 'CO'
                                                   status_description = 'Completed' )
                                                 ( status_code = 'CL'
                                                   status_description = 'Closed-In annotations' )
                                                 ( status_code = 'EP'
                                                   status_description = 'On hold for materials' )
                                                 ( status_code = 'CN'
                                                   status_description = 'Canceled' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } New Status were added| ).
    ENDIF.

* Load data for DB Prioryty
    MODIFY zdt_priority_073 FROM TABLE @( VALUE #( ( priority_code = 'H'
                                                     priority_description = 'High' )
                                                   ( priority_code = 'M'
                                                     priority_description = 'Medium' )
                                                   ( priority_code = 'L'
                                                     priority_description = 'Low' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } New Priorities were added| ).
    ENDIF.


   " Load initial data for DB
    MODIFY zdt_inct_user073 FROM TABLE @( VALUE #( ( client            = '200'
                                                     incident_id      = 1
                                                     title            = 'Ajuste de visagra I' "Revisar y agrandar tamaño del char
                                                     description      = 'Fallas en visagra III' "Revisar y agrandar tamaño del char
                                                     status           = 'OP'
                                                     priority         =  'H'
                                                     creation_date    = '20250123'
                                                     changed_date     = '20250223'
                                                      ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } New Incident(s) were added| ).
    ENDIF.
  ENDMETHOD.


ENDCLASS.
