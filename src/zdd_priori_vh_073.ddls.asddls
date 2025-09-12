@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help on the Priority Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'PriorityCode'
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #CUSTOMIZING
}
@VDM.viewType: #COMPOSITE
@Search.searchable: true
define view entity ZDD_PRIORI_VH_073
  as select from zdt_priority_073
{
      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 10, importance: #HIGH }]     
      @ObjectModel.text.element:['PriorityDescription']
  key priority_code        as PriorityCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text:true
      @UI.lineItem: [{ position: 20, importance: #HIGH }]     
     priority_description as PriorityDescription
}
