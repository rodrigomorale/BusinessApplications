000100190313         // **************************************************************************
000200200326        //  CUSTOMER20 READ BY NATIVE LANGUAGE (ILE RPG)
000300200709        //  CONTACTS20 ROW RETRIEVED WITH EMBEDDED SQL
000400200709        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER20 AND CONTACTS20
000500190313        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS
000600190314
000700190313           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
000800200326           DCL-F CUSTOMER20 DISK(*EXT) KEYED USAGE(*INPUT)
000900200326                 RENAME(CUSTOMER20:CUSTR);
001201210330
001202210330        // data structure for host variables from CONTACTS20
001203210330           DCL-DS CONTACTS20 EXT END-DS;
001204210330
001205210330        // Standalone fields for indicator variables
001206210330           DCL-S INDLASTCDATE BINDEC(4:0);
001207210330           DCL-S INDNEXTCDATE BINDEC(4:0);
001500190314
001600190314           DCL-S Dummy  Zoned(1);
001700190314
001800190314        //**************************************************************************
001900190314        //*                        ***   M A I N   R O U T I N E   ***
002000190314        //**************************************************************************
002100190314
002200070119                EXSR SummaryInfo;
002300200709                WRITE NEWPAGE;
002400200326                READ CUSTOMER20;
002500070119                DOW NOT %EOF;
002600070119                    EXSR SQLSelect;
002601210330
002602210330                    IF PHNLDC = OLDESTDATE;
002603210330                       HIGHLIGHT = '<-------';
002604210330                    ELSE;
002605210330                       HIGHLIGHT = ' ';
002606210330                    ENDIF;
002607210330
002700190313                    IF *IN01 = *ON;
002800200709                       Write NEWPAGE;
002900190313                       *IN01 = *OFF;
003000070119                    ENDIF;
003100200709                    Write RPTLINE;
003200200326                   READ CUSTOMER20;
003300070119                ENDDO;
003400190313                Write SUMMARY;
003500070119                *INLR = *ON;
003600070119                RETURN;
003700080923        //**********************************************************************
003800080923        //   S Q L S E L E C T   S U B R O U T I N E
003900080923   //   //********************************************************************
004000080923   //                  BEGSR    SQLSelect ;
004100080923   //    // A row from the contacts table that has the same customer number as t
004200200326   //    // read from the CUSTOMER20 file is retrieved to find out the last date
004300080923   //    // phone number, comments and the salesperson number.
004400080923   //
004500080923   //    //  The call back interval is added to the last date called to determin
004600080923   //    //  next date to call.  Since null values may be stored in the last dat
004700080923   //    // indicator variables are used.
004800210330         EXEC SQL
004900210330              SELECT  PHNLDC + PHNCIT DAYS
005000210330                   ,  PHNLDC
005100210330                   ,  CSTPHN
005200210330                   ,  PHNCOM
005300210330                   ,  CSTSLN
005400210330                INTO :NEXTCDATE :INDNEXTCDATE
005500210330                   , :PHNLDC    :INDLASTCDATE
005600210330                   , :CSTPHN
005700210330                   , :PHNCOM
005800210330                   , :CSTSLN
005900210330              FROM    BCI433LIB/CONTACTS20
006000210330              WHERE   CSTNUM = :CSTNUM;
006100190314
006200210330              SELECT;
006300210330                 WHEN SQLSTATE = '00000';
006400210330                    DUMMY      = 0;
006500210330                 WHEN SQLSTATE = '02000';
006600210330                    CSTPHN     = 'Not Found';
006700210330                    NEXTCDATE  = D'9999-09-09';
006701210330                    PHNLDC     = D'9999-09-09';
006702210330                    PHNCOM     = *ALL'*';
006703210330                    CSTSLN     = *ALL'*';
006704210330                 WHEN %SUBST(SQLSTATE :1 : 2) = '01';
006705210330                    CSTPHN     = *ALL'*';
006706210330                    NEXTCDATE  = D'9999-09-09';
006708210330                    PHNLDC     = D'9999-09-09';
006709210330                    PHNCOM     = *ALL'*';
006710210330                    CSTSLN     = *ALL'*';
006711210330                 OTHER;
006712210330                    CSTPHN     = *ALL'*';
006713210330                    NEXTCDATE  = D'9999-09-09';
006714210330                    PHNLDC     = D'9999-09-09';
006715210330                    PHNCOM     = *ALL'*';
006716210330                    CSTSLN     = *ALL'*';
006717210330              ENDSL;
006718210330
006719210330              // HANDLE NULL INDICATOR
006720210330              IF INDLASTCDATE = -1;
006721210330                 CSTPHN    = 'UNKNOWN DATE';
006722210330                 NEXTCDATE = D'9999-09-09';
006723210330                 PHNLDC    = D'9999-09-09';
006724210330              ELSE;
006725210330                 IF INDLASTCDATE <> 0;
006726210330                    CSTPHN = 'DATE PROBLEM';
006727210330                    NEXTCDATE = D'9999-09-09';
006728210330                    PHNLDC    = D'9999-09-09';
006729210330                 ENDIF;
006730210330              ENDIF;
006800190314
006900080923                         ENDSR ;
007000080923        //**********************************************************************
007100080923        // S U M M A R Y I N F O   S U B R O U T I N E
007200080923        //**********************************************************************
007300080923                         BEGSR  SummaryInfo;
007400200709        //  D E T E R M I N E   T O T A L S   F O R   CONTACTS20 & CUSTOMER20
007500210330         EXEC SQL
007600210330              SELECT  COUNT(*)
007700210330                INTO :CONTACTT
007800210330              FROM    BCI433LIB/CONTACTS20;
007900190314
008000210330         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
008100210330             CONTACTT = -99999;
008200210330         ENDIF;
008900190314
008901210330         EXEC SQL
008902210330              SELECT  COUNT(*)
008903210330                INTO :CUSTOMERT
008904210330              FROM    BCI433LIB/CUSTOMER20;
008905210330
008906210330         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
008907210330             CUSTOMERT = -99999;
008908210330         ENDIF;
008909210330
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED
009100210330        EXEC SQL
009200210330             SELECT  COUNT(*)
009300210330               INTO :UNKNOWNT
009400210330             FROM    BCI433LIB/CONTACTS20
009500210330             WHERE   CstLastCallDate IS NULL;
009600190314
009700210330         IF (SQLCODE <> 0 ) OR (SQLWN0 = 'W');
009800210330            UNKNOWNT = -99999;
009900210330         ENDIF;
010000190314
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T
010200210330        EXEC SQL
010300210330             SELECT  MIN(PHNLDC)
010400210330               INTO :OLDESTDATE
010500210330             FROM    BCI433LIB/CONTACTS20;
010600190314
010700210330        IF ( SQLCODE <> 0 ) OR (SQLWN0 = 'W') AND
010800210330           ( SQLWN2 <> 'W');
010801210330           OLDESTDATE = D'9999-09-09';
010802210330        ENDIF;
010900190314
011000210330        // MOSTRECENT
011001210330        EXEC SQL
011002210330             SELECT  MAX(PHNLDC)
011003210330               INTO :MOSTRECENT
011004210330             FROM    BCI433LIB/CONTACTS20;
011005210330
011006210330        IF ( SQLCODE <> 0 ) OR (SQLWN0 = 'W') AND
011007210330           ( SQLWN2 <> 'W');
011008210330           MOSTRECENT = D'9999-09-09';
011009210330        ENDIF;
012000190314
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A
012200210330       EXEC SQL
012300210330            SELECT  USER
012400210330                 ,  CURRENT TIMESTAMP
012500210330                 ,  CURRENT SERVER
012600210330              INTO :USER
012601210330                 , :TIMESTAMP
012602210330                 , :SERVER
012603210330             FROM   SYSIBM/SYSDUMMY1;
012700190314
012800080923                         ENDSR;
