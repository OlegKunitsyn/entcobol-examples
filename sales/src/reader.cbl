       *>*
       *> Filters CSV rows by `where` and aggregates TotalRevenue
       *>*
       *> @param where Region or Country filter
       *> @return Aggregated TotalRevenue
       *>*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. READER.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT sales ASSIGN TO sales
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS file-status.
       DATA DIVISION.
       FILE SECTION.
       FD sales RECORDING MODE F
           RECORD CONTAINS 80 CHARACTERS
           LABEL RECORDS ARE OMITTED
           DATA RECORD IS csv-row.
       01 csv-row PIC X(80) VALUE SPACES.
       WORKING-STORAGE SECTION.
       01 eof PIC X VALUE 'N'.
           88 eof-reached VALUE 'Y'.
       01 header PIC X VALUE 'Y'.
           88 not-header VALUE 'N'.
       01 file-status PIC 9(2).
       COPY SALES.
       LINKAGE SECTION.
       01 where PIC X(48).
       01 total PIC 9(9)V99 VALUE 0.
       PROCEDURE DIVISION USING where RETURNING total.
           OPEN INPUT sales.
           IF file-status NOT EQUAL ZERO
             DISPLAY "Error reading file"
             MOVE 1 TO RETURN-CODE
             GOBACK
           END-IF.

           INITIALIZE eof, header, total.
           PERFORM UNTIL eof-reached
             READ sales 
               AT END
                 SET eof-reached TO TRUE
               NOT AT END
                 IF not-header
                   CALL 
                     "PARSER" USING csv-row RETURNING csv-rec
                   END-CALL
                   IF Region EQUAL where OR Country EQUAL where
      D              DISPLAY csv-row
                     ADD TotalRevenue TO total
                   END-IF
                 END-IF
                 SET not-header TO TRUE
             END-READ
           END-PERFORM.
           
           CLOSE sales.
           GOBACK.
       END PROGRAM READER.
