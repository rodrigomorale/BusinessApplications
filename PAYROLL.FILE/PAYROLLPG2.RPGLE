000100210308**FREE
000101210308// COMAND TO CODE FREE FROM POSITION **FREE
000102210308
000103210308         // READ DATABASE
000104210309         DCL-F SHIFTWEEK USAGE(*INPUT) KEYED RENAME(SHIFTWEEK:SHIFTWEEKR);
000105210309         DCL-F SHIFTRATES DISK USAGE(*INPUT) RENAME(SHIFTRATES:SHIFTRATER);
000106210308
000107210308         // READ SCREEN / FILES
000108210317         DCL-F PAYRPT2        PRINTER OFLIND(*IN01);
000109210317         DCL-F PAYSUMMAR2     WORKSTN;
000110210308
000111210308         // DECLARE STAND ALONE VARIABLE
000112210308         DCL-S HOURSOVER     PACKED(3);
000113210317
000114210317         DCL-PI  MAIN EXTPGM('PAYROLLPG2');
000115210317             		SHIFTTYPE CHAR(30);
000116210317         END-PI;
000117210317
000118210308
000119210308         // POPULATE TITLE AND COLHDG WITH DATABASE DATA
000120210308         READ SHIFTRATES;
000121210308         WRITE TITLE;
000122210308         WRITE COLHDG;
000123210308         READ SHIFTWEEK;
000124210308
000125210308         // LOOP WHILE NOT END OF FILE
000126210308         DOW NOT %EOF;
000127210308             EXSR PAYSR; // CALL SUBROUTINE PAYSR
000128210308
000129210308             IF *IN01;
000130210308                 WRITE TITLE;
000131210308                 WRITE COLHDG;
000132210308                 *IN01 = *OFF;
000133210308             ENDIF;
000134210308
000135210308             WRITE EMPDETAIL;
000136210308             READ SHIFTWEEK;
000137210308         ENDDO;
000138210308
000139210308         // CALCULATE TOTAL VALUE
000140210308         TOTWKPAY = TOTREGPAY + TOTOVTPAY;
000141210308         WRITE TOTALS;
000142210308         EXFMT RECORD1;
000143210308
000144210308         // FINISH PROGRAM
000145210308         *INLR = *ON;
000146210308         RETURN;
000147210308
000148210308         // ***** SUBROUTINES *****
000149210308
000150210308         // CALCULATE PAYMENTS
000151210308         BEGSR PAYSR;
000152210308           // CHOSE HOURLY RATE BASED ON WORKSHIFT
000153210308           SELECT;
000154210309             WHEN  WORKSHIFT  = '1';
000155210308                   HOURLYRATE = DAYHRS;
000156210309             WHEN  WORKSHIFT  = '2';
000157210308                   HOURLYRATE = AFTHRS;
000158210308             OTHER;
000159210308                   HOURLYRATE = NIGHTHRS;
000160210308           ENDSL;
000161210308
000162210308           // AJUST HOURLY RATE TO THE EMPLOYEE PAYCLASS
000163210308           SELECT;
000164210308             WHEN  PAYCLASS = 1;
000165210308                   EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;
000166210308             WHEN  PAYCLASS = 2;
000167210308                   EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;
000168210308             WHEN  PAYCLASS = 3;
000169210308                   EVAL(H) HOURLYRATE = HOURLYRATE * 0.957;
000170210308           ENDSL;
000171210308
000172210309           // CALCULTE ROWS VALUES
000173210308           // CALCULATE OVER HOURS
000174210308           IF HRSWORKED > 40;
000175210309              HOURSOVER  = HRSWORKED - 40;
000176210309              REGULARPAY = HOURLYRATE * 40;
000177210308           ELSE;
000178210309              HOURSOVER  = 0;
000179210309              REGULARPAY = HOURLYRATE * HRSWORKED;
000180210308           ENDIF;
000181210309           OVERPAY    = HOURSOVER * HOURLYRATE * 1.5;
000182210309           WEEKLYPAY  = REGULARPAY + OVERPAY;
000183210309
000184210309           // SUM TO TOTALS
000185210309           TOTREGPAY = TOTREGPAY + REGULARPAY;
000186210309           TOTOVTPAY = TOTOVTPAY + OVERPAY;
000187210308         ENDSR;
000188210308
