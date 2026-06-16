@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: '/DMO/TRAVEL'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZIR_Travel_40

  as select from /dmo/travel

  association     to /dmo/trvl_stat_t as _Travel_T on  $projection.Status = _Travel_T.travel_status

                                                   and _Travel_T.language = 'E'

  association [1] to /DMO/I_Agency    as _Agency   on  $projection.AgencyId = _Agency.AgencyID

  association [1] to /DMO/I_Customer  as _Customer on  $projection.CustomerId = _Customer.CustomerID

{

  key travel_id                          as TravelId,

      agency_id                          as AgencyId,

      customer_id                        as CustomerId,

      begin_date                         as BeginDate,

      end_date                           as EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'

      booking_fee                        as BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'

      total_price                        as TotalPrice,

      currency_code                      as CurrencyCode,

      description                        as Description,

      status                             as Status,

      createdby                          as Createdby,

      createdat                          as Createdat,

      lastchangedby                      as Lastchangedby,

      lastchangedat                      as Lastchangedat,

      /*Logical Fields*/

      concat( 'Agency ID: ', agency_id ) as Log_DesAgency,

      cast ( case status

       when 'N'

       then 2

       when 'P'

       then 1

       when 'B'

       then 3

       else 0

       end      as abap.int2 )           as Log_DataPointProgres,

      cast ( case status

       when 'N'

       then 2

       when 'P'

       then 2

       when 'B'

       then 3

       else 1

       end      as abap.int2 )           as Log_criticalityProgres,

      cast('90' as abap.int2 )           as customxx,

      _Agency,

      _Customer,

      _Travel_T

}
