#!/bin/sh

BEARER=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${PLUGIN_IMAGE}:pull" | cut -d'"' -f4)

SHA=$(curl -s -I -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -H "Authorization: Bearer ${BEARER}" -X GET "https://registry.hub.docker.com/v2/library/${PLUGIN_IMAGE}/manifests/${PLUGIN_TAG}" | grep "Docker-Content-Digest" | cut -d" " -f2)

cd $pwd/eve

grep -H -o -r "${PLUGIN_VARIABLE} sha256:[0-9a-fA-F]*$" * | while read LINE
do
	FILE=`echo $LINE | cut -d":" -f1`
	OLD=`echo $LINE | cut -d" " -f2`

	echo "${FILE} : ${PLUGIN_VARIABLE} : ${OLD} -> ${SHA}"
	sed -i -e "s/${PLUGIN_VARIABLE} sha256:[0-9a-fA-F]*\$/${PLUGIN_VARIABLE} ${SHA}/1" ${FILE}

done
