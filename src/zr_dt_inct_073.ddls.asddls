@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity Main Incident'
//@Metadata.ignorePropagatedAnnotations:true //False es el valor por defecto, ie cuando no esta explícta
define root view entity ZR_DT_INCT_073
 
  as select from zdt_inct_user073

    composition [0..*]  of ZDD_INCT_H_073 as _HistoryIncidents  
    association [1..1]  to zdt_status_073   as _Status   on _Status.status_code     = $projection.Status
    association [1..1]  to zdt_priority_073 as _Priority on _Priority.priority_code = $projection.Priority
{
  key inc_uuid              as IncUuid,
      incident_id           as IncidentId,
      title                 as Title,
      description           as Description,
      status                as Status,
      priority              as Priority,
      creation_date         as CreationDate,
      changed_date          as ChangedDate,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.user.createdBy: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
          
        _HistoryIncidents, // Make association public
        _Status,
        _Priority
}
