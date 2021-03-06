#!/bin/sh

# Sleep 3 minutes, so users can stop it, in case of a problem
sleep 1

while true; do 

setting=0

while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 1 ] ;
    
do     	if [ $setting -eq 0 ]; then

        echo "powersave mode 1 active" > /tmp/powersave
        
        for i in `iw dev | grep Interface | cut -d \  -f 2` ; do 
        
        iw dev $i set power_save on
        setting=1; done ; fi
        
        sleep 12;
        
        done
        
        
while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 2 ] ;
    
do      echo "powersave mode 2 active" > /tmp/powersave
        
        if [ $setting -eq 0 ]; then

	phy=`uci get ffopenmppt.@ffopenmppt[0].powersave_interface`

	echo "Disabled " $phy >>  /tmp/powersave

	uci set wireless.radio$phy.disabled='1'

	wifi 
		
	uci set wireless.radio$phy.disabled='0'	

        setting=1; fi
        
        sleep 12;
        
        done
        


while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 3 ] ;
 
do 	echo "powersave mode 3 active" > /tmp/powersave
		
	stationcount=0 
	for i in `ifconfig | grep wlan | cut -d \  -f 1`; do 
	stations=`iw dev $i station dump  | grep Station | wc -l`
	stationcount="$(( stationcount + stations))"; done

	if [ $stationcount -eq 0 ] ; 

	then echo "No station associated." >> /tmp/powersave  
	echo "wifi down" >> /tmp/powersave
	wifi down
	sleep 120
	/etc/init.d/network restart
	echo "wifi up" >> /tmp/powersave  ; fi

	if  [ $stationcount -ne 0 ] ;
                                    
        then echo "$stationcount station(s) associated." >> /tmp/powersave  ; fi 	

        sleep 120; 
        
        done
        

while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 4 ] ;

do      echo "powersave mode 4 active" > /tmp/powersave

        for i in `ifconfig | grep wlan | cut -d \  -f 1`; do
        stations=`iw dev $i station dump  | grep Station | wc -l`
        stationcount="$(( stationcount + stations))";
	done

        if [ $stationcount -eq 0 ] ;

        then echo "No station associated." >> /tmp/powersave
        echo "wifi down"
        wifi down
        sleep 300                       
        /etc/init.d/network restart
	echo "wifi up" >> /tmp/powersave ; fi
                                     
        if  [ $stationcount -ne 0 ] ;
                                                            
        then echo "$stationcount station(s) associated." >> /tmp/powersave ; fi
                      
        stationcount=0
        
sleep 300;
    
done

while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 5 ] ;

do    	 echo "powersave mode 5 active" > /tmp/powersave
         if [ `date +%H` -eq 00 ]; 
         then wifi down
	 echo "wifi down" >> /tmp/powersave
         sleep 14400
	 /etc/init.d/network restart ; fi
         
         sleep 60;
         
         done

         
while [ `uci get ffopenmppt.@ffopenmppt[0].powersave` -eq 6 ] ;

do    	echo "powersave mode 6 active" > /tmp/powersave
        if [ `date +%H` -eq 00 ]; 
        then echo "P=300" > /dev/`uci get ffopenmppt.@ffopenmppt[0].serial_port`; fi
         
        sleep 90;
         
        done

sleep 60;
done

