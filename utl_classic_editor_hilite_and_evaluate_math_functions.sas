Classic editor hilite and evaluate math functions.

Hilite 2**2+3**3 in SAS editor and hit function-key F11 and 31 will appear log.

see
https://goo.gl/PZrKYW
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=classic&type=&language=

  * two methods;

  INPUT  (in classic editor)

    00001  2**2+3**3

  PROCESS

    Hilite 2**2+3**3  and hit function-key 11

  OUTPUT (in the log)

    result= 31

http://www.lexjansen.com/phuse/2017/ct/CT04.pdf
author Jean-Michel Bodart, Business & Decision Life Sciences, Brussels, Belgium

%clip;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

  Type the following in line 1 of classic editor

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

options cmdmac;

Put the code below in your autocall library.
This code reads tha paste buffer(clipbrd.


%macro clip/cmd des="create macro line with the contents of the clipboard";
 %local rc fileref fid len ;
 %let rc = %sysfunc( filename( fileref, , clipbrd ) );
 %if &rc eq 0 %then %do;
    %let fid = %sysfunc( fopen( &fileref, s, 32767, v) );
    %if &fid ne 0 %then %do;
       %do %while( %sysfunc( fread( &fid ) )=0 );
          %let len = %sysfunc( frlen( &fid ) );
          %let rc = %sysfunc( fget( &fid, line, &len ) );
       %end;
      &line
      %let rc = %sysfunc( fclose( &fid ) );
    %end; %else %do;
      %put failed to open clipboard fileref.;
    %end;
   %let rc = %sysfunc( filename( fileref ) );
 %end;
 %else %do;
    %put %sysfunc( sysmsg( ) );
 %end;
%mend clip;

* put this on function key 11

  F11  store;%put result= %sysevalf(%clip);

  (note the store command only exists in the classic editor
   It was actually removed from EE editor?
   Not available in (EE,EG, UE, SAS studio, On Damand, Viya ...)

Hilite 2**2+3**3  and hit function key 11


*_          _   _                        _       _   _
| |__   ___| |_| |_ ___ _ __   ___  ___ | |_   _| |_(_) ___  _ __
| '_ \ / _ \ __| __/ _ \ '__| / __|/ _ \| | | | | __| |/ _ \| '_ \
| |_) |  __/ |_| ||  __/ |    \__ \ (_) | | |_| | |_| | (_) | | | |
|_.__/ \___|\__|\__\___|_|    |___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

If you have a function like log in the highlited text the solution above will fail.
You would have to add %sysfunc highlite


       2**2+3**3*%sysfunc(log(2))

       result= 22.7149738751183

If you put the two macros below in member 'evl.sas' in your autocall library,
you do not need the sysfunc.


%macro evl / cmd;
   store;note;notesubmit '%evla;';
   run;
%mend evl;

%macro evla;
   %symdel __evl;
   filename clp clipbrd ;
   data _null_;
     infile clp;
     input;
     put _infile_;
     call symputx('__evl',_infile_);
   run;quit;
   data _null_;
     result=&__evl;
     put result=;
   run;quit;
%mend evla;


Now when you highlite  and type 'evl' on the clean classic editor command line(no the wimpy command bar)

      2**2+3**3*log(2)

You get

 result= 22.7149738751183

