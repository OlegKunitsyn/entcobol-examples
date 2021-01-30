       *>*
       *> Mock
       *>*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. READER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY SALES.
       01 csv-row PIC X(48) VALUE  'Europe,Germany,10,9.99,99.90'.
       LINKAGE SECTION.
       01 where PIC X(48).
       01 total PIC 9(9)V99 VALUE 0.
       PROCEDURE DIVISION USING where RETURNING total.
           CALL "PARSER" USING csv-row RETURNING csv-rec.
           MOVE TotalRevenue to total.
       END PROGRAM READER.
       
       *>*
       *> Tests
       *>*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTALL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY SALES.
       01 csv-row PIC X(80) VALUE  'Asia,Malaysia,6267,9.33,58471.11'.
       01 expected-rec.
           05  Region              PIC X(48) VALUE      'Asia'.
           05  Country             PIC X(48) VALUE      'Malaysia'.
           05  UnitsSold           PIC 9(9) VALUE       6267.
           05  UnitPrice           PIC 9(9)V99 VALUE    9.33.
           05  TotalRevenue        PIC 9(9)V99 VALUE    58471.11.
       01 total                    PIC 9(9)V99 VALUE    0.
       01 expected-total           PIC 9(9)V99 VALUE    99.90.
       PROCEDURE DIVISION.
       ALL-TESTS SECTION.
           PERFORM PARSER-TEST.
           PERFORM READER-TEST.
           GOBACK.

       PARSER-TEST SECTION.
           CALL "PARSER" USING csv-row RETURNING csv-rec.
           CALL "ECBLUREQ" USING
             BY CONTENT ADDRESS OF expected-rec
             BY CONTENT ADDRESS OF csv-rec
             BY CONTENT LENGTH OF expected-rec.
       
       READER-TEST SECTION.
           CALL "READER" USING Region OF expected-rec RETURNING total.
           CALL "ECBLUREQ" USING
             BY CONTENT ADDRESS OF expected-total
             BY CONTENT ADDRESS OF total
             BY CONTENT LENGTH OF expected-total.
       END PROGRAM TESTALL.
