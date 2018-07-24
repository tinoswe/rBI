load_data = function(){

  require(data.table)
  dt = fread("Data/Fake_data.csv",
             sep=";", 
             header=T, 
             stringsAsFactors=TRUE,
             dec=",")

  return(dt)
  
}
