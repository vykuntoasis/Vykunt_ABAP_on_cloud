@EndUserText.label: 'BOOKING processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZSTT_VT_BOOKING_APPROVER as projection on ZSTT_VT_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    
    CustomerId,
  
    CarrierId,
    
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
   
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _Bookingstatus,
    
    _Carrier,
    _Connection,
    _Customer,
    _Travel :redirected to parent ZSTT_VT_TRAVEL_approver
}
