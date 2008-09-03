NB. built from project: ~Addons/tables/csv/csv
NB. =========================================================
NB. read/write comma-separated value data (*.csv) files
NB. supports user-specified field and string delimiters.

script_z_ '~system/main/files.ijs'
script_z_ '~system/main/strings.ijs'

coclass 'pcsv'


script_z_ '~addons/text/delimited/delimited.ijs'
coinsert 'pdelim'

NB. =========================================================
NB. Utils for csv

NB. ---------------------------------------------------------
NB. extcsv v adds '.csv' extension if none present
extcsv=: , #&'.csv' @ (0: = '.'"_ e. (# | i:&PATHSEP_j_) }. ])


NB. =========================================================
NB. Converting from csv files/strings to J array

NB. ---------------------------------------------------------
NB.*chopcsv v Convert csv string to list of boxed strings
NB. form: chopcsv string
NB. returns: list of boxed literals
NB. y is: csv delimited string
NB. eg: chopcsv '"hello world",4,84.3'
chopcsv=: (',';'""')&chopstr

NB. ---------------------------------------------------------
NB.*fixcsv v Convert csv data into J array
NB. form: fixcsv dat
NB. returns: array of boxed literals
NB. y is: csv delimited string, rows delimited by LF
NB. eg: fixcsv '"hello world",4,84.3',LF,'"Big dig","hello world",4',LF
fixcsv=: (',';'""')&fixstr

NB. ---------------------------------------------------------
NB.*readcsv v Reads csv file into a boxed array
NB. form: [fd[;sd0[,sd1]]] readcsv file
NB. returns: array of boxed literals
NB. y is: filename of file to read from
NB. x is: a literal or 1- or 2-item boxed list of optional delimiters.
NB.       0{:: single literal field delimiter (fd). Defaults to ','
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. eg: ('|';'<>') readcsv jpath '~temp/test.csv'
readcsv=: 3 : 0
  (',';'""') readcsv y
  :
  x=. 2{.!.(<'""') boxopen x
  dat=. freads extcsv y
  if. dat -: _1 do. return. end.
  x fixstr dat
)


NB. =========================================================
NB. Converting from J array to csv files/strings

NB. ---------------------------------------------------------
NB.*appendcsv v Appends an array to a csv file
NB. form: dat appendcsv file[;fd[;sd0[,sd1]]]
NB. returns: number of bytes appended or _1 if unsuccessful
NB. y is: literal list or a 2 or 3-item list of boxed literals
NB.       0{ filename of file to append dat to
NB.       1{ optional field delimiter. Default is ','
NB.       2{ optional string delimiters, sd0 & sd1. Defaults are '""'
NB. x is: a J array
NB. eg: (3 2$'hello world';4;84.3;'Big dig') appendcsv (jpath '~temp/test.csv');'|';'<>'
appendcsv=: 4 : 0
  args=. boxopen y
  'fln fd sd'=. args,(#args)}.'';',';'""'
  dat=. (fd;sd) makecsv x
  dat fappends extcsv fln
)

NB. ---------------------------------------------------------
NB.*makecsv v Makes a CSV string from an array
NB. returns: CSV string
NB. form: [fd[;sd0[,sd1]]] makecsv array
NB. y is: an array
NB. x is: literal(s), or 1 or 2-item boxed list of optional delimiters.
NB.       0{:: literal field delimiter(s) (fd). Defaults to ','
NB.   (1;0){:: (start) string delimiter (sd0). Defaults to '"'
NB.   (1;1){:: end string delimiter (sd1). Defaults to '"'
NB. Arrays are flattened to a max rank of 2.
NB. eg: ('|';'<>') makecsv  3 2$'hello world';4;84.3;'Big dig'
makecsv=: 3 : 0
  (',';'""') makecsv y
  :
  dat=. y=. ,/^:(0>. _2+ [:#$) y NB. flatten to max rank 2
  dat=. y=. ,:^:(2<. 2- [:#$) y NB. raise to min rank 2
  'fd sd'=. 2{.!.(<'""') boxopen x
  if. 1=#sd do. sd=. 2#sd end.
  NB. delim=. ',';',"';'",';'","';'';'"';'"'
  delim=. fd ; (fd,}:sd) ; ((}.sd),fd) ; ((}.sd),fd,}:sd) ; '' ; (}:sd) ; }.sd
  
  NB. choose best method for column datatypes
  try. type=. ischar 3!:0@:>"1 |: dat
    if. ({.!.a: sd) e. ;(<a:;I. type){dat do. assert.0 end. NB. sd in field
    if. -. +./ type do. NB. all columns numeric
      dat=. 8!:0 dat
      delim=. 0{ delim
    else. NB. columns either numeric or literal
      idx=. I. -. type
      if. #idx do. NB. format numeric cols
        dat=. (8!:0 tmp{dat) (tmp=. <a:;idx)}dat
      elseif. 0=L.dat do. NB. y is literal array
        dat=. ,each 8!:2 each dat
      end.
      dlmidx=. 2#.\ type  NB. type of each column pair
      dlmidx=. _1|.dlmidx, 4&+@(2 1&*) ({:,{.) type
      delim=. (#dat)# ,: dlmidx { delim
    end.
  catch.  NB. handle mixed-type columns
    dat=. sd quotearray dat
    delim=. 0{ delim
  end.
  NB. make an expansion vector to open space between cols
  d=. 0= 4!:0 <'dlmidx' NB. are there char cols that need quoting
  c=. 0>. (+:d)+ <:+: {:$dat NB. total num columns incl delims
  b=. c $d=0 1 NB. insert empty odd cols if d, else even
  dat=. b #^:_1"1 dat  NB. expand dat
  if. #idx=. I.-.b do.
    dat=. delim (<a:;idx)}dat  NB. amend with delims
  end.
  ;,dat,.(1=#$dat){LF;a: NB. add EOL if dat not empty & vectorise
)

NB. ---------------------------------------------------------
NB.*writecsv v Writes an array to a csv file
NB. form: dat writecsv file[;fd[;sd0[,sd1]]]
NB. returns: number of bytes written (_1 if write error)
NB. y is: literal list or a 2 or 3-item list of boxed literals
NB.       0{ filename of file to append dat to
NB.       1{ optional field delimiter. Default is ','
NB.       2{ optional string delimiters, sd0 & sd1. Defaults are '""'
NB. x is: an array
NB. eg: (i.2 3 4) writecsv (jpath ~temp/test);'|';'{}'
NB. An existing file will be written over.
writecsv=: 4 : 0
  args=. boxopen y
  'fln fd sd'=. args,(#args)}.'';',';'""'
  dat=. (fd;sd) makecsv x
  dat fwrites extcsv fln
)


NB. =========================================================
NB. Verbs exported to z locale

appendcsv_z_=:appendcsv_pcsv_
chopcsv_z_=:chopcsv_pcsv_
fixcsv_z_=:fixcsv_pcsv_
makecsv_z_=:makecsv_pcsv_
readcsv_z_=:readcsv_pcsv_
writecsv_z_=:writecsv_pcsv_

