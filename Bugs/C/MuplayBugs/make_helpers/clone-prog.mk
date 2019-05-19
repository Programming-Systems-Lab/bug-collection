# gets the source code for the programs as required

include config.mk

.PHONY: clone-curl

#builds the buggy version of curl
CURL_URL =  https://github.com/curl/curl.git

clone-curl: make-dirs
	if [ ! -d "${CLONE_DIR}/curl" ]; \
        then cd ${CLONE_DIR} && git clone $(CURL_URL); \
    fi


