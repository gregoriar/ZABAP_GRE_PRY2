CLASS lhc_Incidents DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    CONSTANTS: BEGIN OF mc_status,
                 open             TYPE zde_status_code_073  VALUE 'OP',
                 in_progress      TYPE zde_status_code_073  VALUE 'IP',
                 pending          TYPE zde_status_code_073  VALUE 'PE',
                 completed        TYPE zde_status_code_073  VALUE 'CO',
                 closed           TYPE zde_status_code_073  VALUE 'CL',
                 canceled         TYPE zde_status_code_073  VALUE 'CN',
                 on_hold_material TYPE zde_status_code_073  VALUE 'EP',
               END OF mc_status.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incidents RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS changeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~changeStatus RESULT result.

    METHODS reActStatusObservationHis FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~reActStatusObservationHis.

    METHODS setDefaultValuesInct FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incidents~setDefaultValuesInct.

    METHODS setdefaulthistory FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incidents~setdefaulthistory.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateDates.

    METHODS validatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validatePriority.



ENDCLASS.

CLASS lhc_Incidents IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD changeStatus.
  ENDMETHOD.

  METHOD reActStatusObservationHis.
  ENDMETHOD.

  METHOD setDefaultValuesInct.
  ENDMETHOD.

  METHOD setdefaulthistory.
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validatePriority.
      READ ENTITIES OF ZR_DT_INCT_073  IN LOCAL MODE
       ENTITY  Incidents
       FIELDS ( Priority )
       WITH CORRESPONDING #( keys )
       RESULT DATA(incidents2).  "//"**ERA travels

    DATA priorities  TYPE SORTED TABLE OF zdt_priority_073  WITH UNIQUE KEY client priority_code.
    priorities = CORRESPONDING #( incidents2 DISCARDING DUPLICATES MAPPING priority_code =  Priority EXCEPT * ).
    DELETE priorities WHERE priority_code IS INITIAL.

    IF priorities IS NOT INITIAL.
      SELECT FROM zdt_priority_073 AS ddbb
         INNER JOIN @priorities AS http_req ON ddbb~priority_code EQ http_req~priority_code
         FIELDS ddbb~priority_code
         INTO TABLE @DATA(valid_priorities).
    ENDIF.

    LOOP AT incidents2 INTO DATA(incident2).
      IF incident2-Priority IS INITIAL.

        APPEND VALUE #( %tky = incident2-%tky ) TO failed-Incidents.

        APPEND VALUE #( %tky        = incident2-%tky
                        %state_area = 'VALIDATE_PRIORITY'
                        %msg        = NEW /dmo/cm_flight_messages(  textid  = /dmo/cm_flight_messages=>enter_agency_id
                                                                severity = if_abap_behv_message=>severity-error )
                       %element-Priority  = if_abap_behv=>mk-on
                              )  TO reported-Incidents.

      ELSEIF incident2-Priority IS NOT INITIAL AND NOT line_exists( valid_priorities[ priority_code = incident2-Priority ] ).

        APPEND VALUE #( %tky = incident2-%tky ) TO failed-Incidents.

        APPEND VALUE #( %tky        = incident2-%tky
                        %state_area = 'VALIDATE_PRIORITY'
                        %msg        = NEW /dmo/cm_flight_messages(  textid    = /dmo/cm_flight_messages=>agency_unkown
                                                         "   priority_code = incident2-Priority  "Se debe ajustar con la clase de mensajes
                                                         "    agency_id = travel-AgencyID
                                                            severity   = if_abap_behv_message=>severity-error )
                           %element-Priority  = if_abap_behv=>mk-on
                                   )  TO reported-Incidents.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
