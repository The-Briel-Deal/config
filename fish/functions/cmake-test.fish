function cmake-test --wraps='ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --test-command tests' --description 'alias cmake-test ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --test-command tests'
    ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --test-command tests $argv
end
