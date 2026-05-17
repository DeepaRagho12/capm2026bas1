using { dip.db.master, dip.db.transaction } from '../db/datamodel';
service CatalogService  @(path:'/CatalogService') { 

    // @Capabilities : { Insertable, Updatable:false, Deletable }
    entity BusinessPartnerSet as projection on master.businesspartner ;
    entity AddressSet as projection on master.address ;
    entity ProductSet as projection on master.product ;
    // entity ProdTextSet as projection on master.prodtext ;
    entity PurchaseOrderSet as projection on transaction.purchaseorder;
    entity EmployeeSet as projection on master.employee;

    entity POs @(
    title: '{i18n>poHeader}'
) as projection on transaction.purchaseorder{
    *,
    Items: redirected to POItems,


}

entity POItems @( title : '{i18n>poItems}' )
as projection on transaction.poitems{
    *,
    PARENT_KEY: redirected to POs,
    PRODUCT_GUID: redirected to ProductSet
}

}
