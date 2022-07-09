param(
	[string]$overhead,
	[string]$ground,
	[string]$out,
    [string]$fuzz="2%",
	[string]$closing_kernel="Disk:1",
	[string]$opening_kernel="Disk:1",
	[int]$closing_iterations=1,
	[int]$opening_iterations=1,
	[int]$close_area_threshold=20,
	[int]$open_area_threshold=20,
	[switch]$stop_after_comparing,
	[switch]$stop_after_closing,
	[switch]$stop_after_opening,
	[switch]$skip_to_masking,
	[switch]$skip_to_closing,
	[switch]$skip_to_opening
)


	
function EOT-Compare {
	echo Comparing
	magick.exe compare -fuzz $fuzz $overhead $ground -compose src -highlight-color red -lowlight-color white $out
}

function EOT-Close {
	for($i=0; $i -lt $closing_iterations; $i++){
		echo Closing
		magick.exe $out -morphology Close $closing_kernel $out
	}
}
	
function EOT-Connect {
	
	param(
		[int]$area_threshold
	)
	
	echo Connecting
	
	magick.exe convert $out -define connected-components:area-threshold=$area_threshold -define connected-components:mean-color=true -connected-components 2  $out
}
	
function EOT-Open {
	for($i=0; $i -lt $opening_iterations; $i++){
		echo Opening
		magick.exe $out -morphology Open $opening_kernel $out
	}
}

function EOT-Mask {
	echo Masking
	magick.exe $out -transparent white $out # making the non-red part of the image transparent
	magick.exe composite $overhead -compose src-in $out $out # masking the original image
}

if(!$skip_to_masking){
	if(!$skip_to_opening){
		if(!$skip_to_closing){
			EOT-Compare
			
			if ($stop_after_comparing){
				Exit
			}	
		}
		EOT-Close
		EOT-Connect $close_area_threshold
		
		if ($stop_after_closing){
			Exit
		}	
		
	}
	EOT-Open
	EOT-Connect $open_area_threshold
	
	if ($stop_after_opening){
		Exit
	}
}
EOT-Mask