namespace dip.common;

using { } from '@sap/cds/common';

type Gender : String(20) enum {
  Male          = 'M';
  Female        = 'F';
  nonBinary     = 'N';
  noDisclosure  = 'D';
  selfDescribe  = 'S';
};

type AmountT : Decimal(15, 2) @(
  Semantics.amount.currencyCode : 'CURRENCY_CODE',
  sap.units                     : 'CURRENCY_CODE'
);

aspect Amount {
  CURRENCY_CODE : String(4);
  GROSS_AMOUNT  : AmountT;
  NET_AMOUNT    : AmountT;
  TAX_AMOUNT    : AmountT;
}

type PhoneNumber : String(14)
  @assert.format.pattern : '((?:\\+|00)[17](?: |\\-)?|(?:\\+|00)[1-9]\\d{0,2}(?: |\\-)?|(?:\\+|00)1\\-\\d{3}(?: |\\-)?)(0\\d|([0-9]{3})|[1-9]{0,3})(?:((?: |\\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\\-)[0-9]{3}(?: |\\-)[0-9]{4})|([0-9]{7}))';

type Email : String(255)
  @assert.format.pattern : '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$';