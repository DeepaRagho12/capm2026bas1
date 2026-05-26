namespace dip.db;
using { cuid , Currency} from '@sap/cds/common';
using { dip.common } from './common';

type Guid : String(32);


context master {

  entity businesspartner {
    key NODE_KEY: Guid;

    BP_ROLE       : String(2);
    EMAIL_ADDRESS : String(64);
    PHONE_NUMBER  : String(14);
    FAX_NUMBER    : String(14);
    WEB_ADDRESS   : String(64);
    BP_ID         : String(16);
    COMPANY_NAME  : String(80);

    // ✅ Foreign Key
    ADDRESS_GUID  : Guid;

    // ✅ Association
    toAddress : Association to address
        on toAddress.NODE_KEY = ADDRESS_GUID;
  }

  entity address {
    key NODE_KEY: Guid;

    CITY           : String(64);
    POSTAL_CODE    : String(14);
    STREET         : String(64);
    BUILDING       : String(64);
    COUNTRY        : String(2);
    VAL_START_DATE : Date;
    VAL_END_DATE   : Date;
    LATITUDE       : Decimal;

    LONGITUDE      : Decimal;
 
  }
  
  // entity prodtext {
  //   key NODE_KEY: Guid;
  //   PARENT_KEY: Guid;
  //   LANGUAGE: String(2);
  //   TEXT: String(256);
  //   }
  
  entity product {
    key NODE_KEY      : Guid;
    PRODUCT_ID        : String(28);
    TYPE_CODE         : String(2);
    CATEGORY          : String(32);
    DESCRIPTION       : localized String(256);
    SUPPLIER_GUID     : Association to master.businesspartner;
    TAX_TARIF_CODE    : Integer;
    MEASURE_UNIT      : String(2);
    WEIGHT_MEASURE    : Decimal;
    WEIGHT_UNIT       : String(2);
    CURRENCY_CODE     : String(4);
    PRICE             : Decimal;
    WIDTH             : Decimal;
    DEPTH             : Decimal;
    HEIGHT            : Decimal;
    DIM_UNIT          : String(2);
}


  entity employee : cuid{
    nameFirst: String(40);
    nameMiddle: String(40);
    nameLast: String(40);
    nameInitials: String(40);
    sex : common.Gender;
    language: String(5);
    phoneNumber: common.PhoneNumber;
    email: common.Email;
    loginName: String(20);
    Currency: Currency;
    salaryAmount: common.AmountT;
    accountNumber: String(16);
    bankId: String(8);
    bankName: String(64);
    validFrom: Date;
    validTo: Date;

    
  }
 annotate businesspartner with {
  NODE_KEY @title : '{i18n>bpNodeKey}';
  BP_ID @title : '{i18n>bpId}'; 
 }
 

} 
context transaction {
entity purchaseorder : common.Amount {
  key NODE_KEY: Guid;
  PO_ID: String(24);

  PARTNER_NODE_KEY : Guid;

  PARTNER_GUID: Association to master.businesspartner
    on PARTNER_GUID.NODE_KEY = PARTNER_NODE_KEY;

  LIFECYCLE_STATUS: String(1);
  OVERALL_STATUS: String(1);

  // ✅ THIS is the correct way
  Items: Association to many poitems
    on Items.PARENT_KEY = $self;
    NOTE: String(256);
}
entity poitems : common.Amount {
  key NODE_KEY : Guid;

  // ✅ Managed association (VERY IMPORTANT)
  PARENT_KEY : Association to purchaseorder;

  PO_ITEM_POS : Integer;

  PRODUCT_NODE_KEY : Guid;

  // ✅ Proper association with ON condition
  PRODUCT_GUID : Association to master.product
    on PRODUCT_GUID.NODE_KEY = PRODUCT_NODE_KEY;
}

}