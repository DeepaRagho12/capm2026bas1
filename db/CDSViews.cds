namespace dip.db;

using
{
    dip.db.master,
    dip.db.transaction
}
from './datamodel';

entity magic
{
    key ID : UUID;
    name : String(100);
    salary : Decimal(10,2);
    currency : String(4);
}

context CDSViews
{
    annotate ItemView
    {
        Partner
            @title : '{i18n>bpNodeKey}';
    }

    annotate POWorklist
    {
        PartnerId
            @title : '{i18n>bpId}';
    }

    annotate ProductValueHelp
    {
        ProductId
            @EndUserText.label : 'Product ID';
        Description
            @EndUserText.label : 'Product Description';
    }

    annotate ProductView
    {
        BPId
            @title : '{i18n>bpId}';
    }

    entity POWorklist as
        select from transaction.purchaseorder
        {
            key PO_ID as PurchaseOrderId,
            PARTNER_GUID.BP_ID as PartnerId,
            PARTNER_GUID.COMPANY_NAME as CompanyName,
            GROSS_AMOUNT as POGrossAmount,
            CURRENCY_CODE as POCurrencyCode,
            LIFECYCLE_STATUS as POStatus,
            key Items.PO_ITEM_POS as ItemPosition,
            Items.PRODUCT_GUID.PRODUCT_ID as ProductId,
            Items.PRODUCT_GUID.DESCRIPTION as ProductName,
            PARTNER_GUID.toAddress.CITY as City,
            PARTNER_GUID.toAddress.COUNTRY as Country,
            Items.GROSS_AMOUNT as GrossAmount,
            Items.NET_AMOUNT as NetAmount,
            Items.TAX_AMOUNT as TaxAmount,
            Items.CURRENCY_CODE as CurrencyCode
        };

    entity ProductValueHelp as
        select from master.product
        {
                @EndUserText.label : 'Product ID'
            PRODUCT_ID as ProductId,
                @EndUserText.label : 'Product Description'
            DESCRIPTION as Description
        };

    entity ItemView as
        select from transaction.poitems
        {
            PARENT_KEY.PARTNER_GUID.NODE_KEY as Partner,
            PRODUCT_GUID.NODE_KEY as ProductId,
            CURRENCY_CODE as CurrencyCode,
            GROSS_AMOUNT as GrossAmount,
            NET_AMOUNT as NetAmount,
            TAX_AMOUNT as TaxAmount,
            PARENT_KEY.OVERALL_STATUS as POStatus
        };

    entity ProductViewsub as
        select from master.product as prod
        left join transaction.poitems as item on item.PRODUCT_NODE_KEY = prod.NODE_KEY
        {
            key prod.PRODUCT_ID as ProductId,
            prod.texts.DESCRIPTION as Description,
            SUM(item.GROSS_AMOUNT) as PO_SUM
        }
        group by prod.PRODUCT_ID, prod.texts.DESCRIPTION;

    entity ProductView as
        select from master.product
        mixin
        {
            PO_ORDERS : Association [*] to ItemView on PO_ORDERS.ProductId =$projection.ProductId
        }
        into
        {
            NODE_KEY as ProductId,
            DESCRIPTION,
            CATEGORY as Category,
            PRICE as Price,
            TYPE_CODE as TypeCode,
            SUPPLIER_GUID.BP_ID as BPId,
            SUPPLIER_GUID.COMPANY_NAME as CompanyName,
            SUPPLIER_GUID.toAddress.CITY as City,
            SUPPLIER_GUID.toAddress.COUNTRY as Country,
            PO_ORDERS
        };

    entity CProductValues as
        select from ProductView
        {
            ProductId,
            Country,
            PO_ORDERS.CurrencyCode as CurrencyCode,
            sum(PO_ORDERS.GrossAmount) as POGrossAmount
        }
        group by ProductId, Country, PO_ORDERS.CurrencyCode;
}
