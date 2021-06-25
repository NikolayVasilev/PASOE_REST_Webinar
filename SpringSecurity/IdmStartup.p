
/*------------------------------------------------------------------------
    File        : IdmStartup
    Purpose     : 

    Syntax      :

    Description : Load Security domains in the database

    Author(s)   : isyed
    Created     : Fri Aug 11 20:08:26 EDT 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.
DEFINE INPUT PARAMETER startup-data AS CHARACTER NO-UNDO.
DEFINE VAR m_lOk AS LOGICAL NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */


// Loading domain registry for the session
m_lOK = SECURITY-POLICY:LOAD-DOMAINS(1). 

// Validate if load-domains() executed successfully
IF (NOT m_lOk) THEN
 DO:
 MESSAGE "Error loading domains" ERROR-STATUS:GET-MESSAGE(1).
 RETURN ERROR "Error in load-domains():" + ERROR-STATUS:GET-MESSAGE (1).

END.
ELSE DO:
 MESSAGE "domain registries loaded successfully".
 END.  
 
 
