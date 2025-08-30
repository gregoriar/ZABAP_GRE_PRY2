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
    DELETE FROM zdt_inct_user073.
    DELETE FROM zdt_inct_h_073.

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
                                                   status_description = 'Closed' )
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


    " Load initial data for persistence principal DB  Incident
    MODIFY zdt_inct_user073 FROM TABLE @( VALUE #( (
                                                     inc_uuid         = 1
                                                     incident_id      = 1
                                                     title            = 'Ajuste de visagra I' "Revisar y no agrandar tamaño del char
                                                     description      = 'Fallas en visagra I Reaparación engranaje I' "Revisar y  no agrandar tamaño del char
                                                     status           = 'OP'
                                                     priority         =  'H'
                                                     creation_date    = '20250123'
                                                     changed_date     = '20250223' )

                                                  (  inc_uuid         = 2
                                                     incident_id      = 2
                                                     title            = 'Ajuste de visagra II' "Revisar y no agrandar tamaño del char
                                                     description      = 'Fallas en visagra II Reaparación engranaje II' "Revisar y  no agrandar tamaño del char
                                                     status           = 'OP'
                                                     priority         =  'M'
                                                     creation_date    = '20250123'
                                                     changed_date     = '20250223'   )

                                                   ( inc_uuid         = 3
                                                     incident_id      = 3
                                                     title            = 'Ajuste de visagr III' "Revisar y no agrandar tamaño del char
                                                     description      = 'Fallas en visagra III Reaparación engranaje III' "Revisar y  no agrandar tamaño del char
                                                     status           = 'OP'
                                                     priority         =  'H'
                                                     creation_date    = '20250123'
                                                     changed_date     = '20250223'    ) ) ) .




    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } New Incident(s) were added| ).
    ENDIF.


    " Load initial data for persistence Child DB  History Incident
    MODIFY  zdt_inct_h_073 FROM TABLE @( VALUE #(
                                                  (  his_uuid         = 1
                                                     inc_uuid         = 1

                                                     his_id           = 1
                                                     previous_status  = ''
                                                     new_status       = 'OP'
                                                     text             =  'First Incident'
                                                                          )

                                                  (  his_uuid         = 2
                                                     inc_uuid         = 1

                                                     his_id           = 2
                                                     previous_status  = 'OP'
                                                     new_status       = 'PE'
                                                     text             =  'En espera de materiales. No se puede iniciar'
                                                                          )

                                                  (  his_uuid         = 3
                                                     inc_uuid         = 2

                                                     his_id           = 3
                                                     previous_status  = ''
                                                     new_status       = 'OP'
                                                     text             =  'First Incident'
                                                                          )

                                                   (  his_uuid         = 4
                                                      inc_uuid         = 2

                                                     his_id            = 4
                                                     previous_status  = 'OP'
                                                     new_status       = 'PE'
                                                     text             =  'Continua en espera de asignación de Técnico Especialista'
                                                                          )


                                                    (  his_uuid         = 5
                                                       inc_uuid         = 2

                                                      his_id            = 5
                                                      previous_status  = 'PE'
                                                      new_status       = 'IP'
                                                      text             =  'Asignación de Técnico Especialista'
                                                                          )


                                                     ) )  .


    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } New History Incident(s) were added| ).
    ENDIF.
  ENDMETHOD.


ENDCLASS.
