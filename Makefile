
test:
	prove ${ARGS} --exec perl6 -r t --ext p6

test-parallel ptest:
	ARGS='-j4' make test
