#!/bin/sh

echo "Get Docker image digest for ${PLUGIN_BASE_IMAGE}:${PLUGIN_TAG}"

BEARER=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${PLUGIN_BASE_IMAGE}:pull" | cut -d'"' -f4)

SHA=$(curl -s -I -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -H "Authorization: Bearer ${BEARER}" -X GET "https://registry.hub.docker.com/v2/${PLUGIN_BASE_IMAGE}/manifests/${PLUGIN_TAG}" | grep "Docker-Content-Digest" | grep -o "sha256:[0-9a-fA-F]*")

cd eve

grep -H -o -r "${PLUGIN_VARIABLE} sha256:[0-9a-fA-F]*$" * | while read LINE
do
	FILE=`echo $LINE | cut -d":" -f1`
	OLD=`echo $LINE | cut -d" " -f2`

	echo "${FILE} : ${PLUGIN_VARIABLE} : ${OLD} -> ${SHA}"
	sed -i -e "s/${PLUGIN_VARIABLE} sha256:[0-9a-fA-F]*\$/${PLUGIN_VARIABLE} ${SHA}/1" ${FILE}

done
