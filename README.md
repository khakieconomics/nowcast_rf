nowcast_rf
==========

Nowcasting using random forest missing values interpolation

This is a small program to do low->high frequency conversion with exogenous variables. It's quite primitive at the moment. Simply feed the function some zoo objects, x is the variable you'd like to interpolate, y is potentially many series that have been merged into a single zoo object. y has a higher frequency than x. It can also have missing values. 

There must be one variable in y that is closely related to x, but does not have missing values. In the demo I have attached, I use state final demand to help in filling in the missing values for gross state product. 

I should note that this models log-differences, and assumes that the input variables are in levels. 
