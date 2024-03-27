CLASS zcl_stt_new_abap_syntax DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
   CLASS-METHODS: s1_loop_with_grouping.
   CLASS-METHODS:s1_loop_with_single_line.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_stt_new_abap_syntax IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  zcl_stt_new_abap_syntax=>s1_loop_with_grouping(  ).

  ENDMETHOD.
  METHOD s1_loop_with_grouping.
TYPES : tt_bookings TYPE TABLE of /dmo/booking  with DEFAULT KEY.
              data : lv_total TYPE P DECIMALS 2.
        SELECT *  FROM /dmo/booking INTO TABLE @DATA(lt_bookings) up to 20 ROWS.

        LOOP AT lt_bookings INTO DATA(ls_bookings)  GROUP BY ls_bookings-travel_id..
        data(lt_grp_book) = value tt_bookings(  ).
        loop at GROUP ls_bookings INTO DATA(ls_child_rec).

      lt_grp_book = value #( base lt_grp_book (  ls_child_rec ) ).
        lv_total = lv_total + ls_child_rec-flight_price.
        ENDLOOP.
      CLear lv_total.
        ENDLOOP.
  ENDMETHOD.

  METHOD s1_loop_with_single_line.
TYPES : tt_bookings TYPE TABLE of /dmo/booking  with DEFAULT KEY.
              data : lv_total TYPE P DECIMALS 2.

*                     TYPES: BEGIN OF ty_final_booking.
*                                include structure /dmo/booking.
*                                TYPES : booking_tx TYPE p  DECIMALS 2 LENGTH 10.
*                                               END OF ty_final_booking,

        SELECT *  FROM /dmo/booking INTO TABLE @DATA(lt_bookings) up to 20 ROWS.



  ENDMETHOD.

ENDCLASS.
