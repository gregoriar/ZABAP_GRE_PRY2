@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'History Child Consumtion'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_DT_INCDT2_H_073 
   as projection on ZDD_INCT_H_073
{
    key HisUuid,
    key IncUuid,
    HisId,
    PreviousStatus,
    NewStatus,
    Text,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _IncidentsMain: redirected to parent ZC_DT_INCDT_073
}
