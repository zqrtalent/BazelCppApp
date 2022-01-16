# ############################################################
# # Variables
# # Application name
# app=bazelcppapp
# # Application version
# version=1.0
# # Docker build image name with tag.
# interractive_build_image=bazel-interactive-build:1.2
#  # Docker build image file path.
# interractive_build_dockerfile=docker/Dockerfile-interactive-build

# # Container remote host/ip
# docker_host=localhost
# # Docker map path of the workspace directory.
# docker_workspace_path=/source
# # SSH port of the docker container
# local_ssh_port=2222
# # SSH key password
# ssh_key_pass=
# # SSH keys directory path
# ssh_path=.ssh
# # SSH RSA private key path
# ssh_key_file=$(ssh_path)/$(app)_build_container_rsa
# # SSH RSA public key path
# ssh_key_file_pub=$(ssh_path)/$(app)_build_container_rsa.pub
# ##########################################################

# Bazel docker interractive build image.
build_bazel_docker_image:
	docker build -f $(interractive_build_dockerfile) -t $(interractive_build_image) --rm=true .

# Run interractive build container.
docker_run_it_build:
	sh ./docker/image-build.sh $(interractive_build_image) $(interractive_build_dockerfile)
	$(eval CURRENT_PATH=$(shell sh -c "echo $$PWD")) \
	(docker stop $(app)-$(version) || echo "skip stop container") && \
	(docker rm $(app)-$(version) || echo "skip remove container") && \
	docker run --name $(app)-$(version) -d -p $(local_ssh_port):22 -v $(CURRENT_PATH):$(docker_workspace_path) -i $(interractive_build_image)
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

.PHONY:  docker_run_it_build 