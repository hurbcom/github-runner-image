#!/usr/bin/env bash

export VE_UBUNTU_TAG=${VE_UBUNTU_TAG:-20211219.1}
export DEBIAN_FRONTEND=noninteractive

# Download virtual environment ubuntu 20
wget https://github.com/actions/virtual-environments/archive/refs/tags/ubuntu20/${VE_UBUNTU_TAG}.tar.gz -O - | tar zx
cd virtual-environments-ubuntu20*/

# Set some variables
export BASE_DIR=$(pwd)/images/linux
export HELPER_SCRIPTS=${BASE_DIR}/scripts/helpers
export INSTALLER_SCRIPT_FOLDER=${BASE_DIR}/scripts/installers
export IMAGE_OS=ubuntu20

. /tmp/invoke_tests.sh

function run {
    NAME=$2
    echo "--- Running $1"
    if [ ! -f "$1" ]; then
        return 0
    fi
    sudo sh -c "HELPER_SCRIPTS=${HELPER_SCRIPTS} INSTALLER_SCRIPT_FOLDER=${INSTALLER_SCRIPT_FOLDER} IMAGE_OS=${IMAGE_OS} $1"
}

function run_ps {
    echo "--- Running PowerShell $1"
    if [ ! -f "$1" ]; then
        return 0
    fi
    sudo sh -c "HELPER_SCRIPTS=${HELPER_SCRIPTS} INSTALLER_SCRIPT_FOLDER=${INSTALLER_SCRIPT_FOLDER} IMAGE_OS=${IMAGE_OS} pwsh -f $1"
}

# Enable VE exetutables
chmod -R 777  ${BASE_DIR}

# Run commands
## setup
run ${BASE_DIR}/scripts/base/apt-mock.sh
run ${BASE_DIR}/scripts/base/repos.sh
run ${BASE_DIR}/scripts/installers/configure-environment.sh
run ${BASE_DIR}/scripts/installers/complete-snap-setup.sh

## base
run ${BASE_DIR}/scripts/installers/powershellcore.sh
run_ps ${BASE_DIR}/scripts/installers/Install-PowerShellModules.ps1
run_ps ${BASE_DIR}/scripts/installers/Install-AzureModules.ps1
run ${BASE_DIR}/scripts/installers/docker-compose.sh
run ${BASE_DIR}/scripts/installers/docker-moby.sh

## tools
run ${BASE_DIR}/scripts/installers/azcopy.sh azcopy
run ${BASE_DIR}/scripts/installers/azure-cli.sh azure-cli
run ${BASE_DIR}/scripts/installers/azure-devops-cli.sh azure-devops
run ${BASE_DIR}/scripts/installers/basic.sh basic
run ${BASE_DIR}/scripts/installers/bicep.sh bicep
run ${BASE_DIR}/scripts/installers/aliyun-cli.sh aliyun-cli
run ${BASE_DIR}/scripts/installers/apache.sh apache
run ${BASE_DIR}/scripts/installers/aws.sh aws
run ${BASE_DIR}/scripts/installers/clang.sh clang
run ${BASE_DIR}/scripts/installers/swift.sh swift
run ${BASE_DIR}/scripts/installers/cmake.sh cmake
run ${BASE_DIR}/scripts/installers/codeql-bundle.sh codeql
run ${BASE_DIR}/scripts/installers/containers.sh containers
run ${BASE_DIR}/scripts/installers/dotnetcore-sdk.sh dotnetcore
run ${BASE_DIR}/scripts/installers/erlang.sh erlang
run ${BASE_DIR}/scripts/installers/firefox.sh firegox
run ${BASE_DIR}/scripts/installers/gcc.sh gcc
run ${BASE_DIR}/scripts/installers/gfortran.sh gfortran
run ${BASE_DIR}/scripts/installers/git.sh git
run ${BASE_DIR}/scripts/installers/github-cli.sh github-cli
run ${BASE_DIR}/scripts/installers/google-chrome.sh google-chrome
run ${BASE_DIR}/scripts/installers/google-cloud-sdk.sh gcloud
run ${BASE_DIR}/scripts/installers/haskell.sh haskell
run ${BASE_DIR}/scripts/installers/heroku.sh heroku
run ${BASE_DIR}/scripts/installers/hhvm.sh hhvm
run ${BASE_DIR}/scripts/installers/java-tools.sh java
run ${BASE_DIR}/scripts/installers/kubernetes-tools.sh k8s
run ${BASE_DIR}/scripts/installers/oc.sh oc
run ${BASE_DIR}/scripts/installers/leiningen.sh leiningen
run ${BASE_DIR}/scripts/installers/miniconda.sh minicoda
run ${BASE_DIR}/scripts/installers/mono.sh mono
run ${BASE_DIR}/scripts/installers/kotlin.sh kotlin
run ${BASE_DIR}/scripts/installers/mysql.sh mysql
run ${BASE_DIR}/scripts/installers/mssql-cmd-tools.sh msql
run ${BASE_DIR}/scripts/installers/sqlpackage.sh sqlpackage
run ${BASE_DIR}/scripts/installers/nginx.sh nginx
run ${BASE_DIR}/scripts/installers/nvm.sh nvm
run ${BASE_DIR}/scripts/installers/nodejs.sh nodejs
run ${BASE_DIR}/scripts/installers/bazel.sh bazel
run ${BASE_DIR}/scripts/installers/oras-cli.sh oras
run ${BASE_DIR}/scripts/installers/phantomjs.sh phantomjs
run ${BASE_DIR}/scripts/installers/php.sh php
run ${BASE_DIR}/scripts/installers/postgresql.sh postgres
run ${BASE_DIR}/scripts/installers/pulumi.sh pulumi
run ${BASE_DIR}/scripts/installers/ruby.sh ruby
run ${BASE_DIR}/scripts/installers/r.sh r
run ${BASE_DIR}/scripts/installers/rust.sh rust
run ${BASE_DIR}/scripts/installers/julia.sh julia
run ${BASE_DIR}/scripts/installers/sbt.sh sbt
run ${BASE_DIR}/scripts/installers/selenium.sh selenium
run ${BASE_DIR}/scripts/installers/terraform.sh terraform
run ${BASE_DIR}/scripts/installers/packer.sh packer
run ${BASE_DIR}/scripts/installers/vcpkg.sh vcpkg
run ${BASE_DIR}/scripts/installers/dpkg-config.sh dpkg-config
run ${BASE_DIR}/scripts/installers/mongodb.sh mongodb
run ${BASE_DIR}/scripts/installers/android.sh android
run ${BASE_DIR}/scripts/installers/yq.sh yq
run ${BASE_DIR}/scripts/installers/pypy.sh pypy
run ${BASE_DIR}/scripts/installers/python.sh python
run ${BASE_DIR}/scripts/installers/graalvm.sh graal

## 3rd party
run_ps ${BASE_DIR}/scripts/installers/Install-Toolset.ps1
run_ps ${BASE_DIR}/scripts/installers/Configure-Toolset.ps1
run ${BASE_DIR}/scripts/installers/pipx-packages.sh
run ${BASE_DIR}/scripts/installers/homebrew.sh

## clean up
run ${BASE_DIR}/scripts/installers/cleanup.sh
run ${BASE_DIR}/scripts/base/apt-mock-remove.sh
run ${BASE_DIR}/scripts/base/snap.sh
run ${BASE_DIR}/scripts/installers/post-deployment.sh
