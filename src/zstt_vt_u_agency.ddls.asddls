@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unmanaged agency view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSTT_VT_U_AGENCY as select from /dmo/agency
association[1] to I_Country as _Country on
$projection.CountryCode = _Country.Country
{
    key agency_id as AgencyId,
    name as Name,
    street as Street,
    postal_code as PostalCode,
    city as City,
    country_code as CountryCode,
    phone_number as PhoneNumber,
    email_address as EmailAddress,
    web_address as WebAddress,
    _Country
}
