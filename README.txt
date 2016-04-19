The simplest way to run the system is to execute visual_search_wrapper.m. This script wraps the main function (vs_visual_search) to allow a single test to be run. visual_search_wrapper is set up to perform any test the system is capable of producing.
WARNING. The DESCRIPTOR_BASE_DIRECTORY and OUTPUT_BASE_DIRECTORY folders (at the top of visual_search_wrapper) will be written to, and are libable to have their contents erased.
In order to exectute the system, the IMAGE_DIRECTORY at the top of vs_visual_search.m must be changed to point to the msrc_v2 database image directory.

Other scripts of interest may be:
Testing scripts, located in the 'test' directory. Note these scripts assume that the solution, (and for one of the tests, the lab code), is added to the matlab search path. Testing scripts can be executed individually or all together using MATLAB's runtests command.
Executing runtests in the 'test' directory will execute all tests 

test_pattern_gen/vs_gen_patterns.m generates some funky test patterns you may want to check it out.

You can also generate all of the data used in the report in one shot by running generate_report_data.m
WARNING: This script may take a while! The MAP data in particular takes a long time to calculate (since it compares 2*4*591^2 images)

The solution has been tested on MATLAB r2015b, on Windows 10.
If you have any problems, I may be contacted at jt00176@surrey.ac.uk.