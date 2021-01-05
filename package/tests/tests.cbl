       identification division.
       program-id. testall.
       data division.
       working-storage section.
       01 iban pic x(64).
       01 expected pic x(32) value "1".
       01 actual pic x(32) value spaces.
       01 result redefines actual pic x.
       procedure division.
      * OK
           move "BE71096123456769" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           move "FR7630006000011234567890189" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           move "DE91100000000123456789" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.
           
           move "GR9608100010000001234567890" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.
           
      * NOK
           move "RO09 BCYP 0000 0012 3456 7890" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           move "ES79 2100 0813 6101 2345 6789" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           move "CH56 0483 5012 3456 7800 9" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           move "GB98 MIDL0700 9312 3456 78" to iban.
           call "ibanok" using iban returning result.
           call "ECBLUeq" using expected, actual.

           goback.
       end program testall.
