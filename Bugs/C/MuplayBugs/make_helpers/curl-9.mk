include clone-prog.mk

# Curl Bug #9
# https://github.com/curl/curl/commit/2c5ec339ea67f43ac370ae77636a0f915cc5fbeb
# Curl_follow: accept non-supported schemes for "fake" redirects

CURL_BUG_9 = a4653a7
CURL_PATCH_9 = 2c5ec33
CURL_BUGGY_INPUT_9 = -v http://cmake.org 
OUTPUT_DIR = test-result-curl-9
BUGGY_OUTPUT=buggy_result.txt
PATCHED_OUTPUT = patched_result.txt

curl-buggy-9: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_BUG_9); \
	./buildconf; \
	./configure --without-ssl --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-9-obj; \
	make -j8; \
    make install;

curl-patched-9: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_PATCH_9); \
	./buildconf; \
	./configure --without-ssl --enable-debug --prefix=${INSTALL_DIR}/curl-patched-9-obj; \
	make -j8; \
    make install;

curl-buggy-9-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-9-obj/bin/curl || { echo "ERROR: curl-buggy-9 doesn't exist"; exit 1; } 

curl-patched-9-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-9-obj/bin/curl || { echo "ERROR: curl-patched-9 doesn't exist"; exit 1; } 

clear-extra-dir: 
	rm -rf ${EXTRA_FILE_DIR}/${OUTPUT_DIR}

clear-buggy-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${BUGGY_OUTPUT}

clear-patched-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${PATCHED_OUTPUT}

test-curl-buggy-9: clear-buggy-test curl-buggy-9-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
	cd ${EXTRA_FILE_DIR}; \
	${INSTALL_DIR}/curl-buggy-9-obj/bin/curl ${CURL_BUGGY_INPUT_9} >  ${OUTPUT_DIR}/${BUGGY_OUTPUT} 2>&1; 
#	vim ../test-result-curl/buggy_result.txt

test-curl-patched-9: clear-patched-test curl-patched-9-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
    cd ${EXTRA_FILE_DIR}; \
    ${INSTALL_DIR}/curl-patched-9-obj/bin/curl ${CURL_BUGGY_INPUT_9} > ${OUTPUT_DIR}/${PATCHED_OUTPUT};

curl-buggy-9-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
    cd ${CLONE_DIR}/curl; \
    git diff ${CURL_BUGGY_9} ${CURL_PATCH_9} > ${PATCH_FILE_DIR}/curl-bug-9.patch

record-curl-buggy-9: curl-buggy-9-exe-exist
	cd ${EXTRA_FILE_DIR}; \
    _RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-9 \
    ${RR} record ${INSTALL_DIR}/curl-buggy-9-obj/bin/curl ${CURL_BUGGY_INPUT_9};

muplay-curl-buggy-9: curl-buggy-9-exe-exist curl-patched-9-exe-exist curl-buggy-9-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-9/curl-0 ${BUILD_DIR}/curl-buggy-9-obj ${BUILD_DIR}/curl-patched-10-obj


clean-curl-buggy-9:
	rm -rf ${INSTALL_DIR}/curl-buggy-9-obj;

clean-curl-patched-9:
	rm -rf ${INSTALL_DIR}/curl-patched-9-obj;

clean-curl-9:
	rm -rf ${INSTALL_DIR}/curl-buggy-9-obj; \
    rm -rf ${INSTALL_DIR}/curl-patched-9-obj;

