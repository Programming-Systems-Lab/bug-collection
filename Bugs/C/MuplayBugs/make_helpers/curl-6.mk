include clone-prog.mk

# Curl Bug #6 -- security vulnerability
# This hasn't been officially incorporated yet but seems like a good small fix
# https://github.com/curl/curl/pull/3433
# Related to CVE-2018-20483, when using --xattr flag, the file system could save 
# the information about user name and password
# Dependency: attr
CURL_BUG_6 = afeb8d99022255279ee63125f2fa0f69810ce9c3 
CURL_PATCH_6 = 98e6629154044e4ab1ee7cff8351c7ebcb131e88
OUTPUT_FILE = curl-buggy-6-file

CURL_BUGGY_INPUT_6 = http://testcurlbug:testcurl123@github.com -o ${OUTPUT_FILE} --xattr

curl-buggy-6: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_BUG_6); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-6-obj; \
	make -j8; \
	make install;

curl-patched-6: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_PATCH_6); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-6-obj; \
	make -j8; \
	make install;

curl-buggy-6-exe-exist:
	test -s ${INSTALL_DIR}/curl-buggy-6-obj/bin/curl || { echo "ERROR: curl-buggy-6 doesn't exist"; exit 1; } 

curl-patched-6-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-6-obj/bin/curl || { echo "ERROR: curl-patched-6 doesn't exist"; exit 1; } 

clear-extra-file:
	rm -f ${EXTRA_FILE_DIR}/${OUTPUT_FILE}

test-curl-buggy-6: clear-extra-file curl-buggy-6-exe-exist
	cd ${EXTRA_FILE_DIR}; \
	${INSTALL_DIR}/curl-buggy-6-obj/bin/curl $(CURL_BUGGY_INPUT_6); \
	getfattr ${OUTPUT_FILE};\
	getfattr -n user.xdg.origin.url ${OUTPUT_FILE} 

curl-buggy-6-patchfile:
	test -s ${CLONE_DIR}/curl || { echo "ERROR: curl repo doesn't exist"; exit 1; }; \
	cd ${CLONE_DIR}/curl; \
	git diff ${CURL_BUG_6} ${CURL_PATCH_6} > ${PATCH_FILE_DIR}/curl-bug-6.patch


test-curl-patched-6: clear-extra-file curl-patched-6-exe-exist
	${INSTALL_DIR}/curl-patched-6-obj/bin/curl $(CURL_BUGGY_INPUT_6); \
	getfattr ${OUTPUT_FILE};\
	getfattr -n user.xdg.origin.url ${OUTPUT_FILE} 

record-curl-buggy-6: clear-extra-file curl-buggy-6-exe-exist 
	cd ${EXTRA_FILE_DIR}; \
	_RR_TRACE_DIR=${_RR_TRACE_DIR}/curl-buggy-6 \
	${RR} record ${INSTALL_DIR}/curl-buggy-6-obj/bin/curl ${CURL_BUGGY_INPUT_6}
	
muplay-curl-buggy-6: clear-extra-file curl-buggy-6-exe-exist curl-patched-6-exe-exist curl-buggy-6-patchfile
	${RR} muplay ${_RR_TRACE_DIR}/curl-buggy-6/curl-0 ${BUILD_DIR}/curl-buggy-6-obj ${BUILD_DIR}/curl-patched-6-obj

clean-curl-buggy-6:
	rm -rf ${INSTALL_DIR}/curl-buggy-6-obj;

clean-curl-patched-6:
	rm -rf ${INSTALL_DIR}/curl-patched-6-obj;
