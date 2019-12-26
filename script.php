<?php
function set_resolv($name){

exec('dig srv +short @192.168.125.14 '.$name, $return);
foreach ($return as $key => $row)
{
	$row = str_replace(".consul.",".consul", $row);
	$arr = explode (" ", $row);
	$return[$key]=$arr[3].":".$arr[2];
}



return $return;

}

$lines = file($argv[1]);
$upstreams = file($argv[2]);

$mass_array=[];
$mass_appstream=[];
$mass_appstream_d=[];

foreach($upstreams as $num => $row) {
 $arr[$num] = explode("|", $row);


 $mass_appstream_i[$num] = explode(";", $arr[$num][1]);

 foreach($mass_appstream_i[$num] as $key => $row){

  if (stripos($row,".query")){
		$row = str_replace(".query", ".query.consul", $row);
		$mass_appstream_d[$arr[$num][0]] = set_resolv($row);
	}
  
 }

}



foreach ($lines as $line_num => $line) {
 $arr[$line_num] = explode("|",$line);    
 $arr_mass = explode(" ",$arr[$line_num][0]);
 $arr[$line_num][1] = explode(";", $arr[$line_num][1]);

$mass_arr[$line_num]['location']=str_replace("location ","",$arr[$line_num][0]);
 $arr[$line_num]['proxy_pass'] = explode ("http://", $arr[$line_num][1][0]); 
 foreach ($arr[$line_num]['proxy_pass'] as $row){
	#if (!$row!="proxy_pass"){
	if (!stripos($row,"proxy_pass")){
		#$mass_arr[$line_num]["proxy_pass"]=$row;


		$row = preg_replace('/\r\n|\r|\n/u', '', $row);


		$mass_arr[$line_num]["upstream_name"] = $row;
		@$mass_arr[$line_num]["servers"] = $mass_appstream_d[$row];
	}
 }
foreach ($arr[$line_num][1] as $row){
	if (stripos($row, "allow")){
		$row = str_replace(" allow ","",$row);
    $mass_arr[$line_num]["allow"][]=$row;
  }
 }
 
 
 //$arr[$line_num]['allow'] = explode (" ", $arr[$line_num][1][1]); 
}

//print_r($mass_appstream['wmcasino']);

//print_r($mass_arr);
print_r($mass_arr);


//print_r($arr[44]);
//print_r(set_resolv('http-stage.mobilots.query.consul'))
?>
