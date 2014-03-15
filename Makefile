.PHONY: test
test:
	shellcheck --exclude SC2088 bootstrap.sh
	checkbashisms bootstrap.sh

