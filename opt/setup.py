import fnmatch
import os
import sys


dir = "/var/www/codiad"

workdir = ""
file_to_edit = ""


if len(sys.argv) == 3:
	workdir = sys.argv[1]
	file_to_edit = sys.argv[2]
	if not os.path.exists(workdir):
		print("[INFO] " + workdir + " not exist! Trying to create...")
		try:
			os.makedirs(workdir)
			print("OK!")
		except Exception as e:
			print("[ERROR] " + str(e))
	if not os.path.exists(file_to_edit):
		print("[INFO] " + file_to_edit + " not exist! Trying to create...")
		try:
			open(file_to_edit, 'w').close()
			print("OK!")
		except Exception as e:
			print("[ERROR] " + str(e))

	workdir = sys.argv[1].replace("/", "\\/")
	file_to_edit = sys.argv[2].replace("/", "\\/")

	# active.php
	try:
		with open(dir + "/data/active.php", "w+") as f:
			content = '''<?php/*|["",{"username":"user","path":"''' + file_to_edit + '''","focused":true}]|*/?>'''
			f.write(content)
			f.close()
		print("[INFO] " + file_to_edit.replace("\\/", "/") + " will be opened in the editor, when your challenge starts!")
	except Exception as e:
		print("[ERROR] " + str(e) + "\n")

	# projects.php
	try:
		with open(dir + "/data/projects.php", "w+") as f:
			content = '''<?php/*|[{"name":"challenge","path":"''' + workdir + '''"}]|*/?>'''
			f.write(content)
			f.close()
		print("[INFO] Workdir 1/2 successfully set to: " + workdir.replace("\\/", "/"))
	except Exception as e:
		print("[ERROR] " + str(e) + "\n")

	# users.php
	try:
		with open(dir + "/data/users.php", "w+") as f:
			content = '''<?php/*|[{"username":"user","password":"fe703d258c7ef5f50b71e06565a65aa07194907f","project":"''' + workdir + '''"}]|*/?>'''
			f.write(content)
			f.close()
		print("[INFO] Workdir 2/2 successfully set to: " + workdir.replace("\\/", "/"))
	except Exception as e:
		print("[ERROR] " + str(e) + "\n")

else:
	print("Usage: python3 setup.py workdir file_to_edit")

