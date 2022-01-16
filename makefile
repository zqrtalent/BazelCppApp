############################################################
# VARIABLES
# Docker build & SSH variables (make/docker_build.mk).
# Application name
app=bazelcppapp
# Application version
version=1.0
# Docker build image name with tag.
interractive_build_image=bazel-interactive-build:1.2
 # Docker build image file path.
interractive_build_dockerfile=docker/Dockerfile-interactive-build

# Container remote host/ip
docker_host=localhost
# Docker map path of the workspace directory.
docker_workspace_path=/source
# SSH port of the docker container
local_ssh_port=2222
# SSH key password
ssh_key_pass=
# SSH keys directory path
ssh_path=.ssh
# SSH RSA private key path
ssh_key_file=$(ssh_path)/$(app)_build_container_rsa
# SSH RSA public key path
ssh_key_file_pub=$(ssh_path)/$(app)_build_container_rsa.pub

# Bazel variables (make/bazel.mk).
package=//src/main
target=$(package):main
path=/src/main
#disable_sandbox=--spawn_strategy=local
#Bazel build configuration name. eg: gcc_config
build_config_name=clang_config
#Uncomment to use toolchain
#config=--config=$(build_config_name)
#Bazel compilcation mode. --compilation_mode (fastbuild|opt|dbg) (-c)
compilation_mode=dbg
#Cpp compiler options.
cxxopts=--cxxopt=-std=c++2a
##########################################################

# Targets are declared in this file.
include make/*.mk