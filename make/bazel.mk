# ############################################################
# # VARIABLES
# package=//src/main
# target=$(package):main
# path=/src/main
# #disable_sandbox=--spawn_strategy=local
# #Bazel build configuration name. eg: gcc_config
# build_config_name=clang_config
# #Uncomment to use toolchain
# #config=--config=$(build_config_name)
# #Bazel compilcation mode. --compilation_mode (fastbuild|opt|dbg) (-c)
# compilation_mode=dbg
# #Cpp compiler options.
# cxxopts=--cxxopt=-std=c++2a
# ##########################################################

build: bazel_build

bazel_build:
	bazel build $(config) $(target) -c $(compilation_mode) $(cxxopts) $(disable_sandbox)

bazel_run:
	bazel run $(target) -c $(compilation_mode) $(cxxopts) $(disable_sandbox)

bazel_test:
	bazel test //test:* -c $(compilation_mode) $(cxxopts) $(disable_sandbox)

bazel_gen_dsym:
	bazel build $(config) $(package):main_dsym -c $(compilation_mode) $(cxxopts) $(disable_sandbox) --verbose_failures

generate_dbgjson:
	sh ./scripts/gen_compilation_db.sh $(package) $(path)

# Copies bazel output directory into local 'out' directory.
copy_bazel_out_dir:
	$(eval BAZEL_OUT=$(shell sh -c "bazel info output_path")) \
	echo $(BAZEL_OUT) &&\
	mkdir -p out &&\
	cp -R $(BAZEL_OUT)/k8-$(compilation_mode)/* ./out

.PHONY: build bazel_build bazel_gen_dsym generate_dbgjson copy_bazel_out_dir