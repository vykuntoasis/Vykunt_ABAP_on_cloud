@EndUserText.label: 'procesor projet layer'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZSTT_VT_TRAVEL_APPROVER as projection on ZSTT_VT_TRAVEL
{
   @ObjectModel.text.element: [ 'Description' ]
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Agency',entity.element: 'AgencyID' }]
    AgencyId,
    _agency.Name as AgencyName,
    @ObjectModel.text.element: [ 'CustomerName' ]
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Customer',entity.element: 'CustomerID' }]
    CustomerId,
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    BookingFee,
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'StatusText' ]
    @Consumption.valueHelpDefinition: 
    [{ entity.name: '/DMO/I_Overall_Status_VH',entity.element: 'OverallStatus' }]
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    @Semantics.text: true
    StatusText,
    Criticality,
    /* Associations */
    _agency,
    _Booking:redirected to composition child ZSTT_VT_BOOKING_APPROVER,
    _Currency,
    _Customer,
    _Overallstatus
}
