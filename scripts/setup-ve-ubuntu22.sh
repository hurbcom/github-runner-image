#!/usr/bin/env bash

ENABLED_PACKAGES=${1:-all}
export VE_UBUNTU_TAG=${VE_UBUNTU_TAG:-20230425.1}
export DEBIAN_FRONTEND=noninteractive

# Download virtual environment ubuntu 20
wget https://github.com/actions/virtual-environments/archive/refs/tags/ubuntu22/${VE_UBUNTU_TAG}.tar.gz -O - | tar zx
cd virtual-environments-ubuntu22*/

# Set some variables
export BASE_DIR=$(pwd)/images/linux
export HELPER_SCRIPTS=${BASE_DIR}/scripts/helpers
export INSTALLER_SCRIPT_FOLDER=${BASE_DIR}/scripts/installers
export IMAGE_OS=ubuntu22

. /tmp/invoke_tests.sh

function should_be_installed {
    NAME="$1"

    # No name was defined, skip check
    if [ -z "$NAME" ]; then
        return 0

    # Install all packages
    elif [[ "$ENABLED_PACKAGES" == "all" ]]; then
        return 0

    # Check if package is enabled to install
    elif [[ " $ENABLED_PACKAGES " == *"$NAME"* ]]; then
        return 0

    fi

    # Abort
    return 1
}

function run {
    if ! should_be_installed $2; then
        echo "--- Skipping ${1##*/} because it is not enabled for installation"
        return 0
    fi

    echo "--- Running ${1##*/}"
    if [ ! -f "$1" ]; then
        return 0
    fi
    sudo sh -c "HELPER_SCRIPTS=${HELPER_SCRIPTS} INSTALLER_SCRIPT_FOLDER=${INSTALLER_SCRIPT_FOLDER} IMAGE_OS=${IMAGE_OS} $1"
}

function run_ps {
    if ! should_be_installed $2; then
        echo "--- Skipping ${1##*/} because it is not enabled for installation"
        return 0
    fi

    echo "--- Running PowerShell ${1##*/}"
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
ln -s ${BASE_DIR}/toolsets/toolset-2004.json ${BASE_DIR}/scripts/installers/toolset.json
[ -d /imagegeneration/installers ] || mkdir -p /imagegeneration/installers

run ${BASE_DIR}/scripts/installers/powershellcore.sh powershell
run_ps ${BASE_DIR}/scripts/installers/Install-PowerShellModules.ps1 powershell-modules
run_ps ${BASE_DIR}/scripts/installers/Install-AzureModules.ps1 azure-modules
run ${BASE_DIR}/scripts/installers/docker-compose.sh docker
run ${BASE_DIR}/scripts/installers/docker-moby.sh docker

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
run ${BASE_DIR}/scripts/installers/dotnetcore-sdk.sh # needed for runner
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
run_ps ${BASE_DIR}/scripts/installers/Install-Toolset.ps1 toolset 
run_ps ${BASE_DIR}/scripts/installers/Configure-Toolset.ps1 toolset
run ${BASE_DIR}/scripts/installers/pipx-packages.sh pipx
run ${BASE_DIR}/scripts/installers/homebrew.sh homebrew

## clean up
run ${BASE_DIR}/scripts/installers/cleanup.sh
run ${BASE_DIR}/scripts/base/apt-mock-remove.sh
run ${BASE_DIR}/scripts/base/snap.sh
run ${BASE_DIR}/scripts/installers/post-deployment.sh

sudo apt --fix-broken install 