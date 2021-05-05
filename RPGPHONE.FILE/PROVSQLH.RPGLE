000100190313       //**************************************************************************                 
000200191105       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3                       
000300191105       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED                        
000400191105       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES                 
000500190313       //**************************************************************************                 
000600190313           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;                                                 
000700190313           DCL-S ProvinceH    Char(10);                                                             
000800190313           DCL-S EndOfFile    IND;                                                                  
000900190313           DCL-S TotalRecords PACKED(5:0) ;                                                         
000901210405                                                                                                    
001000210405           // LowLimit is passed to the program                                                     
001100210405           DCL-PI MAIN EXTPGM('PROVSQL');                                                           
001101210405             LOWLIMITIN PACKED(15:5);                                                               
001102210405           END-PI;                                                                                  
001300190315                                                                                                    
001400210405           // All Host Variables available under a single name                                      
001500210405           DCL-DS CUSTOMERRECORD;                                                                   
001600210405                  CUSTID   CHAR(6);                                                                 
001700210405                  FULLNAME CHAR(31);                                                                
001800210405                  CITY     CHAR(20);                                                                
001900210405                  PURCHASE PACKED(7:2);                                                             
002000210405                  PDATE    DATE;                                                                    
002001210405                  PROVINCE CHAR(10);                                                                
002002210405           END-DS CUSTOMERRECORD;                                                                   
002100190315                                                                                                    
002400210405       //**************************************************************************                 
002500210405       //*                        ***   M A I N   R O U T I N E   ***                               
002600210405       //**************************************************************************                 
002601210405                                                                                                    
002601             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002601             // SQL COMMUNICATION AREA                                                //SQL               
002601             DCL-DS SQLCA;                                                            //SQL               
002601               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002601                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002601               SQLCABC INT(10);                                                       //SQL               
002601                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002601               SQLCODE INT(10);                                                       //SQL               
002601                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002601               SQLERRML INT(5);                                                       //SQL               
002601                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002601               SQLERRMC CHAR(70);                                                     //SQL               
002601                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002601               SQLERRP CHAR(8);                                                       //SQL               
002601                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002601               SQLERR CHAR(24);                                                       //SQL               
002601                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002601                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002601               SQLWRN CHAR(11);                                                       //SQL               
002601                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002601                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002601               SQLSTATE CHAR(5);                                                      //SQL               
002601                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002601             END-DS SQLCA;                                                            //SQL               
002601             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002601               CA LIKEDS(SQLCA);                                                      //SQL               
002601               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002601               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002601             END-PR SQLROUTE_CALL;                                                    //SQL               
002601             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002601               CA LIKEDS(SQLCA);                                                      //SQL               
002601               *N BINDEC(4);                                                          //SQL               
002601             END-PR SQLOPEN_CALL;                                                     //SQL               
002601             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002601               CA LIKEDS(SQLCA);                                                      //SQL               
002601               *N BINDEC(4);                                                          //SQL               
002601             END-PR SQLCLSE_CALL;                                                     //SQL               
002601             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002601               CA LIKEDS(SQLCA);                                                      //SQL               
002601               *N BINDEC(4);                                                          //SQL               
002601             END-PR SQLCMIT_CALL;                                                     //SQL               
002601             /RESTORE CCSID(*CHAR)                                                                        
002601             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002601             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002601             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002601             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002601             DCL-C SQFRD CONST(2);                                                    //SQL               
002601             DCL-C SQFCRT CONST(8);                                                   //SQL               
002601             DCL-C SQFOVR CONST(16);                                                  //SQL               
002601             DCL-C SQFAPP CONST(32);                                                  //SQL               
009000           D                 DS                                                       OPEN                
009000           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
009000           D  SQL_00001              3      4B 0 INZ(2)                               statement number    
009000           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
009000           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009000           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009000           D  SQL_00005            129    132P 2                                      LOWLIMIT            
009000           D  SQL_00006            133    136P 2                                      LOWLIMIT            
009000           D  SQL_00007            137    140P 2                                      LOWLIMIT            
010203           D                 DS                                                       FETCH               
010203           D  SQL_00008              1      2B 0 INZ(128)                             length of header    
010203           D  SQL_00009              3      4B 0 INZ(3)                               statement number    
010203           D  SQL_00010              5      8U 0 INZ(0)                               invocation mark     
010203           D  SQL_00011              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010203           D  SQL_00012             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010203           D  SQL_00013            129    134A   CCSID(*JOBRUNMIX)                    CUSTID              
010203           D  SQL_00014            135    165A   CCSID(*JOBRUNMIX)                    FULLNAME            
010203           D  SQL_00015            166    185A   CCSID(*JOBRUNMIX)                    CITY                
010203           D  SQL_00016            186    189P 2                                      PURCHASE            
010203           D  SQL_00017            190    197D   DATFMT(*MDY/)                        PDATE               
010203           D  SQL_00018            198    207A   CCSID(*JOBRUNMIX)                    PROVINCE            
011503           D                 DS                                                       CLOSE               
011503           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
011503           D  SQL_00020              3      4B 0 INZ(4)                               statement number    
011503           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
011503           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011503           D  SQL_00023             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011503           D  SQL_00024            128    128A   CCSID(*JOBRUNMIX)                    end of header       
011514           D                 DS                                                       SELECT              
011514           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
011514           D  SQL_00026              3      4B 0 INZ(5)                               statement number    
011514           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
011514           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011514           D  SQL_00029             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011514           D  SQL_00030            129    132P 2                                      LOWLIMIT            
011514           D  SQL_00031            133    134P 0                                      ONTTOTAL            
011525           D                 DS                                                       SELECT              
011525           D  SQL_00032              1      2B 0 INZ(128)                             length of header    
011525           D  SQL_00033              3      4B 0 INZ(6)                               statement number    
011525           D  SQL_00034              5      8U 0 INZ(0)                               invocation mark     
011525           D  SQL_00035              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011525           D  SQL_00036             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011525           D  SQL_00037            129    132P 2                                      LOWLIMIT            
011525           D  SQL_00038            133    134P 0                                      QUETOTAL            
011536           D                 DS                                                       SELECT              
011536           D  SQL_00039              1      2B 0 INZ(128)                             length of header    
011536           D  SQL_00040              3      4B 0 INZ(7)                               statement number    
011536           D  SQL_00041              5      8U 0 INZ(0)                               invocation mark     
011536           D  SQL_00042              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011536           D  SQL_00043             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011536           D  SQL_00044            129    132P 2                                      LOWLIMIT            
011536           D  SQL_00045            133    134P 0                                      MANTOTAL            
002602210405                LOWLIMIT = LOWLIMITIN;                                                              
002800100309                EXSR PrepareFiles;                                                                  
002801210405                                                                                                    
002900200709                Write ReportHdg;                                                                    
003000200709                Write RColumns;                                                                     
003001210405                                                                                                    
003100100309                EXSR GetRow;                                                                        
003101210405                                                                                                    
003200190313                Write NewProv;                                                                      
003300070209                ProvinceH = Province;                                                               
003301210405                                                                                                    
003400070202                DOW NOT EndOfFile;                                                                  
003500190313                    IF *IN01 = *ON;                                                                 
003600210405                        //Write ReportHdg;                                                          
003700210401                        Write RColumns;                                                             
003800190313                       *IN01 = *OFF;                                                                
003900070209                    ENDIF;                                                                          
004000210405                                                                                                    
004001210405                    // Province may change                                                          
004100210405                    IF ProvinceH = Province;                                                        
004101210405                       WRITE DETAIL;                                                                
004200210405                    ELSE;                                                                           
004300210405                       ProvinceH = Province;                                                        
004400210405                       WRITE TOTALS;                                                                
004500210405                       TOTALPURCH = 0;                                                              
004600210405                       Write NewProv;                                                               
004700210405                       WRITE DETAIL;                                                                
004800210405                    ENDIF;                                                                          
005100190315                                                                                                    
005200210405                    TotalPurch   += Purchase;                                                       
005300210405                    TotalRecords += 1;                                                              
005400100309                    EXSR GetRow;                                                                    
005500070119                ENDDO;                                                                              
005501210405                                                                                                    
005600190313                Write Totals;                                                                       
005700070202                EXSR   WRAPUP;                                                                      
005800190313                Write UnderLimit;                                                                   
005900070119                *INLR = *ON;                                                                        
006000070119                RETURN;                                                                             
006001210405                                                                                                    
006100100309        //**********************************************************************                    
006200100309        // O P E N F I L E S   S U B R O U T I N E                                                  
006300100309        //**********************************************************************                    
006400100309         BEGSR  PrepareFiles;                                                                       
006500190315        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE                         
006600210405       //*  EXEC SQL                                                                                
006700210405       //*       DECLARE ALLPROVCURSOR CURSOR FOR                                                   
006800210405       //*          SELECT  CUSTID                                                                  
006900210405       //*               ,  TRIM(FNAME) || ' ' || LNAME                                             
007000210405       //*               ,  CITY                                                                    
007100210405       //*               ,  PURCHASE                                                                
007200210405       //*               ,  PDATE                                                                   
007300210405       //*               ,  'Ontario' AS PROVINCE                                                   
007400210405       //*          FROM    BCI433LIB/ONTARIO                                                       
007500210405       //*          WHERE   PURCHASE > :LOWLIMIT                                                    
007600190315       //*                                                                                          
007700210405       //*          UNION ALL                                                                       
007800190315       //*                                                                                          
007900210405       //*          SELECT  CUSTID                                                                  
007901210405       //*               ,  TRIM(FNAME) || ' ' || LNAME                                             
007902210405       //*               ,  CITY                                                                    
007903210405       //*               ,  PURCHASE                                                                
007904210405       //*               ,  PDATE                                                                   
007905210405       //*               ,  'Quebec' AS PROVINCE                                                    
007906210405       //*          FROM    BCI433LIB/QUEBEC                                                        
007907210405       //*          WHERE   PURCHASE > :LOWLIMIT                                                    
008000190315       //*                                                                                          
008100210405       //*          UNION ALL                                                                       
008101210405       //*                                                                                          
008102210405       //*          SELECT  CUSTID                                                                  
008103210405       //*               ,  TRIM(FNAME) || ' ' || LNAME                                             
008104210405       //*               ,  CITY                                                                    
008105210405       //*               ,  PURCHASE                                                                
008106210405       //*               ,  PDATE                                                                   
008107210405       //*               ,  'Manitoba' AS PROVINCE                                                  
008108210405       //*          FROM    BCI433LIB/MANITOBA                                                      
008109210405       //*          WHERE   PURCHASE > :LOWLIMIT                                                    
008200210405       //*       FOR READ ONLY;                                                                     
008700190315                                                                                                    
008800100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D                    
008900210405       //* EXEC SQL                                                                                 
009000210405       //*      OPEN ALLPROVCURSOR;                                                                 
009000                SQL_00005 = LOWLIMIT;                                                 //SQL               
009000                SQL_00006 = LOWLIMIT;                                                 //SQL               
009000                SQL_00007 = LOWLIMIT;                                                 //SQL               
009000                SQLER6 = -4;                                                          //SQL               
009000                IF SQL_00002 = 0                                                      //SQL               
009000                OR SQL_00003 <> *LOVAL;                                               //SQL               
009000                SQLROUTE_CALL(                                                        //SQL               
009000                     SQLCA                                                            //SQL               
009000                   : SQL_00000                                                        //SQL               
009000                );                                                                    //SQL               
009000                ELSE;                                                                 //SQL               
009000                SQLOPEN_CALL(                                                         //SQL               
009000                     SQLCA                                                            //SQL               
009000                   : SQL_00000                                                        //SQL               
009000                );                                                                    //SQL               
009000                ENDIF;                                                                //SQL               
009100190315                                                                                                    
009200210405        IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                            
009300210405           EndOfFile = *ON;                                                                         
009400210405        ENDIF;                                                                                      
009500190315                                                                                                    
009600210405        ENDSR;                                                                                      
009700100309        //**********************************************************************                    
009800100309        //   G E T     R O W    S U B R O U T I N E                                                 
009900100309        //**********************************************************************                    
010000210405        BEGSR     GETROW;                                                                           
010100100309                                                                                                    
010200210405       //* EXEC SQL                                                                                 
010201210405       //*      FETCH  NEXT                                                                         
010202210405       //*      FROM   ALLPROVCURSOR                                                                
010203210405       //*      INTO  :CUSTOMERRECORD;                                                              
010203                SQLER6 = -4;                                                          //SQL 3             
010203                SQLROUTE_CALL(                                                        //SQL               
010203                     SQLCA                                                            //SQL               
010203                   : SQL_00008                                                        //SQL               
010203                );                                                                    //SQL               
010203                IF SQL_00011 = '1';                                                   //SQL               
010203                EVAL CUSTID = SQL_00013;                                              //SQL               
010203                EVAL FULLNAME = SQL_00014;                                            //SQL               
010203                EVAL CITY = SQL_00015;                                                //SQL               
010203                EVAL PURCHASE = SQL_00016;                                            //SQL               
010203                EVAL PDATE = SQL_00017;                                               //SQL               
010203                EVAL PROVINCE = SQL_00018;                                            //SQL               
010203                ENDIF;                                                                //SQL               
010300190315                                                                                                    
010400210405        IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                            
010401210405           EndOfFile = *ON;                                                                         
010500210405        ENDIF;                                                                                      
011000190315                                                                                                    
011100210405        ENDSR;                                                                                      
011200100309        //**********************************************************************                    
011300100309        // W R A P U P     S U B R O U T I N E                                                      
011400100309        //**********************************************************************                    
011500210405        BEGSR WRAPUP;                                                                               
011501210405                                                                                                    
011502210405       //* EXEC SQL                                                                                 
011503210405       //*      CLOSE ALLPROVCURSOR;                                                                
011503                SQLER6 = 4;                                                           //SQL               
011503                IF SQL_00021 = 0;                                                     //SQL               
011503                SQLROUTE_CALL(                                                        //SQL               
011503                     SQLCA                                                            //SQL               
011503                   : SQL_00019                                                        //SQL               
011503                );                                                                    //SQL               
011503                ELSE;                                                                 //SQL               
011503                SQLCLSE_CALL(                                                         //SQL               
011503                     SQLCA                                                            //SQL               
011503                   : SQL_00019                                                        //SQL               
011503                );                                                                    //SQL               
011503                ENDIF;                                                                //SQL               
011504210405                                                                                                    
011505210405        IF SQLCODE <> 0 AND SQLWN0 = 'W';                                                           
011506210405           EndOfFile = *ON;                                                                         
011507210405        ENDIF;                                                                                      
011508210405                                                                                                    
011509210405        // GET THE TOTAL FOR ONTARIO                                                                
011510210405       //* EXEC SQL                                                                                 
011511210405       //*      SELECT  COUNT(*)                                                                    
011512210405       //*      INTO   :ONTTOTAL                                                                    
011513210405       //*      FROM    BCI433LIB/ONTARIO                                                           
011514210405       //*      WHERE   PURCHASE <= :LOWLIMIT;                                                      
011514                SQL_00030 = LOWLIMIT;                                                 //SQL               
011514                SQLER6 = -4;                                                          //SQL 5             
011514                SQLROUTE_CALL(                                                        //SQL               
011514                     SQLCA                                                            //SQL               
011514                   : SQL_00025                                                        //SQL               
011514                );                                                                    //SQL               
011514                IF SQL_00028 = '1';                                                   //SQL               
011514                EVAL ONTTOTAL = SQL_00031;                                            //SQL               
011514                ENDIF;                                                                //SQL               
011515210405                                                                                                    
011516210405        IF SQLCODE <> 0  AND  SQLWN0 = 'W';                                                         
011517210405           ONTTOTAL = -999;                                                                         
011518210405        ENDIF;                                                                                      
011519210405                                                                                                    
011520210405        // GET THE TOTAL FOR QUEBEC                                                                 
011521210405       //* EXEC SQL                                                                                 
011522210405       //*      SELECT  COUNT(*)                                                                    
011523210405       //*      INTO   :QUETOTAL                                                                    
011524210405       //*      FROM    BCI433LIB/QUEBEC                                                            
011525210405       //*      WHERE   PURCHASE <= :LOWLIMIT;                                                      
011525                SQL_00037 = LOWLIMIT;                                                 //SQL               
011525                SQLER6 = -4;                                                          //SQL 6             
011525                SQLROUTE_CALL(                                                        //SQL               
011525                     SQLCA                                                            //SQL               
011525                   : SQL_00032                                                        //SQL               
011525                );                                                                    //SQL               
011525                IF SQL_00035 = '1';                                                   //SQL               
011525                EVAL QUETOTAL = SQL_00038;                                            //SQL               
011525                ENDIF;                                                                //SQL               
011526210405                                                                                                    
011527210405        IF SQLCODE <> 0  AND  SQLWN0 = 'W';                                                         
011528210405           QUETOTAL = -999;                                                                         
011529210405        ENDIF;                                                                                      
011530210405                                                                                                    
011531210405        // GET THE TOTAL FOR MANITOBA                                                               
011532210405       //* EXEC SQL                                                                                 
011533210405       //*      SELECT  COUNT(*)                                                                    
011534210405       //*      INTO   :MANTOTAL                                                                    
011535210405       //*      FROM    BCI433LIB/MANITOBA                                                          
011536210405       //*      WHERE   PURCHASE <= :LOWLIMIT;                                                      
011536                SQL_00044 = LOWLIMIT;                                                 //SQL               
011536                SQLER6 = -4;                                                          //SQL 7             
011536                SQLROUTE_CALL(                                                        //SQL               
011536                     SQLCA                                                            //SQL               
011536                   : SQL_00039                                                        //SQL               
011536                );                                                                    //SQL               
011536                IF SQL_00042 = '1';                                                   //SQL               
011536                EVAL MANTOTAL = SQL_00045;                                            //SQL               
011536                ENDIF;                                                                //SQL               
011537210405                                                                                                    
011538210405        IF SQLCODE <> 0  AND  SQLWN0 = 'W';                                                         
011539210405           MANTOTAL = -999;                                                                         
011540210405        ENDIF;                                                                                      
011541210405                                                                                                    
011600210405        ENDSR;                                                                                      
011700190315                                                                                                    
011800190315                                                                                                    
011900190315                                                                                                    
012000190315                                                                                                    
012100190315                                                                                                    
012200190315                                                                                                    
012300190315                                                                                                    
012400190315                                                                                                    
012500190315                                                                                                    
012600190315                                                                                                    
012700190315                                                                                                    
012800190315                                                                                                    
012900190315                                                                                                    
013000190315                                                                                                    
013100190315                                                                                                    
