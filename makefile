############################################################
# Variables
app = bazelcppapp
version = 1.0
interractive_build_image=bazel-interactive-build:1.2

# Docker container SSH connection
docker_host=localhost
local_ssh_port=2222
ssh_key_pass=
ssh_path=.ssh
ssh_key_file=$(ssh_path)/$(app)_build_container_rsa
ssh_key_file_pub=$(ssh_path)/$(app)_build_container_rsa.pub

package = //src/main
target = $(package):main
path = /src/main
#disable_sandbox = --spawn_strategy=local
build_config_name = clang_config #gcc_config
#Uncomment to use toolchain
#config = --config=$(build_config_name)
##########################################################

build: bazel_build

bazel_build:
	bazel build $(config) $(target) -c dbg --cxxopt=-std=c++2a $(disable_sandbox)

bazel_gen_dsym:
	bazel build $(config) $(package):main_dsym -c dbg --cxxopt=-std=c++2a $(disable_sandbox) --verbose_failures

generate_dbgjson:
	sh ./scripts/gen_compilation_db.sh $(package) $(path)

# Build & run docker images.
build_bazel_image:
	docker build -f docker/Dockerfile-bazel -t bazel-build:1.1 --rm=true .

build_and_run_docker: build_app_image docker_run_app

build_app_image:
	(docker stop $(app)-$(version) || echo "skip stop container") && \
	(docker remove $(app)-$(version) || echo "skip remove container") && \
	(docker image rmi $(app)-build:$(version) || echo "skip remove image") && \
	docker build -f docker/Dockerfile-build -t $(app)-build:$(version) --rm=true .

docker_run_app:
	(docker stop $(app)-$(version) || echo "skip stop container") && \
	(docker rm $(app)-$(version) || echo "skip remove container") && \
	docker run --name $(app)-$(version) -d -i $(app)-build:$(version)

# Bazel docker interractive build image.
build_bazel_docker_image:
	docker build -f docker/Dockerfile-interactive-build -t $(interractive_build_image) --rm=true .

test3:
	$(eval IMAGE_ID=$(shell sh -c "docker images -q mongo:latest"))
	ifeq($(IMAGE_ID),'')
		echo 'hello'
	endif

# Run interractive build container.
docker_run_it_build:
	sh ./docker/image-build.sh $(interractive_build_image) docker/Dockerfile-interactive-build
	$(eval CURRENT_PATH=$(shell sh -c "echo $$PWD")) \
	(docker stop $(app)-$(version) || echo "skip stop container") && \
	(docker rm $(app)-$(version) || echo "skip remove container") && \
	docker run --name $(app)-$(version) -d -p $(local_ssh_port):22 -v $(CURRENT_PATH):/source -i $(interractive_build_image)
	make docker_it_generate_ssh_key
	make docker_it_upload_ssh_key

# Build app in the docker. Execute command in the docker container.
docker_it_build_app:
	docker inspect $(app)-$(version) --format={{.Id}} || make docker_run_it_build
	docker exec -it $(app)-$(version) make build

# Execute command in the interractive build container.
# eg: make docker_it_exec command="make build"
docker_it_exec:
	docker exec -it $(app)-$(version) $(command)

# Generate and store ssh key files
docker_it_generate_ssh_key:
	mkdir -p $(ssh_path) &&\
	rm -f $(ssh_key_file) $(ssh_key_file_pub) &&\
	ssh-keygen -t rsa -f $(ssh_key_file) -m pem -q

# ENTER PASSWORD 'root'
# Check if [$(docker_host)]:$(local_ssh_port)  is listed in the ~/.ssh/known_hosts file otherwise add it!
# Copy/Upload public ssh key file into server
docker_it_upload_ssh_key:
	(ssh-keygen -F [$(docker_host)]:$(local_ssh_port) || (ssh-keyscan -t rsa,rsa,dsa,ecdsa,ed25519 -p $(local_ssh_port) $(docker_host) >> ~/.ssh/known_hosts)) &&\
	ssh-copy-id -i $(ssh_key_file_pub) -p $(local_ssh_port) root@$(docker_host)

# SSH into container.
ssh_it_container:
	ssh -i $(ssh_key_file) -p $(local_ssh_port) root@$(docker_host) 

# Copies bazel output directory into local 'out' directory.
copy_bazel_out_dir:
	$(eval BAZEL_OUT=$(shell sh -c "bazel info output_path")) \
	echo $(BAZEL_OUT) &&\
	mkdir -p out &&\
	cp -R $(BAZEL_OUT)/k8-dbg/* ./out

.PHONY: build build_docker_bazel build_app_image docker_run_app copy_bazel_out_dir