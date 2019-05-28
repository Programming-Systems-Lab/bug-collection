include clone-prog.mk

# Curl Bug #10
# https://github.com/curl/curl/pull/3219
# URL: fix IPv6 numeral address parser

CURL_BUG_10 = 6987e37
CURL_PATCH_10 = b280948
CURL_BUGGY_INPUT_10 = http://[2600::]
OUTPUT_DIR = test-result-curl-10
BUGGY_OUTPUT = buggy_result.txt
PATCHED_OUTPUT = patched_result.txt

curl-buggy-10: clone-curl
	cd ${CLONE_DIR}/curl; \
    git checkout $(CURL_BUG_10); \
    ./buildconf; \
	./configure --without-ssl --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-10-obj; \
	make -j8; \
    make install;

curl-patched-10: clone-curl
	cd ${CLONE_DIR}/curl; \
    git checkout $(CURL_PATCH_10); \
    ./buildconf; \
	./configure --without-ssl --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-10-obj; \
	make -j8; \
    make install;

clear-extra-dir: 
	rm -rf ${EXTRA_FILE_DIR}/${OUTPUT_DIR}

clear-buggy-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${BUGGY_OUTPUT}

clear-patched-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${PATCHED_OUTPUT}

curl-buggy-10-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-10-obj/bin/curl || { echo "ERROR: curl-buggy-10 doesn't exist"; exit 1; } 

curl-patched-10-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-10-obj/bin/curl || { echo "ERROR: curl-patched-10 doesn't exist"; exit 1; } 

curl-buggy-10-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
    cd ${CLONE_DIR}/curl; \
    git diff ${CURL_BUGGY_10} ${CURL_PATCH_10} > ${PATCH_FILE_DIR}/curl-bug-10.patch

test-curl-buggy-10: clear-buggy-test curl-buggy-10-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
    cd ${EXTRA_FILE_DIR}; \
    ${INSTALL_DIR}/curl-buggy-10/bin/curl ${CURL_BUGGY_INPUT_10} > ${OUTPUT_DIR}/${BUGGY_OUTPUT} 
#    vim ../test-result-curl/buggy_result.txt

test-curl-patched-10: clear-patched-test curl-patched-10-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
    cd ${EXTRA_FILE_DIR}; \
    ${INSTALL_DIR}/curl-buggy-10/bin/curl ${CURL_BUGGY_INPUT_10} > ${OUTPUT_DIR}/${PATCHED_OUTPUT}

#        vim ../test-result-curl/fixed_version.txt

record-curl-buggy-10: curl-buggy-10-exe-exist
	cd ${EXTRA_FILE_DIR}; \
    _RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-10 \
    ${RR} record ${INSTALL_DIR}/curl-buggy-10-obj/bin/curl ${CURL_BUGGY_INPUT_10};

muplay-curl-buggy-10: curl-buggy-10-exe-exist curl-patched-10-exe-exist curl-buggy-10-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-10/curl-0 ${BUILD_DIR}/curl-buggy-10-obj ${BUILD_DIR}/curl-patched-10-obj
	
clean-curl-buggy-10:
	rm -rf ${INSTALL_DIR}/curl-buggy-10-obj;

clean-curl-patched-10:
	rm -rf ${INSTALL_DIR}/curl-patched-10-obj;

clean-curl-10:
	rm -rf ${INSTALL_DIR}/curl-buggy-10-obj; \
    rm -rf ${INSTALL_DIR}/curl-patched-10-obj;

