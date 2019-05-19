include clone-prog.mk

# DOESN'T SEEM TO BE REPRODUCIBLE
# Curl Bug #4 -- Security Vulnerability
# Patch applied here: https://github.com/curl/curl/commit/d530e92f59ae9bb2d47066c3c460b25d2ffeb211

# leave this first.
CURL_BUG_4 = e97679a360dda4ea6188b09a145f73a2a84acedd
CURL_PATCH_4 = d530e92f59ae9bb2d47066c3c460b25d2ffeb211

CURL_BUGGY_INPUT_4 = www.gdsfjewnfpqnojodfsdfoggsgjoiaemfqoinfyibdsuabuicnsianuidfhihqowufhqownfqowufnqowfnqowfnqwoufnqouwnfoqwnfoqwnfqqnwfnqowfnqwuofnoqwnfoquwnfoqwnfqowfnfdsaclcdsadcasdfsadfegwwqweqwfqwsce.com 

curl-buggy-4: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_BUG_4); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-buggy-4-obj; \
	make -j8; \
	make install;

curl-patched-4: clone-curl
	cd ${CLONE_DIR}/curl; \
	git checkout $(CURL_PATCH_4); \
	./buildconf; \
	./configure --enable-debug --prefix=${INSTALL_DIR}/curl-patched-4-obj; \
	make -j8; \
	make install;

curl-buggy-4-exe-exist: 
	test -s ${INSTALL_DIR}/curl-buggy-4-obj/bin/curl || { echo "ERROR: curl-buggy-4 doesn't exist"; exit 1; } 

curl-patched-4-exe-exist:
	test -s ${INSTALL_DIR}/curl-patched-4-obj/bin/curl || { echo "ERROR: curl-patched-4 doesn't exist"; exit 1; } 

test-curl-buggy-4: curl-buggy-4-exe-exist
	${INSTALL_DIR}/curl-buggy-4-obj/bin/curl $(CURL_BUGGY_INPUT_4) 2> ${EXTRA_FILE_DIR}/curl-4-a 

test-curl-patched-4: curl-patched-4-exe-exist
	${INSTALL_DIR}/curl-patched-4-obj/bin/curl $(CURL_BUGGY_INPUT_4) 2> ${EXTRA_FILE_DIR}/curl-4-b

clean-curl-buggy-4:
	rm -rf ${INSTALL_DIR}/curl-buggy-4-obj
clean-curl-patched-4:
	rm -rf ${INSTALL_DIR}/curl-patched-4-obj

