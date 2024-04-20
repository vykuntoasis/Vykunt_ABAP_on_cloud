@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Composite, Cube view for sales data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
define view entity ZI_STT_VT_SALES_CUBE as select from ZI_stt_vt_SALES
association[1] to ZI_ATS_XX_BPA as _BusinessPartner on
$projection.Buyer = _BusinessPartner.BpId
association[1] to ZI_ATS_XX_PRODUCT as _Product on 
$projection.Product = _Product.ProductId
{
    key ZI_stt_vt_SALES.OrderId,
    key ZI_stt_vt_SALES._Items.item_id as ItemId,
    ZI_stt_vt_SALES.OrderNo,
    ZI_stt_vt_SALES.Buyer,
    ZI_stt_vt_SALES.CreatedBy,
    ZI_stt_vt_SALES.CreatedOn,
    /* Associations */
    ZI_stt_vt_SALES._Items.product as Product,
    @DefaultAggregation: #SUM
    @Semantics.amount.currencyCode: 'CurrencyCode'
    ZI_stt_vt_SALES._Items.amount as GrossAmount,
    ZI_stt_vt_SALES._Items.currency as CurrencyCode,
    @DefaultAggregation: #SUM
    @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
    ZI_stt_vt_SALES._Items.qty as Quantity,
    ZI_stt_vt_SALES._Items.uom as UnitOfMeasure,
    _Product,
    _BusinessPartner
}

