
# The function takes two data sets, both of class zoo. The x dataset is the one you want to nowcast, and the y is the matrix of predictors. The frequency of y will be higher (more frequent) than x. Importantly, all series must be in levels (although we are trying to nowcast changes)
function(x, y, ntree = 500, frequency = c("quarterly", "monthly")){
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
	
	
}



