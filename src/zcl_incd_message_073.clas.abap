CLASS zcl_incd_message_073 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',

      BEGIN OF status_invalid,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF status_invalid,

      BEGIN OF priority_unkown,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_PRIORITY_CODE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF priority_unkown,

      BEGIN OF creat_date_bef_changed_date,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_CREATION_DATE',
        attr2 TYPE scx_attrname VALUE 'MV_CHANGED_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF creat_date_bef_changed_date,

      BEGIN OF creat_date_on_or_bef_sysdate,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_CREATION_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF creat_date_on_or_bef_sysdate,

      BEGIN OF enter_creation_date,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MV_CREATION_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_creation_date,

      BEGIN OF enter_changed_date,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_CHANGED_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_changed_date,

      BEGIN OF enter_priority_code,   "Ajustar validacion esta constante
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'MV_PRIORITY_CODE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_priority_code,

      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized,

      BEGIN OF not_authorized_for_status,
        msgid TYPE symsgid VALUE 'ZMC_INCD_MESSAGE_073',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized_for_status.



    METHODS constructor
      IMPORTING
        textid                LIKE if_t100_message=>t100key OPTIONAL
        attr1                 TYPE string OPTIONAL
        attr2                 TYPE string OPTIONAL
        attr3                 TYPE string OPTIONAL
        attr4                 TYPE string OPTIONAL
        previous              LIKE previous OPTIONAL

        creation_date         TYPE zde_creation_date_inc_073 OPTIONAL
        changed_date          TYPE zde_change_date_inc_073 OPTIONAL
        status                TYPE zde_status_code_073 OPTIONAL
        priority_code         TYPE zde_priority_code_073 OPTIONAL
        severity              TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname                 TYPE syuname OPTIONAL.

    DATA:
      mv_attr1                 TYPE string,
      mv_attr2                 TYPE string,
      mv_attr3                 TYPE string,
      mv_attr4                 TYPE string,
      mv_creation_date         TYPE zde_creation_date_inc_073,
      mv_changed_date          TYPE zde_change_date_inc_073,
      mv_status                TYPE zde_status_code_073,

      mv_uname                 TYPE syuname.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INCD_MESSAGE_073 IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.

    me->mv_creation_date         = creation_date.
    me->mv_changed_date           = changed_date.
    me->mv_status                = status.
    me->mv_uname                 = uname.


    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
