CLASS zcl_stt_vt_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  DATA:lv_opr TYPE c VALUE 'C'.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_stt_vt_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  case lv_opr.
  WHEN 'R'.
  READ ENTITIES OF ZSTT_VT_TRAVEL
  ENTITY TRAVEL
*  ALL FIELDS WITH
  FIELDS ( travelid agencyid customerid overallstatus ) with
  VALUE #( ( Travelid = '00000010' )
                           ( Travelid = '00000024')
                           ( Travelid = '009595') )
   RESULT DATA(lt_result)
   FAILED DATA(lt_failed)
   REPORTED DATA(lt_messages).

   out->write( EXPORTING data = lt_result ).
   out->write( EXPORTING data = lt_failed ).
  WHEN 'C'.
   DATA(lv_description) = 'Anubhav Rocks with RAP'.
   DATA(lv_agency) = '070016'.
   DATA(lv_customer) = '000697'.
   MODIFY ENTITIES OF zstt_vt_travel
   ENTITY travel
   CREATE FIELDS ( Agencyid Currencycode begindate enddate Description overallstatus  )
   with value  #(
       (  %cid = 'anubhav'
      Travelid = '00013347'
        Agencyid = lv_agency
        customerid = lv_customer
        begindate = cl_abap_context_info=>get_system_date( )
        enddate = cl_abap_context_info=>get_system_date(  ) + 30
        Description = lv_description
        overallstatus = 'O'   )

           (  %cid = 'anubhav-1'
          Travelid = '00012348'
        Agencyid = lv_agency
        customerid = lv_customer
        begindate = cl_abap_context_info=>get_system_date( )
        enddate = cl_abap_context_info=>get_system_date(  ) + 30
        Description = lv_description
        overallstatus = 'O'   )

         (  %cid = 'anubhav-2'
         Travelid = '00000010'
        Agencyid = lv_agency
        customerid = lv_customer
        begindate = cl_abap_context_info=>get_system_date( )
        enddate = cl_abap_context_info=>get_system_date(  ) + 30
        Description = lv_description
        overallstatus = 'O'   )
   )
   MAPPED DATA(lt_mapped)
   FAILED lt_failed
   REPORTED lt_messages.
   COMMIT ENTITIES.
    out->write( EXPORTING data = lt_result ).
   out->write( EXPORTING data = lt_failed ).
  WHEN 'U'.
     lv_description = 'Wos that was an update'.
     lv_agency = '0070032'.
     MODIFY ENTITIES OF zstt_vt_travel
   ENTITY travel
   UPDATE FIELDS ( Agencyid Description   )
   with value  #(
      (  Travelid = '00001133'
        Agencyid = lv_agency

        Description = lv_description
          )

         (  Travelid = '00001135'
        Agencyid = lv_agency

        Description = lv_description
          )
)

   MAPPED lt_mapped
   FAILED lt_failed
   REPORTED lt_messages.
  COMMIT ENTITIES.
 out->write( EXPORTING data = lt_result ).
   out->write( EXPORTING data = lt_failed ).
  WHEN 'D'.
  MODIFY ENTITIES OF zstt_vt_travel
   ENTITY travel
   DELETE FROM VALUE #(
      (  Travelid = '00001133'
          )
)
   MAPPED lt_mapped
   FAILED lt_failed
   REPORTED lt_messages.
  COMMIT ENTITIES.
 out->write( EXPORTING data = lt_result ).
   out->write( EXPORTING data = lt_failed ).

  ENDCASE.
  ENDMETHOD.
ENDCLASS.
