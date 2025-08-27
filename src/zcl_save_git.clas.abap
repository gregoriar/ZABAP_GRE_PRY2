CLASS zcl_save_git DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SAVE_GIT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    out->write( 'Save to GitHub' ).
    out->write( 'Añadido fuera').

  ENDMETHOD.
ENDCLASS.
