# Certificate files

# Create a private CA for testing
test-ca.crt:
	openssl genrsa -out test-ca.key 4096
	openssl req -new -x509 -key test-ca.key -out test-ca.crt \
	-subj "/C=US/ST=MA/L=Boston/O=${USER}"

host-%.crt: test-ca.crt
	HOST=$(shell echo $@ | perl -n -e 'print $$1 if (m/host-(.*)\.crt/);')
	BASE=$(basename $@)
	openssl req -noenc -newkey rsa:4096 -keyout $$BASE.key -out $$BASE.csr \
	    -subj "/C=US/ST=MA/L=Boston/O=${USER}/CN=$$HOST" \
	    -addext "subjectAltName = DNS:$$HOST"
	openssl x509 -req \
	    -in $$BASE.csr \
	    -CA test-ca.crt \
	    -CAkey test-ca.key \
	    -CAcreateserial \
	    -out $$BASE.crt \
	    -copy_extensions copy