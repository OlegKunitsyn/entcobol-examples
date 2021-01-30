       *>**
       *>  PARSER
       *>  @author Olegs Kunicins
       *>  @license MIT
       *>**
       
       *>*
       *> Parses CSV row into SALES copybook
       *>
       *> @param row Comma-separated CSV string, X(80)
       *> @return SALES copybook
       *>*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PARSER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 tmpPrice PIC X(12).
       01 tmpRevenue PIC X(12).
       LINKAGE SECTION. 
       01 row PIC X(80).
       COPY SALES.
       PROCEDURE DIVISION USING row RETURNING csv-rec.
           UNSTRING row DELIMITED BY ',' INTO 
              Region
              Country
              UnitsSold
              tmpPrice
              tmpRevenue.
           COMPUTE UnitPrice = FUNCTION NUMVAL(tmpPrice).
           COMPUTE TotalRevenue = FUNCTION NUMVAL(tmpRevenue).
           GOBACK.
       END PROGRAM PARSER.
