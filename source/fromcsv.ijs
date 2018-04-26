NB. =========================================================
NB. Converting from csv files/strings to J array

NB. ---------------------------------------------------------
NB.*chopcsv v Convert csv string to list of boxed strings
NB. returns: list of boxed literals
NB. form: chopcsv string
NB. eg: chopcsv '"hello world",4,84.3'
NB. y is: csv delimited string
chopcsv=: (',';'""')&chopstring

NB. ---------------------------------------------------------
NB.*fixcsv v Convert csv data into J array
NB. returns: array of boxed literals
NB. form: fixcsv dat
NB. eg: fixcsv '"hello world",4,84.3',LF,'"Big dig","hello world",4',LF
NB. y is: csv delimited string, rows delimited by LF
fixcsv=: (',';'""')&fixdsv

NB. ---------------------------------------------------------
NB.*readcsv v Reads csv file into a boxed array
NB. returns: array of boxed literals
NB. form: readcsv file
NB. eg: readcsv jpath '~temp/test.csv'
NB. y is: filename of file to read from
readcsv=: (',';'""')&readdsv@extcsv
