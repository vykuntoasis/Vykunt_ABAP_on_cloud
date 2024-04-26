CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Bookingsupplement.
    METHODS calculateTotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalprice.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Bookingsupp.
  DATA max_booking_suppl_id TYPE /dmo/booking_supplement_id.

  read ENTITIES OF zstt_vt_travel in LOCAL MODE ENTITY booking by \_BookingSupplement
  FROM CORRESPONDING #( entities ) LINK DATA(bookingsuppl).

  loop at entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.

  loop at bookingsuppl INTO DATA(ls_bookingsuppl)
  WHERE source-TravelId  = <booking_group>-TravelId and
                source-BookingId = <booking_group>-BookingId.
  if max_booking_suppl_id < ls_bookingsuppl-target-BookingSupplementId.
    max_booking_suppl_id = ls_bookingsuppl-target-BookingSupplementId.
  ENDIF.
  ENDLOOP.

  loop at entities INTO DATA(ls_entity)
  WHERE travelid = <booking_group>-travelid AND BookingId = <booking_group>-BookingId.
  loop at ls_entity-%target INTO DATA(ls_target).
   if max_booking_suppl_id < ls_target-BookingSupplementId.
   max_booking_suppl_id = ls_target-BookingSupplementId.

   ENDIF.
     ENDLOOP.
ENDLOOP.

loop at entities ASSIGNING FIELD-SYMBOL(<travel>)
 WHERE travelid  = <booking_group>-travelid and BookingId = <booking_group>-BookingId.
  loop at <travel>-%target ASSIGNING FIELD-SYMBOL(<bookingsuppl_wo_numbers>).
  APPEND CORRESPONDING  #( <bookingsuppl_wo_numbers> ) to mapped-booksuppl
  ASSIGNING FIELD-SYMBOL(<mapped_bookingsuppl>).
  if <mapped_bookingsuppl>-BookingSupplementId is INITIAL.
  max_booking_suppl_id += 1.
  <mapped_bookingsuppl>-%is_draft = <bookingsuppl_wo_numbers>-%is_draft.
  <mapped_bookingsuppl>-BookingSupplementId = max_booking_suppl_id.
  ENDIF.

  ENDLOOP.

ENDLOOP.

  ENDLOOP.


  ENDMETHOD.

  METHOD calculateTotalprice.

  DATA travel_ids TYPE STANDARD TABLE OF zstt_vt_travel_processor WITH UNIQUE HASHED KEY key components TravelId.
  travel_ids = CORRESPONDING #(  keys discarding duplicates mapping TravelId = TravelId ).

MODIFY ENTITIES OF zstt_vt_travel in LOCAL MODE
  ENTITY travel
  EXECUTE reCalcTotalPrice
  FROM CORRESPONDING #( travel_ids ).
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
