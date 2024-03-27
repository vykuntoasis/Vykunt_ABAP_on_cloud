@EndUserText.label: 'BOOKING processor projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZSTT_VT_ATTACH_PROCESSOR as projection on zstt_vt_m_attach
{
     key TravelId,
    key Id,
    Memo,
    Attachment,
    Filetype,
    Filename,
    LastChangedAt,
    LocalCreatedAt,
    LocalCreatedBy,
    LocalLastChangedAt,
    LocalLastChangedBy,
    _Travel: redirected to parent Zstt_vt_TRAVEL_PROCESSOR
}
