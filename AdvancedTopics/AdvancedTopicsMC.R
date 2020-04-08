library(raster)
x<-getData('worldclim',var = 'prec',res = 0.5, lon=39.74,lat=-5.313)
plot(x$tmin1_37)


tzProtect<-read.csv("~/Pemba Project/TanzaniaProtectedAreas.csv")
tzProtect
