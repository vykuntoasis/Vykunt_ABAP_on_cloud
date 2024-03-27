@EndUserText.label: 'BOOKING processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZSTT_VT_BOOKING_PROCESSOR as projection on ZSTT_VT_BOOKING
{
    key TravelId,
    key BookingId,
    BookingDate,
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Customer',entity.element: 'CustomerID' }]
    CustomerId,
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Carrier',entity.element: 'AirlineID' }]
    CarrierId,
    @Consumption.valueHelpDefinition:
     [{ entity.name: '/DMO/I_Connection',entity.element: 'ConnectionID',
     additionalBinding: [{ localElement: 'CarrierId',element: 'AirlineID' }] }]
    ConnectionId,
    FlightDate,
    FlightPrice,
    CurrencyCode,
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Booking_Status_VH',entity.element: 'BookingStatus' }]
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _Bookingstatus,
    _BookingSupplement:redirected to composition child ZSTT_VT_BOOKSUPPL_PROCESSOR,
    _Carrier,
    _Connection,
    _Customer,
    _Travel :redirected to parent ZSTT_VT_TRAVEL_PROCESSOR
}
