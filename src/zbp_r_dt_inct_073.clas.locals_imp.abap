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


    METHODS validatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validatePriority.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateDates.

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~setHistory.

    METHODS get_history_index EXPORTING ev_incuuid      TYPE sysuuid_x16
                              RETURNING VALUE(rv_index) TYPE zde_num_incident_073.


ENDCLASS.

CLASS lhc_Incidents IMPLEMENTATION.

 METHOD validateDates.
  "Validacion de CreationDate y ChangedDate"
    READ ENTITIES OF zr_dt_inct_073  IN LOCAL MODE
    ENTITY  Incidents
    FIELDS ( CreationDate
             ChangedDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(incidents2).

    LOOP AT incidents2 INTO DATA(incident2).

      IF incident2-CreationDate IS INITIAL.

        APPEND VALUE #(  %tky =  incident2-%tky ) TO failed-Incidents.

        APPEND VALUE #( %tky        = incident2-%tky
                        %state_area = 'VALIDATE_DATES'
                        %msg        = NEW  zcl_incd_message_073(  textid     = zcl_incd_message_073=>enter_creation_date
                                                                severity   = if_abap_behv_message=>severity-error )
                      %element-CreationDate  = if_abap_behv=>mk-on
                              )  TO reported-Incidents.

      ENDIF.

      IF incident2-ChangedDate IS INITIAL.

        APPEND VALUE #(  %tky = incident2-%tky ) TO failed-Incidents.

        APPEND VALUE #( %tky        = incident2-%tky
                        %state_area = 'VALIDATE_DATES'
                        %msg        = NEW zcl_incd_message_073(  textid     = zcl_incd_message_073=>enter_changed_date
                                                                severity   = if_abap_behv_message=>severity-error )
                      %element-ChangedDate  = if_abap_behv=>mk-on
                              )  TO reported-Incidents.

      ENDIF.

    ENDLOOP.

    IF incident2-ChangedDate < incident2-CreationDate AND incident2-CreationDate IS NOT INITIAL
                                         AND incident2-ChangedDate IS NOT INITIAL.

      APPEND VALUE #(  %tky =  incident2-%tky ) TO failed-Incidents.

      APPEND VALUE #( %tky        = incident2-%tky
                      %state_area = 'VALIDATE_DATES'
                     %msg        = NEW zcl_incd_message_073(  textid     = zcl_incd_message_073=>creat_date_bef_changed_date
                                                            creation_date  = incident2-CreationDate
                                                            changed_date    = incident2-ChangedDate
                                                             severity    = if_abap_behv_message=>severity-error )
                      %element-CreationDate  = if_abap_behv=>mk-on
                      %element-ChangedDate    = if_abap_behv=>mk-on
                              )  TO reported-Incidents.

    ENDIF.

    IF incident2-CreationDate < cl_abap_context_info=>get_system_date(  ) AND incident2-CreationDate IS NOT INITIAL
                                                                    AND incident2-ChangedDate IS NOT INITIAL.

      APPEND VALUE #(  %tky =  incident2-%tky ) TO failed-Incidents.

      APPEND VALUE #( %tky        = incident2-%tky
                      %state_area = 'VALIDATE_DATES'
                      %msg        = NEW zcl_incd_message_073(  textid     = zcl_incd_message_073=>creat_date_on_or_bef_sysdate
                                                               creation_date  = incident2-CreationDate
                                                               severity   = if_abap_behv_message=>severity-error )
                      %element-CreationDate = if_abap_behv=>mk-on
                        )  TO reported-Incidents.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
*    DATA: update_requested TYPE abap_bool,
*          update_granted   TYPE abap_bool.
*
*** Determining the technical username
*    DATA: lv_message_text TYPE string.
*    lv_message_text = 'Unauthorized user'.
*    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name(  ).
*     lv_technical_name = 'OTHER USER'.
*
*    READ ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
*           ENTITY Incidents
*            FIELDS ( Status )
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(incidents_t)
*           FAILED failed.
*
*
*    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
*                                   requested_authorizations-%action-Edit = if_abap_behv=>mk-on
*
*                              THEN abap_true
*                              ELSE abap_false ).
*
*    CHECK update_requested EQ  abap_true.
*
*    LOOP AT incidents_t INTO DATA(incident_t).                " 70021.
*      "  WHERE AgencyID IS NOT INITIAL.
*
*      IF incident_t-Status IS NOT INITIAL.
*
*        IF lv_technical_name EQ 'CB9980000073'.
*          update_granted = abap_true.
*        ELSE.
*          update_granted = abap_false.
*
*          APPEND VALUE #( %tky = incident_t-%tky
*                          %msg = NEW zcl_incd_message_073( textid    = zcl_incd_message_073=>not_authorized_for_status
*                                                              status =  incident_t-Status
*                                                              severity  = if_abap_behv_message=>severity-error )
*                         %element-status = if_abap_behv=>mk-on                    )  TO reported-Incidents.
*
*        ENDIF.
*
*      ENDIF.
*
*      APPEND VALUE #( LET upd_auth = COND #( WHEN update_granted EQ abap_true
*                                             THEN if_abap_behv=>auth-allowed
*                                             ELSE if_abap_behv=>auth-unauthorized )
*
*
*                       IN
*                       %tky         = incident_t-%tky
*                       %update      = upd_auth
*                       %action-Edit = upd_auth ) TO result.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD changeStatus.

    " Declaration of necessary variables
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zr_dt_inct_073,
          lt_association_entity  TYPE TABLE FOR CREATE zr_dt_inct_073\_HistoryIncidents,
          lv_status              TYPE zde_status_code_073,
          lv_text                TYPE zde_hist_text_073,
          lv_exception           TYPE string,
          lv_error               TYPE c,
          ls_incident_history    TYPE zdt_inct_h_073,
          lv_max_his_id          TYPE zde_num_incident_073,
          lv_wrong_status        TYPE zde_status_code_073.

** Iterate through the keys records to get parameters for validations
    "lt_updated_root_entity[ 1 ]

    READ ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
         ENTITY Incidents
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(incidents_t)
         FAILED failed.

**


** Get parameters
    LOOP AT incidents_t ASSIGNING FIELD-SYMBOL(<incident_t>).
** Get Status
      lv_status = keys[ KEY id %tky = <incident_t>-%tky ]-%param-new_status.  "%param-status.

**  It is not possible to change the pending (PE) to Completed (CO) or Closed (CL) status
      IF <incident_t>-Status EQ mc_status-pending AND lv_status EQ mc_status-closed OR
         <incident_t>-Status EQ mc_status-pending AND lv_status EQ mc_status-completed.
** Set authorizations
        APPEND VALUE #( %tky = <incident_t>-%tky ) TO failed-Incidents.

        lv_wrong_status = lv_status.
* Customize error messages
        APPEND VALUE #( %tky = <incident_t>-%tky
                        %msg = NEW zcl_incd_message_073( textid = zcl_incd_message_073=>status_invalid
                                                            status = lv_wrong_status
                                                            severity = if_abap_behv_message=>severity-error )
                        %state_area = 'VALIDATE_COMPONENT'
                         ) TO reported-Incidents.
        lv_error = abap_true.
        EXIT.
      ENDIF.

      APPEND VALUE #( %tky = <incident_t>-%tky
                      ChangedDate = cl_abap_context_info=>get_system_date( )
                      Status = lv_status ) TO lt_updated_root_entity.

** Get Text
      lv_text = keys[ KEY id %tky = <incident_t>-%tky ]-%param-observacion. " %param-observacion-text.

      lv_max_his_id = get_history_index(
                  IMPORTING
                    ev_incuuid = <incident_t>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.  "OJO VERIFICAR es  + 1  no 1f
      ENDIF.

      ls_incident_history-new_status = lv_status.
      ls_incident_history-text = lv_text.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.
*
        APPEND VALUE #( %tky = <incident_t>-%tky
                        %target = VALUE #( (  HisUUID = ls_incident_history-inc_uuid
                                              IncUUID = <incident_t>-IncUUID
                                              HisID = ls_incident_history-his_id
                                              PreviousStatus = <incident_t>-Status
                                              NewStatus = ls_incident_history-new_status
                                              Text = ls_incident_history-text ) )
                                               ) TO lt_association_entity.
      ENDIF.
    ENDLOOP.
    UNASSIGN <incident_t>.

** The process is interrupted because a change of status from pending (PE) to Completed (CO) or Closed (CL) is not permitted.
    CHECK lv_error IS INITIAL.

** Modify status in Root Entity
    MODIFY ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
    ENTITY Incidents
    UPDATE  FIELDS ( ChangedDate
                     Status )
    WITH lt_updated_root_entity.

    FREE incidents_t.    " FREE incidents. " Free entries in incidents is incidents_t

    "Updating the fields in the Incident History table GRE  OJO ESTO SE PIDE EN UN SIDE EFECT
    MODIFY ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
     ENTITY Incidents
     CREATE BY \_HistoryIncidents FIELDS ( HisUUID
                                  IncUUID
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity
     MAPPED mapped
     FAILED failed
     REPORTED reported.

** Read root entity entries updated
    READ ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
    ENTITY Incidents
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT incidents_t.
    "OJO Revisar aqui
** Update User Interface
    result = VALUE #( FOR incident IN incidents_t ( %tky = incident-%tky
                                                   %param = incident ) ).
  ENDMETHOD.


  "get_history_index
  METHOD get_history_index.
** Fill history data
    SELECT FROM zdt_inct_h_073
      FIELDS MAX( his_id ) AS max_his_id
      WHERE inc_uuid EQ @ev_incuuid AND
            his_uuid IS NOT NULL
      INTO @rv_index.
  ENDMETHOD.


  METHOD reActStatusObservationHis.
  ENDMETHOD.

  METHOD setDefaultValuesInct.
** Read root entity entries
    READ ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
     ENTITY Incidents
     FIELDS ( CreationDate
              Status ) WITH CORRESPONDING #( keys )
     RESULT DATA(incidents2).

** This important for logic
    DELETE incidents2 WHERE CreationDate IS NOT INITIAL.

    CHECK incidents2 IS NOT INITIAL.

** Get Last index from Incidents
    SELECT FROM zdt_inct_user073
      FIELDS MAX( incident_id ) AS max_inct_id
      WHERE incident_id IS NOT NULL
      INTO @DATA(lv_max_inct_id).

    IF lv_max_inct_id IS INITIAL.
      lv_max_inct_id = 1.
    ELSE.
      lv_max_inct_id += 1.
    ENDIF.

** Modify status in Root Entity
    MODIFY ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
      ENTITY Incidents
      UPDATE
      FIELDS ( IncidentID
               CreationDate
               Status )
      WITH VALUE #(  FOR incident IN incidents2 ( %tky = incident-%tky
                                                 IncidentID = lv_max_inct_id
                                                 CreationDate = cl_abap_context_info=>get_system_date( )
                                                 Status       = mc_status-open )  ).

  ENDMETHOD.


  METHOD validatePriority.   "Probado en UI 06/09/25

    READ ENTITIES OF zr_dt_inct_073  IN LOCAL MODE
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
                        %msg        = NEW zcl_incd_message_073(  textid  = zcl_incd_message_073=>enter_priority_code   "Clase manejadora de mensajes
                                                                severity = if_abap_behv_message=>severity-error )
                       %element-Priority  = if_abap_behv=>mk-on
                              )  TO reported-Incidents.

      ELSEIF incident2-Priority IS NOT INITIAL AND NOT line_exists( valid_priorities[ priority_code = incident2-Priority ] ).

        APPEND VALUE #( %tky = incident2-%tky ) TO failed-Incidents.

        APPEND VALUE #( %tky        = incident2-%tky
                        %state_area = 'VALIDATE_PRIORITY'
                        %msg        = NEW zcl_incd_message_073(  textid    = zcl_incd_message_073=>priority_unkown
                                                                severity   = if_abap_behv_message=>severity-error )
                           %element-Priority  = if_abap_behv=>mk-on
                                   )  TO reported-Incidents.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD setHistory.
* Declaration of necessary variables
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zr_dt_inct_073,
          lt_association_entity  TYPE TABLE FOR CREATE zr_dt_inct_073\_HistoryIncidents,
          lv_exception           TYPE string,
          ls_incident_history    TYPE zdt_inct_h_lgl,
          lv_max_his_id          TYPE zde_his_id_lgl.

** Iterate through the keys records to get parameters for validations
    READ ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
         ENTITY Incidents
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(incidents2).
*
** Get parameters  OJO CON get_history_index
    LOOP AT incidents2 ASSIGNING FIELD-SYMBOL(<incident2>).
      lv_max_his_id = get_history_index( IMPORTING ev_incuuid = <incident2>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.
      ENDIF.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.
        APPEND VALUE #( %tky = <incident2>-%tky
                        %target = VALUE #( (  HisUUID = ls_incident_history-inc_uuid
                                              IncUUID = <incident2>-IncUUID
                                              HisID = ls_incident_history-his_id
                                              NewStatus = <incident2>-Status
                                              Text = 'First Incident' ) )
                                               ) TO lt_association_entity.
      ENDIF.
    ENDLOOP.
    UNASSIGN <incident2>.

    FREE incidents2. " Free entries in incidents

    MODIFY ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
     ENTITY Incidents
     CREATE BY \_HistoryIncidents FIELDS ( HisUUID
                                  IncUUID
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity.
  ENDMETHOD.

  METHOD setdefaulthistory.
** Execute internal action to update Flight Date
    MODIFY ENTITIES OF zr_dt_inct_073 IN LOCAL MODE
    ENTITY Incidents
    EXECUTE setHistory
       FROM CORRESPONDING #( keys ).
  ENDMETHOD.

ENDCLASS.
