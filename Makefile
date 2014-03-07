.PHONY: test
test:
	shellcheck bootstrap.sh
	checkbashisms bootstrap.sh

