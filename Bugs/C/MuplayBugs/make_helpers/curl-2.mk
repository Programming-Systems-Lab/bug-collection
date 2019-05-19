include clone-prog.mk

.PHONY: clean-curl-buggy-2 clean-curl-patched-2 record-curl-buggy-2 muplay-buggy-2 test-curl-buggy-2 test-curl-patched-2 curl-buggy-2-patchfile

# Curl Bug #2 Works with the following pull request and patch
# PR & Patch https://github.com/curl/curl/pull/3381
# This bug corrects behavior where curl -J will append to the output file instead of creating a new file -- Weak example of type 5 in the design section

CURL_BUG_2 = f097669248a877dece74fdb525e82bfe1b69df90
CURL_PATCH_2 = 4849267197682e69cfa056c2bd7a44acd123a917
CURL_BUGGY_INPUT_2 = -JO --location https://github.com/curl/curl/releases/download/curl-7_63_0/curl-7.63.0.tar.xz.asc
OUTPUT_FILE = "${EXTRA_FILE_DIR}/curl-7.63.0.tar.xz.asc" 
CHECK_SIZE="stat --printf='%s' curl-7.63.0.tar.xz.asc"


curl-buggy-2: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout ${CURL_BUG_2}; \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-2-obj; \
	make -j8; \
	make install;



curl-patched-2: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout ${CURL_PATCH_2}; \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-2-obj; \
	make -j8; \
	make install;

curl-buggy-2-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-2-obj/bin/curl || { echo "ERROR: curl-buggy-2 doesn't exist"; exit 1; } 


curl-patched-2-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-2-obj/bin/curl || { echo "ERROR: curl-patched-2 doesn't exist"; exit 1; } 

clear-output-file:
	rm -f ${OUTPUT_FILE}

test-curl-buggy-2: curl-buggy-2-exe-exist clear-output-file
	cd ${EXTRA_FILE_DIR}; \
	${INSTALL_DIR}/curl-buggy-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}; \
	${INSTALL_DIR}/curl-buggy-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}; \
	stat --printf='%s' ${OUTPUT_FILE}; \
    echo ;

test-curl-patched-2: curl-patched-2-exe-exist clear-output-file
	cd ${EXTRA_FILE_DIR}; \
	${INSTALL_DIR}/curl-patched-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}; \
	${INSTALL_DIR}/curl-patched-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}; \
	stat --printf='%s' ${OUTPUT_FILE}; \
    echo ;


curl-buggy-2-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
	cd ${CLONE_DIR}/curl; \
	git diff ${CURL_BUG_2} ${CURL_PATCH_2} > ${PATCH_FILE_DIR}/curl-bug-2.patch

create-output-file:curl-buggy-2-exe-exist clear-output-file
	${INSTALL_DIR}/curl-buggy-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}    

record-curl-buggy-2: curl-buggy-2-exe-exist create-output-file
	_RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-2 \
	${RR} record ${INSTALL_DIR}/curl-buggy-2-obj/bin/curl ${CURL_BUGGY_INPUT_2}
	
muplay-curl-buggy-2: curl-buggy-2-exe-exist curl-patched-2-exe-exist create-output-file curl-buggy-2-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-2/curl-0 ${BUILD_DIR}/curl-buggy-2-obj ${BUILD_DIR}/curl-patched-2-obj

clean-curl-buggy-2:
	rm -rf ${INSTALL_DIR}/curl-buggy-2-obj
clean-curl-patched-2:
	rm -rf ${INSTALL_DIR}/curl-patched-2-obj
