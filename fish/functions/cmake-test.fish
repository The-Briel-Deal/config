function cmake-test --wraps='ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --build-target test_exe --test-command test_exe' --description 'alias cmake-test ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --build-target test_exe --test-command test_exe'
    ctest --build-and-test $(pwd) $(realpath build) --build-generator=Ninja --build-noclean --build-target test_exe --test-command test_exe $argv
end
