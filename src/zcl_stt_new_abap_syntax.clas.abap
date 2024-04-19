CLASS zcl_stt_new_abap_syntax DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
   CLASS-METHODS: s1_loop_with_grouping.
   CLASS-METHODS:s1_loop_with_single_line.
   class-METHODS:s1_loop_reduce_statement.
   CLASS-METHODS:s1_table_expression.
   CLASS-METHODS:s1_constructor_expression.
   CLASS-METHODS:s1_using_key_expression.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_stt_new_abap_syntax IMPLEMENTATION.




  METHOD if_oo_adt_classrun~main.

  zcl_stt_new_abap_syntax=>s1_table_expression(  ).

    zcl_stt_new_abap_syntax=>s1_constructor_expression(  ).

  zcl_stt_new_abap_syntax=>s1_loop_with_grouping(  ).
   zcl_stt_new_abap_syntax=>s1_using_key_expression(  ).

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

                    TYPES: BEGIN OF ty_final_booking.
                                include type /dmo/booking.
                                TYPES : booking_tx TYPE p  DECIMALS 2 LENGTH 10,
                                           end of TY_FINAL_BOOKING,
                                               tt_final_booking TYPE TABLE of ty_final_booking with DEFAULT KEY.
     DATA : lv_gst TYPE p DECIMALS 2.
            lv_gst = '1.12'.
        SELECT *  FROM /dmo/booking INTO TABLE @DATA(lt_bookings) up to 20 ROWS.
*        loop at lt_bookings INTO wa.
*         lv_amt = lv_gst * wa-booking_amt.
*
*        ENDLOOP.

    DATA(lt_final_booking) = VALUE tt_final_booking(  for wa in lt_bookings (
                                                    travel_id = wa-travel_id
                                                    booking_id = wa-booking_id
                                                    flight_price = wa-flight_price
                                                    booking_tx = COND #(  when wa-flight_price > 400 then wa-flight_price * lv_gst
                                                    else wa-flight_price
                                                  )
                                             )  ).
 loop at lt_final_booking INTO DATA(ls_booking).
  ENDLOOP.
          ENDMETHOD.

  METHOD s1_loop_reduce_statement.
  DATA:lv_total TYPE p DECIMALS 2.
  TYPES: tt_bookings TYPE TABLE of /dmo/booking with DEFAULT KEY.
         SELECT  *  FROM /dmo/booking INTO TABLE @DATA(lt_bookings) up to 20 ROWS .
         if sy-subrc = 0.
         if  lt_bookings is NOT INITIAL.

*         loop at lt_bookings INTO DATA(ls_bookings).
*
*         lv_total = lv_total + ls_bookings-flight_price.
*
*         endloop.
*
         lv_total = REDUCE int4( INIT x =  conv int4(  0 )
                for ls_bookings in lt_bookings
                   next x = x + ls_bookings-flight_price
                    ).

       ENDIF.
         ENDIF.

  ENDMETHOD.

  METHOD s1_table_expression.

*  DATA: itab TYPE TABLE of /dmo/booking with DEFAULT KEY.

       SELECT  *  FROM /dmo/booking INTO TABLE @DATA(itab) up to 20 ROWS .
       if line_exists( itab[ travel_id = '000001' ] ).
       DATA(wa) = itab[ travel_id = '0000001' ].


       DATA(lv_field) = itab[ travel_id = '0000001' ]-flight_price.
              ENDIF.
  ENDMETHOD.

  METHOD s1_constructor_expression.

*  data lo_obj TYPE ref to /dmo/cm_flight_messages.
*  create object lo_obj
*  exporting
*  textid = value #( msgid = 'SY' msgno = 499 )
*  severity = if_abap_behv_message=>severity-error.

    data(lo_obj)  = new  /dmo/cm_flight_messages(
   textid = value #( msgid = 'SY' msgno = 499 )
  severity = if_abap_behv_message=>severity-error
  ).


  ENDMETHOD.

  METHOD s1_using_key_expression.
DATA itab TYPE SORTED TABLE OF /dmo/booking with UNIQUE key travel_id booking_id
                                                                                       with NON-UNIQUE SORTED KEY spiderman COMPONENTS carrier_id connection_id.
     SELECT  *  FROM /dmo/booking INTO TABLE @itab up to 20 ROWS .

       DATA(wa) = itab[ key spiderman carrier_id = 'AA' connection_id = 0322 ]     .
  loop at itab INTO wa USING KEY spiderman WHERE carrier_id = 'AA'.
  ENDLOOP.


  ENDMETHOD.

ENDCLASS.
