BEGIN {highest_packet_id = 0;}
{
 action = $1;
 time = $2;
 node =$3;
 type = $5;
 packet_id =$12;
 if (packet_id > highest_packet_id) {
	highest_packet_id = packet_id;
 }
 
 if (action == "+") {
	send_time[packet_id] = time;
  } else if (action == "r"){
    rcv_time[packet_id] = time;
  }
}

END {
	packet_no = 0; 
	total_delay = 0;
	for (packet_id = 0; packet_id <= highest_packet_id; packet_id++){
	if ((send_time[packet_id]!=0) && (rcv_time[packet_id]!=0)){
		start = send_time[packet_id];
		end = rcv_time[packet_id];
		packet_duration = end-start;
	} else {
		packet_duration = -1;
	}
	if (packet_duration > 0) {
	packet_no++;
	total_delay = total_delay + packet_duration;
	printf("%d %f %f\n", packet_id, total_delay, total_delay/packet_no);
	}
	
	
}
  
}