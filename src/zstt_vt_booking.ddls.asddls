 @AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOOKING CHILD entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTT_VT_BOOKING as select from /dmo/booking_m
composition[0..*] of ZSTT_VT_BOOKSUPPL as _BookingSupplement

association to parent ZSTT_VT_TRAVEL as _Travel on
$projection.TravelId = _Travel.TravelId

association[1..1] to /DMO/I_Customer as _Customer on
$projection.CustomerId = _Customer.CustomerID
association[1..1] to /DMO/I_Carrier as _Carrier on
$projection.CarrierId = _Carrier.AirlineID 
association[1..1] to /DMO/I_Connection as _Connection on
$projection.CarrierId = _Connection.AirlineID and
$projection.ConnectionId = _Connection.ConnectionID 
association[1..1] to /DMO/I_Booking_Status_VH as _Bookingstatus on
$projection.BookingStatus = _Bookingstatus.BookingStatus

{
    key travel_id as TravelId,
    key booking_id as BookingId,
    booking_date as BookingDate,
    customer_id as CustomerId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    flight_price as FlightPrice,
    currency_code as CurrencyCode,
    booking_status as BookingStatus,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Customer,
    _Carrier,
    _Connection,
    _Bookingstatus,
    _Travel,
    _BookingSupplement
}
