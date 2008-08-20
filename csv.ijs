NB. built from project: ~Addons/tables/csv/csv
NB. read/write comma-separated value data (*.csv) files
NB. supports user-specified field and string delimiters.

script_z_ '~system/main/files.ijs'
script_z_ '~system/main/strings.ijs'

cocurrent 'z'


NB. =========================================================
NB.*appendcsv v Appends an array to a csv file
NB. form: dat appendcsv file[;fd[,sd0[,sd1]]]
NB. returns: number of bytes appended or _1 if unsuccessful
NB. y is: literal or 2-item list of boxed literals
NB.       0{ filename of file to append dat to
NB.       1{ optional delimiters. Default is ',""'
NB.          fd:field delimiter, sd0 & sd1:string delimiters
NB. x is: a J array
appendcsv=: 4 : 0
  'fln delim'=. 2{.!.(<',') boxopen y
  dat=. delim makecsv x
  dat fappends extcsv fln
)

NB. =========================================================
NB. chopcsv v Box delimited fields in string
chopcsv=: 3 : 0
  ',""' chopcsv y
  :
  dat=. y
  assert. (0<#x), 0=L.x
  if. 1=#x do. sd=. '""'
  else. sd=. 2$}.x end.
  fd=. 1{.x
  if. =/sd do. sd=. {.sd
  else. NB. replace diff start and end delims with single
    s=. {.('|'=fd){ '|`'  NB. choose single sd
    dat=. dat rplc ({.sd);s;({:sd);s
    sd=. s
  end.
  dat=. dat,fd
  b=. dat e. fd
  c=. ~:/\dat=sd
  fmsk=. b>c NB. end of fields
  smsk=. sd ([: (> (0: , }:)) =) dat NB. first in group of sds
  smsk=. -. smsk +. (sd,fd) E. dat   NB. or previous to fd
  dat=. smsk#dat  NB. compress out string delims
  fmsk=. smsk#fmsk
  fmsk <;._2 dat  NB. box
)

NB. =========================================================
NB. extcsv v adds '.csv' extension if none present
extcsv=: , #&'.csv' @ (0: = '.'"_ e. (# | i:&PATHSEP_j_) }. ])


NB. =========================================================
NB.*fixcsv v Convert csv data into J array
NB. form: [fd[,sd0[,sd1]]] fixcsv dat
NB. returns: array of boxed literals
NB. y is: delimited string
NB. x is: optional delimiters. Default is ',""'
NB.       0{ field delimiter (fd)
NB.       1{ (start) string delimiter (sd0)
NB.       2{ end string delimiter (sd1)
fixcsv=: 3 : 0
  ',' fixcsv y
  :
  if. 1=#x do. sd=. '""'
  else. sd=. 2$}.x end.
  if. =/sd do.
    x=. x,{.sd
  else.
    s=. {.('|'={.x){ '|`'  NB. choose single sd
    y=. y rplc ({.sd);s;({:sd);s
    x=. x,s
  end.
  b=. y e. LF
  c=. ~:/\y=1{x
  msk=. b > c
  > msk <@(x&chopcsv) ;._2 y
)

NB. =========================================================
NB.*makecsv v Makes a CSV string from an array
NB. returns: CSV string
NB. form: [fd[,sd0[,sd1]]] makecsv array
NB. y is: an array
NB. x is: optional delimiters. Default is ',""'
NB.       0{ is the field delimiter (fd)
NB.       1{ is (start) string delimiter (sd0)
NB.       2{ is end string delimiter (sd1)
NB. Arrays are flattened to a max rank of 2.
makecsv=: 3 : 0
  ',""' makecsv y
  :
  dat=. y=. ,/^:(0>. _2+ [:#$) y NB. flatten to max rank 2
  dat=. y=. ,:^:(2<. 2- [:#$) y NB. raise to min rank 2
  if. 1=#x do. sd=. '""'
  else. sd=. 2$}.x end.
  fd=. {.x
  NB. delim=. ',';',"';'",';'","';'';'"';'"'
  delim=. fd ; (fd,{.sd) ; (({:sd),fd) ; (({:sd),fd,{.sd) ; '' ; ({.sd) ; {:sd
  ischar=. ] e. 2 131072"_
  isreal=. ] e. 1 4 8 64 128"_
  
  NB. choose best method for column datatypes
  try. type=. ischar 3!:0@:>"1 |: dat
    if. ({.sd) e. ;(<a:;I. type){dat do. assert.0 end. NB. sd in field
    if. -. +./ type do. NB. all columns numeric
      dat=. 8!:0 dat NB. ,each 8!:2 each dat
      delim=. 0{ delim
    else. NB. columns either numeric or literal
      idx=. I. -. type
      if. #idx do. NB. format numeric cols
        dat=. (8!:0 tmp{dat) (tmp=. <a:;idx)}dat
      elseif. 0=L.dat do. NB. y is literal array
        dat=. ,each 8!:2 each dat
      end.
      dlmidx=. 2#.\ type
      dlmidx=. _1|.dlmidx, 4&+@(2 1&*) ({:,{.) type
      delim=. (#dat)# ,: dlmidx { delim
    end.
  catch.  NB. handle mixed-type columns
    dat=. ,dat
    t=. #. ((0<#@$) , (isreal,.ischar)@:(3!:0)) &> dat NB. cell data type
    dat=. ((#idx)$sd quote idx{dat)(idx=. I. t e. 1 5)}dat NB. quote char cells
    dat=. (8!:0 idx{dat) (idx=. I. 2=t)}dat    NB. format numeric cells
    dat=. (":@:,@:> &.> idx{dat)(idx=. I. t e. 0 4 6)}dat NB. handle complex, boxed, numeric rank>0
    dat=. ($y)$dat
    delim=. 0{ delim
  end.
  NB. make an expansion vector to open space between cols
  d=. 0= 4!:0 <'dlmidx' NB. are there char cols that need quoting
  c=. 0>. (2*d)+ <:+: {:$dat NB. total num columns incl delims
  b=. c $d=0 1 NB. insert empty odd cols if d, else even
  dat=. b #^:_1"1 dat  NB. expand dat
  if. #idx=. I.-.b do.
    dat=. delim (<a:;idx)}dat  NB. amend with delims
  end.
  ;,dat,.{.(1<#$dat)#<LF NB. add EOL if dat not empty & vectorise
)

NB. =========================================================
NB.*makenum v Converts cells in array of boxed literals to numeric where possible
NB. form: [err] makenum array
NB. returns: numeric array or array of boxed literals and numbers
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
makenum=: 3 : 0
  _9999 makenum y
  :
  dat=. , x&". &.> y=. boxopen y
  idx=. I. x&e.@> dat
  if. #idx do.
    dat=. (idx{,y) idx}dat NB. amend non-numeric cells
  else.
    dat=. >dat NB. unbox to list if all numeric
  end.
  ($y)$dat
)

NB. =========================================================
NB.*makenumcol v Converts columns in table of boxed literals to numeric where possible
NB. form: [err] makenumcol array
NB. returns: numeric array or array of boxed literal and numeric columns
NB. y is: an array of boxed literals
NB. x is: optional numeric error code. Default is _9999
NB. Only converts column to numeric if conversion is possible for whole column
makenumcol=: 3 : 0
  _9999 makenumcol y
  :
  dat=. x&". &.> y=. boxopen y
  notnum=. x&e.@> dat NB. mask of boxes containing error code
  idx=. I. +./notnum  NB. index of non-numeric columns
  if. #idx do.
    dat=. (idx{"1 y) (<a:;idx)}dat NB. amend non-numeric columns
  else.
    dat=. >dat NB. unbox to list if all numeric
  end.
)

NB. =========================================================
NB.*quote v Encloses string in quotes
NB. form: [sd0[,sd1]] quote strng(s)
NB. returns: quoted string
NB. y is: string or boxed strings to quote
NB. x is: optional quote type. Default is ''''''
NB.       0{ is (start) string delimiter (sd0)
NB.       1{ is end string delimiter (sd1)
NB. Internal quotes are doubled if required.
quote=: 3 : 0
  '''''' quote y
  :
  if. 0<L. y do. x&quote &.> y return. end.
  if. -.(#x)e. 0 2 do. x=. 2$x end.
  (}:x),((>: (y e. x) *. =/x)#y),}.x
)

NB. =========================================================
NB.*readcsv v Reads csv file into a boxed array
NB. form: [fd[,sd0[,sd1]]] readcsv file
NB. returns: array of boxed literals
NB. y is: filename of file to read from
NB. x is: optional delimiters. Default is ',""'
NB.       0{ field delimiter (fd)
NB.       1{ (start) string delimiter (sd0)
NB.       2{ end string delimiter (sd1)
readcsv=: 3 : 0
  ',' readcsv y
  :
  dat=. freads extcsv y
  if. dat -: _1 do. return. end.
  x fixcsv dat
)

NB. =========================================================
NB.*writecsv v Writes an array to a csv file
NB. form: dat writecsv file[;fd[,sd0[,sd1]]]
NB. returns: number of bytes written (_1 if write error)
NB. y is: literal or 2-item list of boxed literals
NB.       0{ filename of file to write dat to
NB.       1{ optional delimiters. Default is ',""'
NB.          fd:field delimiter, sd0 & sd1:string delimiters
NB. x is: an array
NB. eg: (i.2 3 4) writecsv (jpath ~temp/test);';{}'
NB. An existing file will be written over.
writecsv=: 4 : 0
  'fln delim'=. 2{.!.(<',') boxopen y
  dat=. delim makecsv x
  dat fwrites extcsv fln
)


