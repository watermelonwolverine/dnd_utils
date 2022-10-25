# very useful for batch converting lots of audioless videos. Usually reduces filesize by 50-90%
param(
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
		$new_filename = $file.FullName.Replace(".$extension", "_vp9.webm")
		ffmpeg.exe -i "$file" -vcodec vp9 -an -crf 38 -n "$new_filename"
	}
	
}

Convert "mp4"
