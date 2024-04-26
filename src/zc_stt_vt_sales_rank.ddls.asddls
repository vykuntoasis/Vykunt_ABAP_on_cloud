@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity which joins with TF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_STT_VT_SALES_RANK 
    as select from ZSTT_VT_TF(p_clnt:$session.client) as ranked
inner join zstt_vt_bpa as bpa on
ranked.company_name = bpa.company_name
inner join zats_xx_region as regio on
bpa.region = regio.region
{
    key ranked.company_name,
    @Semantics.amount.currencyCode: 'currency_code'
    ranked.total_sales,
    ranked.currency_code,
    ranked.customer_rank,
    regio.regionname
}
