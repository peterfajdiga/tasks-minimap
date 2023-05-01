PACKAGE_NAME := peterfajdiga.plasma.tasksMinimap

.PHONY: install run package

install:
	kpackagetool5 -i ./package || kpackagetool5 -u ./package

run: install
	plasmoidviewer --applet ${PACKAGE_NAME}

package:
	cd ./package && zip -r - ./* > ../TasksMinimap.plasmoid
