       *>*
       *> Validate IBAN checksum for 64 countries
       *> See Wikipedia
       *> International_Bank_Account_Number#Validating_the_IBAN
       *> 
       *> @param l-iban IBAN string
       *> @return "1" in case of success, or "0"
       *>*
       identification division.
       program-id. ibanok.
       environment division. 
       configuration section.
       object-computer. computer
           program collating sequence is ASCII-sequence.
       special-names. alphabet ASCII-sequence is standard-1.
       data division.
       working-storage section.
       01 settings.
         05 filler pic x(4) value "AD24".
         05 filler pic x(4) value "AE23".
         05 filler pic x(4) value "AL28".
         05 filler pic x(4) value "AT20".
         05 filler pic x(4) value "AZ28".
         05 filler pic x(4) value "BA20".
         05 filler pic x(4) value "BE16".
         05 filler pic x(4) value "BG22".
         05 filler pic x(4) value "BH22".
         05 filler pic x(4) value "BR29".
         05 filler pic x(4) value "CH21".
         05 filler pic x(4) value "CR21".
         05 filler pic x(4) value "CY28".
         05 filler pic x(4) value "CZ24".
         05 filler pic x(4) value "DE22".
         05 filler pic x(4) value "DK18".
         05 filler pic x(4) value "DO28".
         05 filler pic x(4) value "EE20".
         05 filler pic x(4) value "ES24".
         05 filler pic x(4) value "FI18".
         05 filler pic x(4) value "FO18".
         05 filler pic x(4) value "FR27".
         05 filler pic x(4) value "GB22".
         05 filler pic x(4) value "GE22".
         05 filler pic x(4) value "GI23".
         05 filler pic x(4) value "GL18".
         05 filler pic x(4) value "GR27".
         05 filler pic x(4) value "GT28".
         05 filler pic x(4) value "HR21".
         05 filler pic x(4) value "HU28".
         05 filler pic x(4) value "IE22".
         05 filler pic x(4) value "IL23".
         05 filler pic x(4) value "IS26".
         05 filler pic x(4) value "IT27".
         05 filler pic x(4) value "KW30".
         05 filler pic x(4) value "KZ20".
         05 filler pic x(4) value "LB28".
         05 filler pic x(4) value "LI21".
         05 filler pic x(4) value "LT20".
         05 filler pic x(4) value "LU20".
         05 filler pic x(4) value "LV21".
         05 filler pic x(4) value "MC27".
         05 filler pic x(4) value "MD24".
         05 filler pic x(4) value "ME22".
         05 filler pic x(4) value "MK19".
         05 filler pic x(4) value "MR27".
         05 filler pic x(4) value "MT31".
         05 filler pic x(4) value "MU30".
         05 filler pic x(4) value "NL18".
         05 filler pic x(4) value "NO15".
         05 filler pic x(4) value "PK24".
         05 filler pic x(4) value "PL28".
         05 filler pic x(4) value "PS29".
         05 filler pic x(4) value "PT25".
         05 filler pic x(4) value "RO24".
         05 filler pic x(4) value "RS22".
         05 filler pic x(4) value "SA24".
         05 filler pic x(4) value "SE24".
         05 filler pic x(4) value "SI19".
         05 filler pic x(4) value "SK24".
         05 filler pic x(4) value "SM27".
         05 filler pic x(4) value "TN24".
         05 filler pic x(4) value "TR26".
         05 filler pic x(4) value "VG24".
       01 settings-table.
         05 countries occurs 64 times indexed by country-idx.
           10 country-code pic x(2).
           10 country-len pic 9(2).
       01 iban pic x(64) value SPACES.
       01 iban-idx pic 9(2).
       01 iban-len pic 9(2) value ZERO.
       01 char-code pic 9(2).
       01 iban-num pic x(128) value SPACES.
       01 iban-num-idx pic 9(2) value 1.
       01 checksum pic 9(3) value ZERO.
       linkage section.
       01 l-iban pic x(64).
       01 l-ok pic x value "0".
       procedure division using l-iban returning l-ok.
           initialize 
             iban-num
             iban-num-idx
             checksum
             iban 
             iban-len
             l-ok
             all to value.
           set country-idx to 1.
           move settings to settings-table.

           *> #1 find length
           inspect l-iban tallying iban-len for characters before SPACE.

           *> #2 validate country-code and length
           search countries at end goback
             when country-code(country-idx) = l-iban(1:2)
               if country-len(country-idx) not = iban-len
                 goback
               end-if
           end-search.
       
           *> #3 castle
           move l-iban(5:) to iban.
           move l-iban(1:4) to iban(iban-len - 3:).
       
           *> #4 convert chars to digits
           perform varying iban-idx from 1 by 1 
             until iban-idx > iban-len
             if iban(iban-idx:1) is numeric
               move iban(iban-idx:1) to iban-num(iban-num-idx:1)
               add 1 to iban-num-idx
             else
               compute char-code = 10 +
                 function ord(iban(iban-idx:1)) - function ord("A")
               move char-code to iban-num(iban-num-idx:2)
               add 2 to iban-num-idx
             end-if
           end-perform.
       
           *> #5 compute MOD97
           perform varying iban-idx from 1 by 1 
             until iban-idx > iban-num-idx - 1
             compute checksum = 10 * checksum + 
               function numval(iban-num(iban-idx:1))
             compute checksum = function mod(checksum, 97)
           end-perform.

           if checksum = 1
              move "1" to l-ok
           end-if.
       end program ibanok.
