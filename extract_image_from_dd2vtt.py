import base64
import json
import os
import sys


def get_new_path(path_to_file: str):
    real_path_to_file = os.path.realpath(path_to_file)
    path_to_directory, filename = os.path.split(real_path_to_file)
    filename_splits = filename.split(".")
    if len(filename_splits) > 1:
        filename_splits[-1] = "png"
    else:
        filename_splits.append("png")

    new_filename = ".".join(filename_splits)
    new_path = os.path.join(path_to_directory, new_filename)
    return new_path


def extract_image(path_to_file: str):
    with open(path_to_file, "rt", encoding="UTF-8") as file_handle:
        json_dict = json.load(file_handle)

    image_base64_str = json_dict["image"]

    image_bytes = base64.b64decode(image_base64_str)

    path_to_png_file = get_new_path(path_to_file)

    if os.path.exists(path_to_png_file):
        raise Exception(F"{path_to_png_file} already exists")

    with open(path_to_png_file, "wb+") as file_handle:
        file_handle.write(image_bytes)


def main():
    if len(sys.argv) != 2:
        raise Exception("Wrong number of arguments. Are you missing a target file?")

    path_to_file = sys.argv[1]

    extract_image(path_to_file)


if __name__ == "__main__":
    main()


