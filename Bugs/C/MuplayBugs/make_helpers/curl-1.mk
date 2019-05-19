## This is the makefile that handles all of curl bulids 
include clone-prog.mk

.PHONY: clean-curl-buggy-1 clean-curl-patched-1 record-curl-buggy-1 muplay-buggy-1 test-curl-buggy-1 test-curl-patched-1

# Bug 1

CURL_BUG_1 = 4258dc02d86e7e4de9f795a1af3a0bc6732d4ab5

CURL_PATCH_1 = d8607da1a68f2482302ccdbb7cf457210b9ccfc9

# TODO find an input that triggers this bug
CURL_BUGGY_INPUT_1 = [0:0:0:0:0:0:0:1]: #simply pings local host

curl-buggy-1: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_BUG_1); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-1-obj; \
	make -j8; \
	make install;

curl-patched-1: clone-curl 
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_PATCH_1); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-1-obj; \
	make -j8; \
	make install;

curl-buggy-1-exe-exist: 
	test -s ${INSTALL_DIR}/curl-buggy-1-obj/bin/curl || { echo "ERROR: curl-buggy-1 doesn't exist"; exit 1; } 

curl-patched-1-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-1-obj/bin/curl || { echo "ERROR: curl-patched-1 doesn't exist"; exit 1; } 


test-curl-buggy-1: curl-buggy-1-exe-exist
# MAKE SURE FILE EXISTS
	${INSTALL_DIR}/curl-buggy-1-obj/bin/curl $(CURL_BUGGY_INPUT_1)
# TODO Add check for bad url here

test-curl-patched-1: curl-patched-1-exe-exist
	${INSTALL_DIR}/curl-patched-1-obj/bin/curl $(CURL_BUGGY_INPUT_1)
# add check for successful request here

curl-buggy-1-patchfile: 
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
	cd ${CLONE_DIR}/curl; \
	git diff ${CURL_BUG_1} ${CURL_PATCH_1} > ${PATCH_FILE_DIR}/curl-bug-1.patch


record-curl-buggy-1: curl-buggy-1-exe-exist
	_RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-1 \
    ${RR} record ${INSTALL_DIR}/curl-buggy-1-obj/bin/curl $(CURL_BUGGY_INPUT_1)

muplay-curl-buggy-1: curl-buggy-1-exe-exist curl-patched-1-exe-exist
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-1/curl-0 ${BUILD_DIR}/curl-buggy-1-obj ${BUILD_DIR}/curl-patched-1-obj
    
clean-curl-buggy-1:
	rm -rf ${INSTALL_DIR}/curl-buggy-1-obj
clean-curl-patched-1:
	rm -rf ${INSTALL_DIR}/curl-patched-1-obj

