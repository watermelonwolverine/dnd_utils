param(
	[string]$in,
	[string]$out
)

magick $in -fuzz 20% -transparent 'rgb(218,82,193)' $out

magick $out -fill white +opaque none $out

magick $out -morphology Erode Disk:1.5 $out

magick composite $in -compose src-in $out $out