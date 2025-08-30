@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help on the Status Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'StatusCode'
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #CUSTOMIZING
}
@VDM.viewType: #COMPOSITE
@Search.searchable: true
define view entity ZDD_STATUS2_VH_073
  as select from zdt_status_073
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element:['StatusDescription']
      @UI.lineItem: [{ position: 10, importance: #HIGH }]
  key status_code        as StatusCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text:true
      @UI.lineItem: [{ position: 20, importance: #HIGH }]      
      status_description as StatusDescription
}
