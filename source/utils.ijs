NB. =========================================================
NB. Utils for csv

NB. ---------------------------------------------------------
stdpathsep=: '/'&(I.@(e.&'/\')@]})
getfnme=: #~ ([: *./\. '/'&~:)

NB. extcsv v adds '.csv' extension if none present
extcsv=: , ('.csv' #~ '.'&e. < 0 < #)@getfnme@stdpathsep
