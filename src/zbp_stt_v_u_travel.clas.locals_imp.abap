CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    types: tt_travel_failed TYPE table for failed ZSTT_V_U_TRAVEL,
             tt_travel_reported type table for REPORTED ZSTT_V_U_TRAVEL.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS set_booked_status FOR MODIFY
      IMPORTING keys FOR ACTION Travel~set_booked_status RESULT result.

      ""Custom reuse function, which will capture messages coming from
    ""old legacy code in the format what RAP understands
    METHODS map_messages
        IMPORTING
            cid type string OPTIONAL
            travel_id type /dmo/travel_id OPTIONAL
            messages type /dmo/t_message
        EXPORTING
            failed_added type abap_bool
        changing
            failed type tt_travel_failed
            reported type tt_travel_reported.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ""Step 1: Data declaration
    data: messages type /dmo/t_message,
           travel_in   type /dmo/travel,
           travel_out type /dmo/travel.

    "Loop at the incoming data from Fiori app/from EML
    loop at entities ASSIGNING FIELD-SYMBOL(<travel_Create>).
    ""Step 2: Get the incoming data in a structure which our legacy code understand
        travel_in = CORRESPONDING #( <travel_Create> mapping from entity using control ).
    ""Step 3: Call the Legacy code (old code) to set data to transaction buffer
        /dmo/cl_flight_legacy=>get_instance(  )->create_travel(
          EXPORTING
            is_travel             = CORRESPONDING /dmo/s_travel_in( travel_in )
         IMPORTING
             es_travel             = travel_out
            et_messages           = data(lt_messages)
        ).

    ""Step 4: Handle the incoming error messages
        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

    ""Step 5: Map the messages to the RAP output
        map_messages(
          EXPORTING
            cid          = <travel_create>-%cid
            travel_id    = <travel_create>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

        if data_failed = abap_true.
            insert value #( %cid = <travel_create>-%cid
                                travelid =          <travel_create>-TravelId
            ) into table mapped-travel.
        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.
  ""Step 1: Data declaration
    data: messages type /dmo/t_message,
           travel_in   type /dmo/travel,
           travel_u   type /dmo/s_travel_inx.

    "Loop at the incoming data from Fiori app/from EML
    loop at entities ASSIGNING FIELD-SYMBOL(<travel_update>).
    ""Step 2: Get the incoming data in a structure which our legacy code understand
        travel_in = CORRESPONDING #( <travel_update> mapping from entity using control ).

        travel_u-travel_id = travel_in-travel_id.
        travel_u-_intx = CORRESPONDING #( <travel_update> MAPPING from ENTITY ).

    ""Step 3: Call the Legacy code (old code) to set data to transaction buffer
        /dmo/cl_flight_legacy=>get_instance(  )->update_travel(
          EXPORTING
            is_travel              = CORRESPONDING /dmo/s_travel_in(  travel_in )
            is_travelx             = travel_u
          IMPORTING
            et_messages            = data(lt_messages)
        ).

    ""Step 4: Handle the incoming error messages
        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

    ""Step 5: Map the messages to the RAP output
        map_messages(
          EXPORTING
            cid          = <travel_update>-%cid_ref
            travel_id    = <travel_update>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  data : messages type /dmo/t_message.

    loop at keys ASSIGNING FIELD-SYMBOL(<travel_delete>).
        /dmo/cl_flight_legacy=>get_instance(  )->delete_travel(
          EXPORTING
            iv_travel_id = <travel_delete>-TravelId
          IMPORTING
            et_messages  = data(lt_messages)
        ).

            ""Step 4: Handle the incoming error messages
        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).



    ""Step 5: Map the messages to the RAP output
        map_messages(
          EXPORTING
            cid          = <travel_delete>-%cid_ref
            travel_id    = <travel_delete>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  data : travel_out type /dmo/travel,
               messages type /dmo/t_message,
               lv_failed type abap_boolean.

        loop at keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-TravelId.

            /dmo/cl_flight_legacy=>get_instance(  )->get_travel(
              EXPORTING
                iv_travel_id           = <travel_to_read>-TravelId
                iv_include_buffer      = abap_false
              IMPORTING
                es_travel              =  travel_out
                et_messages            = data(lt_messages)
            ).

        /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
          EXPORTING
            it_messages = lt_messages
          IMPORTING
            et_messages = messages
        ).

        map_messages(
          EXPORTING
            travel_id    = <travel_to_read>-TravelId
            messages     = messages
          IMPORTING
            failed_added = data(data_failed)
          CHANGING
            failed       = failed-travel
            reported     = reported-travel
        ).

          if data_failed = abap_false.
            insert CORRESPONDING #( travel_out mapping to entity ) into table result.
          ENDIF.

        ENDLOOP.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD set_booked_status.
  DATA : messages                  TYPE /dmo/t_message,
           travel_out                     TYPE /dmo/travel,
           travel_set_status_booked LIKE LINE OF result.

    CLEAR result.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_set_status_booked>).
      DATA(travel_id) = <travel_set_status_booked>-TravelId.

      /dmo/cl_flight_legacy=>get_instance(  )->set_status_to_booked(
        EXPORTING
          iv_travel_id = travel_id
        IMPORTING
          et_messages  = DATA(lt_messages)
      ).

      /dmo/cl_flight_legacy=>get_instance(  )->convert_messages(
        EXPORTING
          it_messages = lt_messages
        IMPORTING
          et_messages = messages
      ).

      map_messages(
        EXPORTING
*          cid          =
          travel_id    = travel_id
          messages     = messages
        IMPORTING
          failed_added = DATA(lv_failed)
        CHANGING
          failed       = failed-travel
          reported     = reported-travel
      ).

      IF lv_failed = abap_false.

        /dmo/cl_flight_legacy=>get_instance(  )->get_travel(
          EXPORTING
            iv_travel_id           = travel_id
            iv_include_buffer      = abap_false
*          iv_include_temp_buffer =
          IMPORTING
            es_travel              = travel_out
*          et_booking             =
*          et_booking_supplement  =
*          et_messages            =
        ).
      ENDIF.

      travel_set_status_booked-%param = CORRESPONDING #( travel_out  MAPPING TO ENTITY ).
      travel_set_status_booked-TravelId =   travel_id.
      travel_set_status_booked-%param-TravelId = travel_id.
      APPEND travel_set_status_booked TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD map_messages.
failed_added = abap_false.

    LOOP AT messages INTO DATA(message).

      IF message-msgty = 'E' OR message-msgty = 'A'.
        APPEND VALUE #( %cid = cid
                        travelid = travel_id
                        %fail-cause = /dmo/cl_travel_auxiliary=>get_cause_from_message( msgid = message-msgid
                                                                              msgno = message-msgno is_dependend = abap_false )
                        ) TO failed.

        failed_added = abap_true.

      ENDIF.
      APPEND VALUE #( %msg = new_message(  id = message-msgid
                                           number = message-msgno
                                           v1 = message-msgv1
                                           v2 = message-msgv2
                                           v3 = message-msgv3
                                           v4 = message-msgv4
                                           severity = if_abap_behv_message=>severity-information
                                              )
                                              %cid = cid
                                              travelid = travel_id
       ) TO reported.
      ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSTT_V_U_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSTT_V_U_TRAVEL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ""checks
    ""if check fails - BAPI_TRANSACTION_ROLLBACK
  ENDMETHOD.

  METHOD save.
  /dmo/cl_flight_legacy=>get_instance(  )->save( ).
  ENDMETHOD.

  METHOD cleanup.
  /dmo/cl_flight_legacy=>get_instance(  )->initialize(  ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
