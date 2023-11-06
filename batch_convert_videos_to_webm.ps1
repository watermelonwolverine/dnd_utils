# very useful for batch converting lots of audioless videos. Usually reduces filesize by 50-90%
param(
	[int]$crf = 38,
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
		$new_filename = $file.FullName.Replace(".$extension", ".webm")
		ffmpeg.exe -i "$file" -vcodec vp9 -an -crf $crf -n "$new_filename"
	}
	
}

Convert "mp4"
