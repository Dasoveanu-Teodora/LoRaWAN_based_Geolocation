function [ distance] = RSSI2Distance(RSSI,RSSI_0,n_path_loss,d_0)
 distance = d_0 * 10 ^( ( RSSI_0 - RSSI )/(10*n_path_loss))
end