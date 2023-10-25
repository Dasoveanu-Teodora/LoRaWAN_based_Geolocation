%fu*nction [outputArg1,outputArg2] = pa+------------------th_loss_estimation(inputArg1,inputArg2)


RSSI_0 = -25
d_0 = 1;



%doc = 'G:\My Drive\Path_loss_exp_myht.csv';
%doc = 'G:\My Drive\Path_Loss_03_05.csv';
%doc = 'G:\My Drive\Path_Loss_my_htm_3_05.csv';
doc = 'G:\My Drive\Masuratoare_11.csv';  
wgs84 = wgs84Ellipsoid('meter');

table_data_p = readtable(doc,"Format","auto"); % load data into a table


[masuratori, fields] = size(table_data_p);


for i= 1 : masuratori

     end_dev.lat = table_data_p.Latitude(i);
     end_dev.long = table_data_p.Longitude(i);
     end_dev.altitude = table_data_p.Altitude(i);
      
     gtw.lat = table_data_p.latitude0(i);
     gtw.long = table_data_p.longitude0(i);
     gtw.altitude = table_data_p.altitude0(i);

     dist = distance(end_dev.lat,end_dev.long, gtw.lat, gtw.long,wgs84)
    
     if (dist > 3000)
       dist = 0;
     end 
    
     table_data_p.Distance(i) = dist;
     n = abs(RSSI_0 - table_data_p.rssi0(i)) / (10*log10(dist));
     table_data_p.n(i) = n;
     
    
end


n = mean(nonzeros(table_data_p.n))
fprintf('Path loss exponent: %.2f\n', n);


