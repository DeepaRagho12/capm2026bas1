
using { dip.db.CDSViews } from '../db/CDSViews';
using {dip.db.master , dip.db.transaction } from '../db/datamodel';



service CDSService @(path:'/CDSViews'){
    entity POWorklist as projection on CDSViews.POWorklist;

   entity ProductOrders as projection on CDSViews.ProductViewsub;
   entity ProductAggregation as projection on CDSViews.CProductValues;

    }
 
