@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident Comsumption'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZC_DT_INCDT_073
  provider contract transactional_query
  as projection on ZR_DT_INCT_073
{
  key IncUuid,


      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'IncidentId' ]
      IncidentId,

      Title,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      Description,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'StatusIncident' ]
      Status,
      _Status.status_description     as StatusIncident,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'PriorityIncident' ]
      Priority,
      _Priority.priority_description as PriorityIncident,


      CreationDate,

      ChangedDate,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #MEDIUM
      @ObjectModel.text.element: [ 'LocalCreatedBy' ]
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _HistoryIncidents : redirected to composition child ZC_DT_INCDT2_H_073,
      _Priority,
      _Status
}
