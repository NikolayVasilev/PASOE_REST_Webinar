
/*------------------------------------------------------------------------
    File        : IdmActivate.p
    Purpose     : 

    Syntax      :

    Description : Validate the Client-Principal

    Author(s)   : isyed
    Created     : Fri Aug 11 19:21:04 EDT 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.
DEFINE VARIABLE hCP       AS HANDLE    NO-UNDO.
DEFINE VARIABLE lOK       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cList     AS CHARACTER NO-UNDO.
DEFINE VARIABLE iListSize AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE iListPos  AS INTEGER   NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

// Get the Client-Principal  from CURRENT-REQUEST-INFO Object
hCP = SESSION:CURRENT-REQUEST-INFO:GetClientPrincipal().


// Validate the Client-Principal seal
//lOK = hCP:VALIDATE-SEAL().
lOK=true.

// Verify if the Client-Principal is sealed successfully or not. If not, return error.
IF lOK THEN 
DO:
    // Dump the Client-Principal attributes
   
    MESSAGE "    ID:         '" + hCP:QUALIFIED-USER-ID + "'".
    MESSAGE "    session-id:" hCP:SESSION-ID.
    MESSAGE "    state:" hCP:LOGIN-STATE.
    MESSAGE "    roles: " + hCP:ROLES.
    MESSAGE "     domain: " + hCP:DOMAIN-NAME.
    
    cList = hCP:LIST-PROPERTY-NAMES.
    iListSize = NUM-ENTRIES(cList, ",").
    IF ( 0 < iListSize ) THEN 
    DO iListPos = 1 TO iListSize:
        DEFINE VARIABLE cProp AS CHARACTER NO-UNDO.
        DEFINE VARIABLE cVal  AS CHARACTER NO-UNDO.

        MESSAGE "    properties:".
        cProp = ENTRY(iListPos, cList, ",").
        cVal = hCP:get-property(cProp).
        MESSAGE "          property:" cProp ", value:" cVal.
    END.
    
    // Set the Client-Principal as client to connect with DB.
    SET-DB-CLIENT(hCP).
    
END.
ELSE 
DO:
    RETURN ERROR "Not a valid Client-Principal".
END.



CATCH e AS Progress.Lang.Error :
    
    DEFINE VARIABLE iLoop AS INTEGER NO-UNDO.
    DO iLoop = 1 TO e:NumMessages:
        PUT UNFORMATTED 
            'ERROR: ' e:GetMessage(iLoop) SKIP.
    END.
        
END CATCH.


// Delete the Client-Principal Object handle
FINALLY:
    DELETE OBJECT hCP.    
END FINALLY.