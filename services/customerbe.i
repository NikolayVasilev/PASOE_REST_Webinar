/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
   File        : CustomerBE
   Purpose		:
   Syntax      : 
   Description :
   Author(s)   : pjudge
   Created     : Mon Nov 09 14:32:56 EST 2020
   Notes       : 
 ----------------------------------------------------------------------*/
define temp-table ttCustomer before-table bttCustomer
    field CustNum      as integer   initial "0" label "Cust Num"
    field Country      as character initial "USA" label "Country"
    field Name         as character label "Name"
    field Address      as character label "Address"
    field Address2     as character label "Address2"
    field City         as character label "City"
    field State        as character label "State"
    field PostalCode   as character label "Postal Code"
    field Contact      as character label "Contact"
    field Phone        as character label "Phone"
    field SalesRep     as character label "Sales Rep"
    field CreditLimit  as decimal   initial "1500" label "Credit Limit"
    field Balance      as decimal   initial "0" label "Balance"
    field Terms        as character initial "Net30" label "Terms"
    field Discount     as integer   initial "0" label "Discount"
    field Comments     as character label "Comments"
    field Fax          as character label "Fax"
    field EmailAddress as character label "Email"
    index Comments                  Comments ascending 
    index CountryPost               Country  ascending PostalCode ascending 
    index CustNum is primary unique CustNum  ascending 
    index Name                      Name     ascending 
    index SalesRep                  SalesRep ascending. 

define dataset dsCustomer for ttCustomer.