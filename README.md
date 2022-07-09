# About

Collection of scripts and tools for working with D&D content, especially maps.

# extract_overhead_tile.ps1

## Setup

1. Install ImageMagick ([https://imagemagick.org/](https://imagemagick.org/)) and add it to your PATH environment variable.
2. Download the file or clone the repository
3. Either use the script from where you downloaded it or put the script into a folder that is in your PATH environment variable.

## Usage

    extract_overhead_tile.ps1 overhead_map.jpg ground_map.jpg result.png

IMPORTANT: Use png for the output and convert to jpg or webp afterwards.

## Manual Adjustments

A fully automatic approach will most likely never deliver perfect results so don't expect perfection.

To allow manual adjustments I added the switches

    [switch]$stop_after_comparing,
    [switch]$stop_after_closing,
    [switch]$stop_after_opening,
    [switch]$skip_to_masking,
    [switch]$skip_to_closing,
    [switch]$skip_to_opening

With these switches you can can pause and pick up at any point so you can do any number of manual adjustments to the mask in between (IMPORTANT: The mask will be overwritten by the result of the next step so make a backup before you continue).

## Tweaking

Using the `stop_after_*` switches together with the tweaking parameters

    [string]$fuzz="2%",
    [string]$closing_kernel="Disk:1",
    [string]$opening_kernel="Disk:1",
    [int]$closing_iterations=1,
    [int]$opening_iterations=1,
    [int]$close_area_threshold=20,
    [int]$open_area_threshold=20,
	
to tweak the output after each step.

## Steps

### 1. Comparing

Compares the two images and highlights the differences in red. If too much is highlighted red increase the `-fuzz` (default 2%) parameter.

Use the `-stop_after_comparing` switch to look at the result after this step.

### 2. Closing

Tries to remove the red speckles. If after this step there are still too many speckles left increase:

- `-close_area_threshold` (default 20)
- `-closing_iterations` (default 1)
- `-closing_kernel` (default: Disk:1) to something like Disk:1.5 or Disk:2

Use the `-stop_after_closing` switch to look at the result after this step.

Use the `-skip_to_closing` switch to pick up before this step.

### 3. Opening

Tries to remove white speckles and holes. If after this step there are still too many white holes or speckles left increase:

- `-opening_area_threshold` (default 20)
- `-opening_iterations` (default 1)
- `-opening_kernel` (default: Disk:1) to something like Disk:1.5 or Disk:2

Use the `-stop_after_opening` switch to look at the result after this step.

Use the `-skip_to_opening` switch to pick up before this step.

### 4. Masking

The mask generated up to this point is used to mask the original image.

Use the `-skip_to_masking` switch to pick up before this step.

## Examples

For very high quality images something like this could already deliver a good result:

    extract_overhead_tile.ps1 .\grassfields.jpg '.\grassfields no trees.jpg' -fuzz 1.5% -open_area_threshold 10 .\out.png

For very low quality images with a lot of jpeg compression (jpeg artifacts are often the biggest problem) something like this might be needed:

    extract_overhead_tile.ps1 .\grassfields.jpg '.\grassfields no trees.jpg' -fuzz 4% -closing_kernel Disk:1.5 -closing_iterations 2 -opening_kernel Disk:2 -opening_iterations 2 -open_area_threshold 40 .\out.png

You will probably want to tweak the parameters for a while and then use some image editing software to do some manual adjustments. To do so use:

    extract_overhead_tile.ps1 overhead_map.jpg ground_map.jpg result.png -stop_after_opening

to stop before masking and later use

    extract_overhead_tile.ps1 overhead_map.jpg ground_map.jpg result.png -skip_to_masking
	
to continue before masking.

IMPORTANT: result.png (the mask you edited) will be overwritten here so keep a copy of it if you want to use it again.

# Further Reading

Here you can find the possible kernels and also an explanation of what opening and closing is: [https://legacy.imagemagick.org/Usage/morphology/](https://legacy.imagemagick.org/Usage/morphology/)

