CLASS zstt_vt_data_builder DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS fill_transaction_data.
    METHODS fill_master_data.
    METHODS flush.
ENDCLASS.



CLASS zstt_vt_data_builder IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    flush( ).
    fill_master_data( ).
    fill_transaction_data(  ).
    out->write(
      EXPORTING
        data   = 'processing is completed successfully!'
*        name   =
*      RECEIVING
*        output =
    ).
  ENDMETHOD.

  METHOD fill_master_data.
    data : lt_bp type table of zstt_vt_bpa,
           lt_prod type table of zstt_vt_product.

    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'SAP'
                    street = 'Rosvelt Street Road'
                    city = 'Walldorf'
                    country = 'DE'
                    region = 'EMEA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Asia High tech'
                    street = '1-7-2 Otemachi'
                    city = 'Tokyo'
                    country = 'JP'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'AVANTEL'
                    street = 'Bosque de Duraznos'
                    city = 'Maxico'
                    country = 'MX'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Pear Computing Services'
                    street = 'Dunwoody Xing'
                    city = 'Atlanta, Georgia'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'PicoBit'
                    street = 'Fith Avenue'
                    city = 'New York City'
                    country = 'US'
                    region = 'NA'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'TACUM'
                    street = 'Victoria Street'
                    city = 'Kolkatta'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.
    append value #(
                    bp_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    bp_role = '01'
                    company_name = 'Indian IT Trading Company'
                    street = 'Nariman Point'
                    city = 'Mumbai'
                    country = 'IN'
                    region = 'APJ'
                    )
                    to lt_bp.

   append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Blaster Extreme'
                    category = 'Speakers'
                    price = 1500
                    currency = 'INR'
                    discount = 3
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Sound Booster'
                    category = 'Speakers'
                    price = 2500
                    currency = 'INR'
                    discount = 2
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Smart Office'
                    category = 'Software'
                    price = 1540
                    currency = 'INR'
                    discount = 32
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Smart Design'
                    category = 'Software'
                    price = 2400
                    currency = 'INR'
                    discount = 12
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Transcend Carry pocket'
                    category = 'PCs'
                    price = 14000
                    currency = 'INR'
                    discount = 7
                    )
                    to lt_prod.
    append value #(
                    product_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32( )
                    name = 'Gaming Monster Pro'
                    category = 'PCs'
                    price = 15500
                    currency = 'INR'
                    discount = 8
                    )
                    to lt_prod.

     insert zstt_vt_bpa from table @lt_bp.
     insert zstt_vt_product from table @lt_prod.
  ENDMETHOD.

  METHOD fill_transaction_data.
    data : o_rand type REF TO cl_abap_random_int,
           n type i,
           seed type i,
           lv_date type timestamp,
           lv_ord_id type zstt_vt_dte_id,
           lt_so type table of zstt_vt_so_hdr,
           lt_so_i type table of zstt_vt_so_item.

    seed = cl_abap_random=>seed( ).
    cl_abap_random_int=>create(
      EXPORTING
        seed = seed
        min  = 1
        max  = 7
      RECEIVING
        prng = o_rand
    ).
    get time stamp FIELD lv_date.

    select * from zstt_vt_bpa into table @data(lt_bpa).
    select * from zstt_vt_product into table @data(lt_prod).

    do 50 times.
        lv_ord_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  ).
        n = o_rand->get_next( ).
        read table lt_bpa into data(ls_bp) index n.
        append value #(
                order_id = lv_ord_id
                order_no = sy-index
                buyer = ls_bp-bp_id
                gross_amount = 10 * n
                currency_code = 'EUR'
                created_by = sy-uname
                created_on = lv_date
                changed_by = sy-uname
                changed_on = lv_date
         ) to lt_so.
        do 2 times.
            read table lt_prod into data(ls_prod) index n.
            append value #(
                item_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_c32(  )
                order_id = lv_ord_id
                product = ls_prod-product_id
                qty =  n
                uom = 'EA'
                amount =  n * ls_prod-price
                currency = ls_prod-currency
         ) to lt_so_i.

        enddo.
    enddo.

    insert zstt_vt_so_hdr from table @lt_so.
    insert zstt_vt_so_item from table @lt_so_i.

  ENDMETHOD.

  METHOD flush.
    delete from : zstt_vt_bpa, zstt_vt_product, zstt_vt_so_hdr, zstt_vt_so_item.
  ENDMETHOD.

ENDCLASS.
