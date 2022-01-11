# BazelCppApp 

BazelCppApp is a sample C++ app using bazel in dockers environment.

## Startup development environment

* Make sure that project path is shared with docker engine otherwise docker container won't be able to see project files. Docker: Preferences > Resources > File Sharing.
* Run vscode task `'Startup Docker Container'` or run command `make docker_run_it_build`

## Build application
Run vscode task `'Build (In Docker)'`

## Run application
Run vscode startup task `'Run debug (Docker)'`