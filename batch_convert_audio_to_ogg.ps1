param(
	[string]$quality = "196k",
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
		$new_filename = $file.FullName.Replace(".$extension", ".ogg")
		echo "Converting $file as $new_filename"
		ffmpeg.exe -i "$file" -b:a $quality "$new_filename"
	}
	
}

Convert "mp3"
