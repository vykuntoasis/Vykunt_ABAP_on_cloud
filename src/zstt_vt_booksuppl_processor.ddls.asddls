@EndUserText.label: 'BOOKING supplement processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZSTT_VT_BOOKSUPPL_PROCESSOR as projection on ZSTT_VT_BOOKSUPPL
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking :redirected to parent ZSTT_VT_BOOKING_PROCESSOR,
    _Product,
    _SupplementText,
    _Travel : redirected to ZSTT_VT_TRAVEL_PROCESSOR
}
