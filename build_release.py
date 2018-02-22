import sys
import os
import zipfile
import subprocess

def parse_gitignore(root_path):
	print("\n  Processing .gitignore")
	current_working_directory = os.getcwd()
	gitignore_path = os.path.join(current_working_directory, ".gitignore")
	if os.path.isfile(gitignore_path):
		gitignore = []
		with open(gitignore_path, "r") as f:
			gitignore = f.readlines()
		folders_to_ignore = []
		files_to_ignore = []
		file_patterns_to_ignore = []
		print("    Reading '%s'" % os.path.relpath(gitignore_path, current_working_directory))
		for line in gitignore:
			line = line.strip()
			path = os.path.join(current_working_directory, line)
			if os.name == "nt":
				path = path.replace("/", "\\")
			else:
				path = path.replace("\\", "/")
			if path.find(root_path):
				print("      Jumping over:", path)
				continue
			if os.path.isdir(path):
				print("      Folder:", line)
				folders_to_ignore.append(path)
			elif os.path.isfile(path):
				print("      File:", line)
				files_to_ignore.append(path)
			elif path.find("*."):
				print("      File pattern:", line)
				file_patterns_to_ignore.append(path)
			else:
				print("      Unsupported:", line)
		print("\n    Folders to ignore")
		for line in folders_to_ignore:
			print("      '%s'" % os.path.relpath(line, current_working_directory))
		print("\n    Files to ignore")
		for line in files_to_ignore:
			print("      '%s'" % os.path.relpath(line, current_working_directory))
		return folders_to_ignore, files_to_ignore, file_patterns_to_ignore
	return None, None, None

def main(root_path, releases_path, version):
	release_name = "Lauhdutin"
	author_name = "Kapiainen"
	print("\nGenerating release: '%s - %s'" % (release_name, version))
	folders_to_ignore, files_to_ignore, file_patterns_to_ignore = parse_gitignore(root_path)
	print("\n  Gathering stuff to include in the release")
	files_to_pack = []
	for root, dirs, files in os.walk(root_path):
		skip = False
		for folder in folders_to_ignore:
			if folder in root:
				skip = True
				break
		if skip:
			print("    Skipping folder:", root)
			continue
		print("    Processing folder:", root)
		for file in files:
			path = os.path.join(root, file)
			if path in files_to_ignore:
				print("      Skipping file: '%s'" % os.path.relpath(path, root_path))
			else:
				skip = False
				for pattern in file_patterns_to_ignore:
					folder_path, extension = pattern.split("*")
					#print(path, folder_path, extension, path.find(folder_path), path.endswith(extension))
					if path.find(folder_path) >= 0 and path.endswith(extension):
						skip = True
						break
				if skip:
					print("      Skipping file based on pattern: '%s'" % os.path.relpath(path, root_path))
				else:
					print("      Adding file: '%s'" % os.path.relpath(path, root_path))
					files_to_pack.append(path)
	print("\n  Files to pack:")
	for file in files_to_pack:
		print("     ", file)

	try: # Check if 'zlib' module is available for 'zipfile.ZipFile' to use for compressing.
		import zlib
		compression_type = zipfile.ZIP_DEFLATED
		print("\n  Using 'zlib' module to generate a compressed archive...")
	except ImportError:
		print("\n  'zlib' module could not be imported!")
		print("  Generating uncompressed archive instead...")
		compression_type = zipfile.ZIP_STORED
	current_working_directory = os.getcwd()
	readme_path = os.path.join(current_working_directory, "Readme.md")
	license_path = os.path.join(current_working_directory, "License.md")
	contributors_path = os.path.join(current_working_directory, "Contributors.md")
	with zipfile.ZipFile(os.path.join(releases_path, "%s - %s" % (release_name, version)) + ".zip", mode="w", compression=compression_type) as release_archive:
		release_archive.write(readme_path, "Readme.md")
		release_archive.write(license_path, "License.md")
		release_archive.write(contributors_path, "Contributors.md")
		for file in files_to_pack:
			release_archive.write(file, os.path.relpath(file, root_path))
	print("\nSuccessfully generated the release!")

root_path = os.path.join(os.getcwd(), "dist")
releases_path = os.path.join(os.getcwd(), "Releases")
if not os.path.isdir(releases_path):
	os.makedirs(releases_path)
translation_updater = subprocess.Popen(["python", os.path.join(os.getcwd(), "update_translations.py")], cwd=os.getcwd())
translation_updater.wait()
if translation_updater.returncode == 0:
	main(root_path, releases_path, "3.0.0")#input("Enter release version: "))
else:
	print("Failed to update the translation file!")
input("\nPress a key to exit...")
