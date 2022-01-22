# BazelCppApp 

BazelCppApp is a sample C++ app using bazel in dockers environment.

## Startup development environment

* Make sure that project path is shared with docker engine otherwise docker container won't be able to see project files. Docker: Preferences > Resources > File Sharing.
* Run vscode task `'Startup Docker Container'` or run command `make docker_run_it_build`

## Build application
Run vscode task `'Build (In Docker)'` or run command `'make docker_it_build_app'`

## Debug the application
Run vscode task `'Run debug (Docker)'`

## Run the application
Run vscode task `'Run app (Docker)'` or run command `'make docker_it_run_app'`