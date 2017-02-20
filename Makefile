
test:
	prove ${ARGS} --exec perl6 -r t --ext p6

test-parallel:
	ARGS='-j4' make test
