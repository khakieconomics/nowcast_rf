# testing, using WA GSP

# Pull iron ore prices (USD)
#Quandl.auth('') # Use your own Quandl key (free registration on quandl.com)

Iron.ore.p <- Quandl("INDEXMUNDI/COMMODITY_IRONORE", type = "zoo")
# Pull CPI, WA final demand, Australian metal ore mining exports, WA's unemployment rate, and the dependent variable (%d in WA chain volume GSP)
Perth.CPI <- read.zoo("Perth_CPI.csv", header = TRUE, format = "%d-%m-%Y", sep = ",")
Mining.exports <- read.zoo("Mining_exports.csv", header = TRUE, format = "%d-%m-%Y", sep = ";")
# Mining exports is actually two series; the first uses ANZSIC 1993 classifications, the other uses 2006 classifications. Both seem to be very close in the over-lap period, and the difference seems to be fairly constant, so I continue the first with the second at the break point. The difference is not material. 
WA.GSP <- read.zoo("WA_gsp.csv", header = TRUE, format = "%d-%m-%Y", sep = ",")
WA.UR <- read.zoo("WA_UR.csv", header = TRUE, format = "%d-%m-%Y", sep = ",")
WA.SFD <- read.zoo("WA_SFD.csv", header = TRUE, format = "%d-%m-%Y", sep = ",")

# Adjust the indices
index(Iron.ore.p) <- as.yearqtr(index(Iron.ore.p))
index(Perth.CPI) <- as.yearqtr(index(Perth.CPI))
Mining.exports <- aggregate(Mining.exports, by=as.yearqtr, sum)
index(WA.SFD) <- as.yearqtr(index(WA.SFD))
WA.UR <- aggregate(WA.UR, by = as.yearqtr, mean)

# Plug joint hem all up
exog.vars <- merge( Perth.CPI, Mining.exports, WA.SFD, WA.UR)
# drop the last observation (no state final demand)
exog.vars <- exog.vars[-length(index(exog.vars)),]
end.var <- WA.GSP

# Run the model
WA.impute <- rfnowcast(x = end.var, y = exog.vars, frequency = "quarterly", impute.variable = "WA_SFD", ntree = 1000)


# Back out rough quarterly growth rates from annualised quarterly growth rates

WA.GSP.index <- rep(NA, nrow(WA.impute)+4)
WA.GSP.index[1] <- 100
for(i in 1:3){
	WA.GSP.index[i+1] <- WA.GSP.index[i]*1.005
}
for(i in 5:length(WA.GSP.index)){
	WA.GSP.index[i] <- WA.GSP.index[i-4]*(1+WA.impute$x[i-4])
}
library(mFilter)
WA.qoq.growth <- WA.GSP.index[-1]/WA.GSP.index[-length(WA.GSP.index)]*100-100

# Deseasonalise data and plot
WA.qoq.f <- hpfilter(WA.qoq.growth, freq=4)
plot(WA.qoq.f)

plot.ts((WA.GSP.index))
plot.ts(WA.impute)
plot.ts(WA.qoq.growth)



