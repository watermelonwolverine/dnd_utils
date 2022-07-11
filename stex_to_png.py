import os
import sys
import re


def process_directoy(path_to_directory: str):
    for root, subDirs, files in os.walk(path_to_directory):
        for file in files:
            process_file(root, file)
        for subDir in subDirs:
            process_directoy(os.path.join(root, subDir.title()))



def process_file(path_to_dir: str, file_name: str):

    if not file_name.endswith(".stex"):
        return

    new_file_name: str = re.sub("png-.*\\.stex", "png", file_name)

    path_to_file: str = os.path.join(path_to_dir, file_name)

    source_file = open(path_to_file, "rb")

    read_bytes = source_file.read()

    write_bytes = read_bytes[32:]

    path_to_target_file = os.path.join(path_to_dir, new_file_name)

    target_file = open(path_to_target_file, "wb")

    target_file.write(write_bytes)

    source_file.close()

    target_file.close()


process_directoy(".")
