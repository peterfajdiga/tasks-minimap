.PHONY: *

PACKAGE_NAME := peterfajdiga.plasma.tasksMinimap

install:
	kpackagetool5 -i ./package || kpackagetool5 -u ./package

uninstall:
	kpackagetool5 -r ./package

run: install
	plasmoidviewer --applet ${PACKAGE_NAME}

package:
	cd ./package && zip -r - ./* > ../TasksMinimap.plasmoid
