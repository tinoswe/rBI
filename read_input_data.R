load_data = function(){

  require(data.table)
  require(lubridate)
  
  dt = fread("Data/Fake_data.csv",
             sep=";", 
             header=T, 
             stringsAsFactors=FALSE,
             dec=",")

  dt$Year <- year(dmy_hm(dt$DateTime))
  dt$Month <- month(dmy_hm(dt$DateTime))
  dt$Day <- day(dmy_hm(dt$DateTime))
  dt$Hour <- hour(dmy_hm(dt$DateTime))
  dt$Minute <- minute(dmy_hm(dt$DateTime))
  dt$DateTime <- dmy_hm(dt$DateTime)
  
  return(dt)
  
}
