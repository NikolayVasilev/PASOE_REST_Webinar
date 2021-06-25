/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : ReadOnlyHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 09 14:55:20 EST 2020
    Notes       : 
  ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using OpenEdge.BusinessLogic.BusinessEntity.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebResponseWriter.
using Progress.Json.ObjectModel.JsonObject.
using services.CustomerBE.
using services.OrderBE.

CLASS api.ReadOnlyHandler INHERITS WebHandler: 

	
		
	/*------------------------------------------------------------------------------
            Purpose: Handler for unsupported methods. The request being serviced and
            		 an optional status code is returned. A zero or null value means 
            		 this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
		return integer(StatusCodeEnum:MethodNotAllowed).
	END METHOD.

	/*------------------------------------------------------------------------------
            Purpose: Handler for unknown methods. The request being serviced and an 
                     optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
	METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
	   return integer(StatusCodeEnum:NotImplemented).
   	END METHOD.
	
	/*------------------------------------------------------------------------------
            Purpose: Default handler for the HTTP GET method. The request being 
                     serviced and an optional status code is returned. A zero or 
                     null value means this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
 	METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
		DEFINE VARIABLE oResponse AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
        DEFINE VARIABLE oWriter   AS OpenEdge.Web.WebResponseWriter  NO-UNDO.
        define variable oBody as JsonObject no-undo.
        define variable hdlDataset as handle no-undo.
        define variable be as BusinessEntity no-undo.
        define variable filter as character no-undo.
            
        /* The WebResponse body is a wrapper around an entire HTTP response message.
           It contains a status code and reason; headers; cookies and a message body.
           
           API-level doc for this and related classes can be found at
           https://documentation.progress.com/output/oehttpclient/      */
        ASSIGN 
            oResponse            = NEW OpenEdge.Web.WebResponse()
            oResponse:StatusCode = INTEGER(StatusCodeEnum:OK)
            .
        
        if poRequest:PathInfo begins '/api/customers' then
        do:
            if num-entries(poRequest:PathInfo, '/':u) eq 4 then
                filter = entry(4, poRequest:PathInfo, '/':u).
            if not filter eq '':u then                 
                filter = 'where CustNum = ' + filter.
            
            be = new services.CustomerBE().
            cast(be, CustomerBE):ReadCustomerBE(filter, output dataset-handle hdlDataset by-reference).
            
            oBody = new JsonObject().
            hdlDataset:write-json('JsonObject', oBody).
        end.
        else
        if poRequest:PathInfo begins '/api/orders' then
        do:
            if num-entries(poRequest:PathInfo, '/':u) eq 4 then
                filter = entry(4, poRequest:PathInfo, '/':u).
            if not filter eq '':u then                 
                filter = 'where OrderNum = ' + filter.
            
            be = new services.OrderBE().
            cast(be, OrderBE):ReadOrderBE(filter, output dataset-handle hdlDataset by-reference).
            
            oBody = new JsonObject().
            hdlDataset:write-json('JsonObject', oBody).
        end.
        else
        if poRequest:PathInfo begins '/api/coffee' then
        do:
            oResponse:StatusCode = integer(StatusCodeEnum:MovedPermanently).
            oResponse:SetHeader(HttpHeaderBuilder:Build('Location')
                                    :Value('/t4t/static/error/error418.html')
                                    :Header).
        end.
        else 
            return integer(StatusCodeEnum:NotFound).
        
        ASSIGN 
            oResponse:Entity      = oBody
            oResponse:ContentType = 'application/json':u
            oWriter               = NEW WebResponseWriter(oResponse)
            .
        oWriter:Open().
        oWriter:Close().
        
        /* A response of 0 means that this handler will build the entire response;
           a non-zero value is mapped to a static handler in the webapp's /static/error folder.
           The mappings are maintained in the webapps's WEB-INF/web.xml 
           A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
           enumeration */
        RETURN 0.
 	END METHOD. 
	
END CLASS.