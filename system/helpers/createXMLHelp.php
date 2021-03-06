<?php
class CreateXMLHelp  extends Model { // Quando você da um extends Model, vc está assumindo que a class está automaticamente pegando  as características da class Model
	function array_to_xml($array, $xml_user_info) {
	    foreach($array as $key => $value) {
	        if(is_array($value)) {
	            if(!is_numeric($key)){
	                $subnode = $xml_user_info->addChild("$key");
	                array_to_xml($value, $subnode);
	            }else{
	                $subnode = $xml_user_info->addChild("item$key");
	                array_to_xml($value, $subnode);
	            }
	        }else {
	            $xml_user_info->addChild("$key",htmlspecialchars("$value"));
	        }
	    }
	}
}
