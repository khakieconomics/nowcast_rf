
# The function takes two data sets, both of class zoo. The x dataset is the one you want to nowcast, and the y is the matrix of predictors. The frequency of y will be higher (more frequent) than x. The series should be in changes (for trending variables), or either levels or differences (for stationary or stationary-ish variables like unemployment or interest rates)
rfnowcast <- function(x, y, ntree = 500, frequency = c("quarterly", "monthly"), impute.variable = "WA_SFD"){
	require(randomForest); require(zoo); require(Quandl)
	# First, we need to make sure that when we merge x and y, the indices match. For zoo objects, the easiest way to do this is to turn the frequencies into yearmon or yearqrt
	
	if(frequency=="quarterly"){
		index(x) <- as.yearqtr(index(x))
	} else {
		index(x) <- as.yearmon(index(x))
	}
	
	if(frequency=="quarterly"){
		index(y) <- as.yearqtr(index(y))
	} else {
		index(y) <- as.yearmon(index(y))
	}
	
	x <- diff(log(x))
	y <- diff(log(y))
	y <- window(y, start=index(x)[1])
	xy <- as.data.frame(merge(x, y))
	form <- as.formula(paste(impute.variable, "~."))
	imputed.values <- rfImpute(form, ntree = ntree, n.iter = 10, data = xy)
	imputed.values
	
}
