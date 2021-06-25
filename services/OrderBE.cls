/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
 /*------------------------------------------------------------------------
    File        : OrderBE
    Syntax      : 
    Author(s)   : pjudge
    Created     : Mon Nov 09 14:33:34 EST 2020
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS services.OrderBE INHERITS BusinessEntity:
    {services/orderbe.i}
    
    DEFINE DATA-SOURCE srcOrder FOR Order.
    DEFINE DATA-SOURCE srcOLine FOR OrderLine.
    
    CONSTRUCTOR PUBLIC OrderBE():
        DEFINE VARIABLE hDataSourceArray AS HANDLE NO-UNDO EXTENT 2.
        DEFINE VARIABLE cSkipListArray AS CHARACTER NO-UNDO EXTENT 2.
        
        SUPER (DATASET dsOrder:HANDLE).
        
        /* Data Source for each table in dataset. Should be in table order as defined 
            in DataSet */     
         hDataSourceArray[1] =  DATA-SOURCE srcOrder:HANDLE.
         hDataSourceArray[2] =  DATA-SOURCE srcOLine:HANDLE.
         
         /* Skip-list entry for each table in dataset. Should be in temp-table order 
           as defined in DataSet */
        /* Each skip-list entry is a comma-separated list of field names, to be
            ignored in create stmt */
         cSkipListArray[1] = "".
         cSkipListArray[2] = "".
         
        THIS-OBJECT:ProDataSource = hDataSourceArray.
        THIS-OBJECT:SkipList = cSkipListArray.
    END CONSTRUCTOR.
        
    /*------------------------------------------------------------------------------
            Purpose:  Get one or more records, based on a filter string                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID ReadOrderBE(INPUT filter AS CHARACTER,
                                   OUTPUT DATASET dsOrder):
        SUPER:ReadData(filter).
              
    END METHOD.
    
END CLASS.
