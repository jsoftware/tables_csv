NB. =========================================================
NB. Utils for csv

NB. ---------------------------------------------------------
NB. extcsv v adds '.csv' extension if none present
extcsv=: , #&'.csv' @ (0: = '.'"_ e. (# | i:&PATHSEP_j_) }. ])
