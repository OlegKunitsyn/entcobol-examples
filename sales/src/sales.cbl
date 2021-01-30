       *>**
       *>  SALES
       *>  @author Olegs Kunicins
       *>  @license MIT
       *>**

       *>*
       *> Entry point
       *>*
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 where PIC X(48) VALUE 'Europe'.
       01 total PIC 9(9)V99.
       01 out.
           05 FILLER PIC X(6) VALUE 'Total:'.
           05 FILLER PIC X VALUE SPACE.
           05 out-total PIC 9(10).99.
       PROCEDURE DIVISION.
           CALL "READER" USING where RETURNING total.
           MOVE total TO out-total
           DISPLAY out
           STOP RUN.
       END PROGRAM SALES.
