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
002100             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002100             // SQL COMMUNICATION AREA                                                //SQL               
002100             DCL-DS SQLCA;                                                            //SQL               
002100               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002100                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002100               SQLCABC INT(10);                                                       //SQL               
002100                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002100               SQLCODE INT(10);                                                       //SQL               
002100                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002100               SQLERRML INT(5);                                                       //SQL               
002100                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002100               SQLERRMC CHAR(70);                                                     //SQL               
002100                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002100               SQLERRP CHAR(8);                                                       //SQL               
002100                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002100               SQLERR CHAR(24);                                                       //SQL               
002100                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002100               SQLWRN CHAR(11);                                                       //SQL               
002100                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002100               SQLSTATE CHAR(5);                                                      //SQL               
002100                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002100             END-DS SQLCA;                                                            //SQL               
002100             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002100               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002100             END-PR SQLROUTE_CALL;                                                    //SQL               
002100             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLOPEN_CALL;                                                     //SQL               
002100             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCLSE_CALL;                                                     //SQL               
002100             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCMIT_CALL;                                                     //SQL               
002100             /RESTORE CCSID(*CHAR)                                                                        
002100             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002100             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002100             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002100             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002100             DCL-C SQFRD CONST(2);                                                    //SQL               
002100             DCL-C SQFCRT CONST(8);                                                   //SQL               
002100             DCL-C SQFOVR CONST(16);                                                  //SQL               
002100             DCL-C SQFAPP CONST(32);                                                  //SQL               
006000           D                 DS                                                       SELECT              
006000           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
006000           D  SQL_00001              3      4B 0 INZ(1)                               statement number    
006000           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
006000           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
006000           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
006000           D  SQL_00005            129    131P 0                                      CSTNUM              
006000           D  SQL_00006            132    139D   DATFMT(*MDY/)                        NEXTCDATE           
006000           D  SQL_00008            140    147D   DATFMT(*MDY/)                        PHNLDC              
006000           D  SQL_00010            148    162A   CCSID(*JOBRUNMIX)                    CSTPHN              
006000           D  SQL_00011            163    189A   VARYING CCSID(*JOBRUNMIX)            PHNCOM              
006000           D  SQL_00012            190    192A   CCSID(*JOBRUNMIX)                    CSTSLN              
006000           D  SQL_00007            193    194B 0                                      INDNEXTCDATE        
006000           D  SQL_00009            195    196B 0                                      INDLASTCDATE        
007800           D                 DS                                                       SELECT              
007800           D  SQL_00013              1      2B 0 INZ(128)                             length of header    
007800           D  SQL_00014              3      4B 0 INZ(2)                               statement number    
007800           D  SQL_00015              5      8U 0 INZ(0)                               invocation mark     
007800           D  SQL_00016              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
007800           D  SQL_00017             10    128A   CCSID(*JOBRUNMIX)                    end of header       
007800           D  SQL_00018            129    131P 0                                      CONTACTT            
008904           D                 DS                                                       SELECT              
008904           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
008904           D  SQL_00020              3      4B 0 INZ(3)                               statement number    
008904           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
008904           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
008904           D  SQL_00023             10    128A   CCSID(*JOBRUNMIX)                    end of header       
008904           D  SQL_00024            129    131P 0                                      CUSTOMERT           
009500           D                 DS                                                       SELECT              
009500           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
009500           D  SQL_00026              3      4B 0 INZ(4)                               statement number    
009500           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
009500           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009500           D  SQL_00029             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009500           D  SQL_00030            129    131P 0                                      UNKNOWNT            
010500           D                 DS                                                       SELECT              
010500           D  SQL_00031              1      2B 0 INZ(128)                             length of header    
010500           D  SQL_00032              3      4B 0 INZ(5)                               statement number    
010500           D  SQL_00033              5      8U 0 INZ(0)                               invocation mark     
010500           D  SQL_00034              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010500           D  SQL_00035             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010500           D  SQL_00036            129    136D   DATFMT(*MDY/)                        OLDESTDATE          
011004           D                 DS                                                       SELECT              
011004           D  SQL_00037              1      2B 0 INZ(128)                             length of header    
011004           D  SQL_00038              3      4B 0 INZ(6)                               statement number    
011004           D  SQL_00039              5      8U 0 INZ(0)                               invocation mark     
011004           D  SQL_00040              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011004           D  SQL_00041             10    128A   CCSID(*JOBRUNMIX)                    end of header       
011004           D  SQL_00042            129    136D   DATFMT(*MDY/)                        MOSTRECENT          
012603           D                 DS                                                       SELECT              
012603           D  SQL_00043              1      2B 0 INZ(128)                             length of header    
012603           D  SQL_00044              3      4B 0 INZ(7)                               statement number    
012603           D  SQL_00045              5      8U 0 INZ(0)                               invocation mark     
012603           D  SQL_00046              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
012603           D  SQL_00047             10    128A   CCSID(*JOBRUNMIX)                    end of header       
012603           D  SQL_00048            129    138A   CCSID(*JOBRUNMIX)                    USER                
012603           D  SQL_00049            139    164Z                                        TIMESTAMP           
012603           D  SQL_00050            165    174A   CCSID(*JOBRUNMIX)                    SERVER              
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
004800210330       //*  EXEC SQL                                                                                
004900210330       //*       SELECT  PHNLDC + PHNCIT DAYS                                                       
005000210330       //*            ,  PHNLDC                                                                     
005100210330       //*            ,  CSTPHN                                                                     
005200210330       //*            ,  PHNCOM                                                                     
005300210330       //*            ,  CSTSLN                                                                     
005400210330       //*         INTO :NEXTCDATE :INDNEXTCDATE                                                    
005500210330       //*            , :PHNLDC    :INDLASTCDATE                                                    
005600210330       //*            , :CSTPHN                                                                     
005700210330       //*            , :PHNCOM                                                                     
005800210330       //*            , :CSTSLN                                                                     
005900210330       //*       FROM    BCI433LIB/CONTACTS20                                                       
006000210330       //*       WHERE   CSTNUM = :CSTNUM;                                                          
006000                SQL_00005 = CSTNUM;                                                   //SQL               
006000                SQLER6 = -4;                                                          //SQL 1             
006000                SQLROUTE_CALL(                                                        //SQL               
006000                     SQLCA                                                            //SQL               
006000                   : SQL_00000                                                        //SQL               
006000                );                                                                    //SQL               
006000                IF SQL_00003 = '1';                                                   //SQL               
006000                IF SQL_00007 >= 0;                                                    //SQL               
006000                EVAL NEXTCDATE = SQL_00006;                                           //SQL               
006000                ENDIF;                                                                //SQL               
006000                EVAL INDNEXTCDATE = SQL_00007;                                        //SQL               
006000                IF SQL_00009 >= 0;                                                    //SQL               
006000                EVAL PHNLDC = SQL_00008;                                              //SQL               
006000                ENDIF;                                                                //SQL               
006000                EVAL INDLASTCDATE = SQL_00009;                                        //SQL               
006000                EVAL CSTPHN = SQL_00010;                                              //SQL               
006000                EVAL PHNCOM = SQL_00011;                                              //SQL               
006000                EVAL CSTSLN = SQL_00012;                                              //SQL               
006000                ENDIF;                                                                //SQL               
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
007500210330       //*  EXEC SQL                                                                                
007600210330       //*       SELECT  COUNT(*)                                                                   
007700210330       //*         INTO :CONTACTT                                                                   
007800210330       //*       FROM    BCI433LIB/CONTACTS20;                                                      
007800                SQLER6 = -4;                                                          //SQL 2             
007800                SQLROUTE_CALL(                                                        //SQL               
007800                     SQLCA                                                            //SQL               
007800                   : SQL_00013                                                        //SQL               
007800                );                                                                    //SQL               
007800                IF SQL_00016 = '1';                                                   //SQL               
007800                EVAL CONTACTT = SQL_00018;                                            //SQL               
007800                ENDIF;                                                                //SQL               
007900190314                                                                                                    
008000210330         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                                       
008100210330             CONTACTT = -99999;                                                                     
008200210330         ENDIF;                                                                                     
008900190314                                                                                                    
008901210330       //*  EXEC SQL                                                                                
008902210330       //*       SELECT  COUNT(*)                                                                   
008903210330       //*         INTO :CUSTOMERT                                                                  
008904210330       //*       FROM    BCI433LIB/CUSTOMER20;                                                      
008904                SQLER6 = -4;                                                          //SQL 3             
008904                SQLROUTE_CALL(                                                        //SQL               
008904                     SQLCA                                                            //SQL               
008904                   : SQL_00019                                                        //SQL               
008904                );                                                                    //SQL               
008904                IF SQL_00022 = '1';                                                   //SQL               
008904                EVAL CUSTOMERT = SQL_00024;                                           //SQL               
008904                ENDIF;                                                                //SQL               
008905210330                                                                                                    
008906210330         IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                                       
008907210330             CUSTOMERT = -99999;                                                                    
008908210330         ENDIF;                                                                                     
008909210330                                                                                                    
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED               
009100210330       //* EXEC SQL                                                                                 
009200210330       //*      SELECT  COUNT(*)                                                                    
009300210330       //*        INTO :UNKNOWNT                                                                    
009400210330       //*      FROM    BCI433LIB/CONTACTS20                                                        
009500210330       //*      WHERE   CstLastCallDate IS NULL;                                                    
009500                SQLER6 = -4;                                                          //SQL 4             
009500                SQLROUTE_CALL(                                                        //SQL               
009500                     SQLCA                                                            //SQL               
009500                   : SQL_00025                                                        //SQL               
009500                );                                                                    //SQL               
009500                IF SQL_00028 = '1';                                                   //SQL               
009500                EVAL UNKNOWNT = SQL_00030;                                            //SQL               
009500                ENDIF;                                                                //SQL               
009600190314                                                                                                    
009700210330         IF (SQLCODE <> 0 ) OR (SQLWN0 = 'W');                                                      
009800210330            UNKNOWNT = -99999;                                                                      
009900210330         ENDIF;                                                                                     
010000190314                                                                                                    
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T                     
010200210330       //* EXEC SQL                                                                                 
010300210330       //*      SELECT  MIN(PHNLDC)                                                                 
010400210330       //*        INTO :OLDESTDATE                                                                  
010500210330       //*      FROM    BCI433LIB/CONTACTS20;                                                       
010500                SQLER6 = -4;                                                          //SQL 5             
010500                SQLROUTE_CALL(                                                        //SQL               
010500                     SQLCA                                                            //SQL               
010500                   : SQL_00031                                                        //SQL               
010500                );                                                                    //SQL               
010500                IF SQL_00034 = '1';                                                   //SQL               
010500                EVAL OLDESTDATE = SQL_00036;                                          //SQL               
010500                ENDIF;                                                                //SQL               
010600190314                                                                                                    
010700210330        IF ( SQLCODE <> 0 ) OR (SQLWN0 = 'W') AND                                                   
010800210330           ( SQLWN2 <> 'W');                                                                        
010801210330           OLDESTDATE = D'9999-09-09';                                                              
010802210330        ENDIF;                                                                                      
010900190314                                                                                                    
011000210330        // MOSTRECENT                                                                               
011001210330       //* EXEC SQL                                                                                 
011002210330       //*      SELECT  MAX(PHNLDC)                                                                 
011003210330       //*        INTO :MOSTRECENT                                                                  
011004210330       //*      FROM    BCI433LIB/CONTACTS20;                                                       
011004                SQLER6 = -4;                                                          //SQL 6             
011004                SQLROUTE_CALL(                                                        //SQL               
011004                     SQLCA                                                            //SQL               
011004                   : SQL_00037                                                        //SQL               
011004                );                                                                    //SQL               
011004                IF SQL_00040 = '1';                                                   //SQL               
011004                EVAL MOSTRECENT = SQL_00042;                                          //SQL               
011004                ENDIF;                                                                //SQL               
011005210330                                                                                                    
011006210330        IF ( SQLCODE <> 0 ) OR (SQLWN0 = 'W') AND                                                   
011007210330           ( SQLWN2 <> 'W');                                                                        
011008210330           MOSTRECENT = D'9999-09-09';                                                              
011009210330        ENDIF;                                                                                      
012000190314                                                                                                    
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A                     
012200210330       //*EXEC SQL                                                                                  
012300210330       //*     SELECT  USER                                                                         
012400210330       //*          ,  CURRENT TIMESTAMP                                                            
012500210330       //*          ,  CURRENT SERVER                                                               
012600210330       //*       INTO :USER                                                                         
012601210330       //*          , :TIMESTAMP                                                                    
012602210330       //*          , :SERVER                                                                       
012603210330       //*      FROM   SYSIBM/SYSDUMMY1;                                                            
012603                SQLER6 = -4;                                                          //SQL 7             
012603                SQLROUTE_CALL(                                                        //SQL               
012603                     SQLCA                                                            //SQL               
012603                   : SQL_00043                                                        //SQL               
012603                );                                                                    //SQL               
012603                IF SQL_00046 = '1';                                                   //SQL               
012603                EVAL USER = SQL_00048;                                                //SQL               
012603                EVAL TIMESTAMP = SQL_00049;                                           //SQL               
012603                EVAL SERVER = SQL_00050;                                              //SQL               
012603                ENDIF;                                                                //SQL               
012700190314                                                                                                    
012800080923                         ENDSR;                                                                     
