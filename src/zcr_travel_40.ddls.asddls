@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCR_TRAVEL_40'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZCR_TRAVEL_40
  provider contract transactional_query
  as projection on ZIR_Travel_zxx
{
      @Search.defaultSearchElement: true
  key TravelId,
      @Search.defaultSearchElement: true
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      Status,
      Createdby,
      Createdat,
      Lastchangedby,
      Lastchangedat,
      _Travel_T.text       as TravelText,

      /*Logical Fields*/
      Log_DesAgency,
      Log_DataPointProgres,
      Log_criticalityProgres,

      /* Associations */
      _Agency.Name         as AgencyEmplName,
      _Agency.City         as AgencyCity,
      _Agency.CountryCode  as AgencyCountry,
      _Agency.EMailAddress as AgencyEmail,
      _Agency.WebAddress   as AgencyWeb,
      _Agency.PhoneNumber  as AgencyPhone,


      _Customer.FirstName,
      _Customer.LastName,
      _Customer.EMailAddress,
      _Customer.PhoneNumber,
      _Customer.City,
      _Customer.CountryCode,

      customxx,
      _Agency,
      _Customer,
      _Travel_T
}
