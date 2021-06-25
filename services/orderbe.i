/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
   File        : OrderBE
   Purpose		:
   Syntax      : 
   Description :
   Author(s)   : pjudge
   Created     : Mon Nov 09 14:33:33 EST 2020
   Notes       : 
 ----------------------------------------------------------------------*/
define temp-table ttOrder before-table bttOrder
    field Ordernum     as integer   initial "0" label "Order Num"
    field CustNum      as integer   initial "0" label "Cust Num"
    field OrderDate    as date      initial "TODAY" label "Ordered"
    field ShipDate     as date      label "Shipped"
    field PromiseDate  as date      label "Promised"
    field Carrier      as character label "Carrier"
    field Instructions as character label "Instructions"
    field PO           as character label "PO"
    field Terms        as character initial "Net30" label "Terms"
    field SalesRep     as character label "Sales Rep"
    field BillToID     as integer   initial "0" label "Bill To ID"
    field ShipToID     as integer   initial "0" label "Ship To ID"
    field OrderStatus  as character initial "Ordered" label "Order Status"
    field WarehouseNum as integer   initial "0" label "Warehouse Num"
    field Creditcard   as character initial "Visa" label "Credit Card"
    index CustOrder is unique        CustNum     ascending Ordernum ascending 
    index OrderDate                  OrderDate   ascending 
    index OrderNum is primary unique Ordernum    ascending 
    index OrderStatus                OrderStatus ascending 
    index SalesRep                   SalesRep    ascending . 


define temp-table ttOLine before-table bttOLine
    field Discount        as integer   format ">>9%" label "Discount"
    field ExtendedPrice   as decimal   decimals 2 format "->>>,>>9.99" label "Extended Price"
    field Itemnum         as integer   format "zzzzzzzzz9" label "Item Num"
    field Linenum         as integer   format ">>9" label "Line Num"
    field OrderLineStatus as character format "x(20)" initial "Ordered" label "Order Line Status"
    field Ordernum        as integer   format "zzzzzzzzz9" label "Order Num"
    field Price           as decimal   decimals 2 format "->,>>>,>>9.99" label "Price"
    field Qty             as integer   format "->>>>9" label "Qty"
    index idx1 Ordernum Linenum
    .
    

define dataset dsOrder for ttOrder, ttOLine
    data-relation for ttOrder, ttOLine relation-fields (Ordernum, Ordernum).
    