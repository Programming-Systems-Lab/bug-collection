include clone-prog.mk

# Curl Bug #8
# https://github.com/curl/curl/commit/e50a2002bd450a4800a165d2874ed79c95b33a07
# FILE: fix CURLOPT_NOBODY and CURLOPT_HEADER output

CURL_BUG_8 = b55e85d 
CURL_PATCH_8 = e50a200
OUTPUT_DIR = test-result-curl-8
CURL_BUGGY_INPUT_8 = --head file:///usr/share/dict/words 

BUGGY_OUTPUT = buggy_result.txt
PATCHED_OUTPUT = patched_result.txt

curl-buggy-8: clone-curl
	cd ${CLONE_DIR}/curl; \
    git checkout $(CURL_BUG_8); \
    ./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-8-obj; \
	make -j8; \
    make install;

curl-patched-8: clone-curl
	cd ${CLONE_DIR}/curl; \
    git checkout $(CURL_PATCH_8); \
    ./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-8-obj; \
	make -j8; \
    make install;

curl-buggy-8-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-8-obj/bin/curl || { echo "ERROR: curl-buggy-8 doesn't exist"; exit 1; } 

curl-patched-8-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-8-obj/bin/curl || { echo "ERROR: curl-patched-8 doesn't exist"; exit 1; } 

clear-extra-dir:
	rm -rf ${EXTRA_FILE_DIR}/${OUTPUT_DIR}

clear-buggy-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${BUGGY_OUTPUT}

clear-patched-test:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_DIR}/${PATCHED_OUTPUT}


test-curl-buggy-8: clear-buggy-test curl-buggy-8-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
    cd ${EXTRA_FILE_DIR}; \
    ${INSTALL_DIR}/curl-buggy-8-obj/bin/curl ${CURL_BUGGY_INPUT_8} > ${OUTPUT_DIR}/${BUGGY_OUTPUT}; 
	# vim ../test-result-curl/buggy_result.txt

test-curl-patched-8: clear-patched-test curl-patched-8-exe-exist
	mkdir -p ${EXTRA_FILE_DIR}/${OUTPUT_DIR}; \
	cd ${EXTRA_FILE_DIR}; \
    ${INSTALL_DIR}/curl-patched-8-obj/bin/curl ${CURL_BUGGY_INPUT_8} > ${OUTPUT_DIR}/${PATCHED_OUTPUT}; 
	# vim ../test-result-curl/fixed_version.txt

curl-buggy-8-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
	cd ${CLONE_DIR}/curl; \
	git diff ${CURL_BUG_8} ${CURL_PATCH_8} > ${PATCH_FILE_DIR}/curl-bug-8.patch;

record-curl-buggy-8: curl-buggy-8-exe-exist
	cd ${EXTRA_FILE_DIR}; \
    _RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-8 \
    ${RR} record ${INSTALL_DIR}/curl-buggy-8-obj/bin/curl ${CURL_BUGGY_INPUT_8};

muplay-curl-buggy-8: curl-buggy-8-exe-exist curl-patched-8-exe-exist curl-buggy-8-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-8/curl-0 ${BUILD_DIR}/curl-buggy-8-obj ${BUILD_DIR}/curl-patched-8-obj

clean-curl-buggy-8:
	rm -rf ${INSTALL_DIR}/curl-buggy-8-obj;

clean-curl-patched-8:
	rm -rf ${INSTALL_DIR}/curl-patched-8-obj;
