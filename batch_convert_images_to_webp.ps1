param(
	[string]$quality = "80",
	[switch]$recursive = $false
)



function Convert{
	
	param (
		$extension
	)
	
	
	if($recursive){
		$files = Get-ChildItem "*.$extension" -Recurse
	}
	else
	{
		$files = Get-ChildItem "*.$extension"
	}
	
		
	foreach ($file in $files){
		$new_filename = $file.FullName.Replace(".$extension", ".webp")
		# magick seems to work better in some cases where cwebp just freezes
		echo "Converting $file as $new_filename"
		magick.exe "$file" -monitor -quality $quality "$new_filename"
	}
	
}

Convert "png"
Convert "jpg"
Convert "jpeg"
