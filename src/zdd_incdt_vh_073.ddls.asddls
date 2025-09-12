@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Main Incidents'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'IncidentId'
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #CUSTOMIZING
}
@VDM.viewType: #COMPOSITE
@Search.searchable: true

define view entity ZDD_INCDT_VH_073
  as select from zdt_inct_user073
{
         @UI.hidden: true
  key    inc_uuid    as IncUuid,
         @Search.defaultSearchElement: true
         @UI.lineItem: [{ position: 10, importance: #HIGH }]
         @ObjectModel.text.element:['IncidentId']
  key    incident_id as IncidentId,
         //  title       as Title,

         @Search.defaultSearchElement: true
         @UI.lineItem: [{ position: 30, importance: #HIGH }]
         @ObjectModel.text.element:['Description']
         description as Description,
         status      as Status,
         priority    as Priority,
         
         @Search.defaultSearchElement: true
         @UI.lineItem: [{ position: 60, importance: #HIGH }]
         @ObjectModel.text.element:['CreationDate']        
         creation_date as CreationDate
         //    changed_date as ChangedDate,
        // local_created_by as LocalCreatedBy,
         //    local_created_at as LocalCreatedAt,
         //    local_last_changed_by as LocalLastChangedBy,
         //    local_last_changed_at as LocalLastChangedAt,
         //    last_changed_at as LastChangedAt
}
