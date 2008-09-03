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
