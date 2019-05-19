include clone-prog.mk

.PHONY: clean-curl-buggy-5 clean-curl-patched-5 record-curl-buggy-5 muplay-buggy-5 test-curl-buggy-5 test-curl-patched-5 curl-buggy-5-patchfile

# Curl Bug #5 -- Security Vulnerability
# Not noted where the patch is applied but test case is given and should exist somewhere in the git history
#CVE-2017-1000101
# info available at: https://curl.haxx.se/docs/CVE-2017-1000101.html
CURL_BUG_5 = 0966b324d911423c81351fb12e9219f71cd63be8  
CURL_PATCH_5 = 5ca96cb84410270e233c92bf1b2583cba40c3fad 

CURL_BUGGY_INPUT_5 = http://ur%20[0-60000000000000000000 

curl-buggy-5: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_BUG_5); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-5-obj; \
	make -j8; \
	make install;

curl-patched-5: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_PATCH_5); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-5-obj; \
	make -j8; \
	make install;

curl-buggy-5-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-5-obj/bin/curl || { echo "ERROR: curl-buggy-5 doesn't exist"; exit 1; } 

curl-patched-5-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-5-obj/bin/curl || { echo "ERROR: curl-buggy-5 doesn't exist"; exit 1; } 

test-curl-buggy-5: curl-buggy-5-exe-exist
	${INSTALL_DIR}/curl-buggy-5-obj/bin/curl ${CURL_BUGGY_INPUT_5} 

test-curl-patched-5: curl-patched-5-exe-exist 
	${INSTALL_DIR}/curl-patched-5-obj/bin/curl ${CURL_BUGGY_INPUT_5} 

curl-buggy-5-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
	cd ${CLONE_DIR}/curl; \
	git diff ${CURL_BUG_5} ${CURL_PATCH_5} > ${PATCH_FILE_DIR}/curl-bug-5.patch

record-curl-buggy-5: curl-buggy-5-exe-exist 
	_RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-5 \
	${RR} record ${INSTALL_DIR}/curl-buggy-5-obj/bin/curl ${CURL_BUGGY_INPUT_5}
	
muplay-curl-buggy-5: curl-buggy-5-exe-exist curl-patched-5-exe-exist curl-buggy-5-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-5/curl-0 ${BUILD_DIR}/curl-buggy-5-obj ${BUILD_DIR}/curl-patched-5-obj

clean-curl-buggy-5:
	rm -rf ${INSTALL_DIR}/curl-buggy-5-obj;

clean-curl-patched-5:
	rm -rf ${INSTALL_DIR}/curl-patched-5-obj;




