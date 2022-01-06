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
run ${BASE_DIR}/scripts/installers/azcopy.sh
run ${BASE_DIR}/scripts/installers/azure-cli.sh
run ${BASE_DIR}/scripts/installers/azure-devops-cli.sh
run ${BASE_DIR}/scripts/installers/basic.sh
run ${BASE_DIR}/scripts/installers/bicep.sh
run ${BASE_DIR}/scripts/installers/aliyun-cli.sh
run ${BASE_DIR}/scripts/installers/apache.sh
run ${BASE_DIR}/scripts/installers/aws.sh
run ${BASE_DIR}/scripts/installers/clang.sh
run ${BASE_DIR}/scripts/installers/swift.sh
run ${BASE_DIR}/scripts/installers/cmake.sh
run ${BASE_DIR}/scripts/installers/codeql-bundle.sh
run ${BASE_DIR}/scripts/installers/containers.sh
run ${BASE_DIR}/scripts/installers/dotnetcore-sdk.sh
run ${BASE_DIR}/scripts/installers/erlang.sh
run ${BASE_DIR}/scripts/installers/firefox.sh
run ${BASE_DIR}/scripts/installers/gcc.sh
run ${BASE_DIR}/scripts/installers/gfortran.sh
run ${BASE_DIR}/scripts/installers/git.sh
run ${BASE_DIR}/scripts/installers/github-cli.sh
run ${BASE_DIR}/scripts/installers/google-chrome.sh
run ${BASE_DIR}/scripts/installers/google-cloud-sdk.sh
run ${BASE_DIR}/scripts/installers/haskell.sh
run ${BASE_DIR}/scripts/installers/heroku.sh
run ${BASE_DIR}/scripts/installers/hhvm.sh
run ${BASE_DIR}/scripts/installers/java-tools.sh
run ${BASE_DIR}/scripts/installers/kubernetes-tools.sh
run ${BASE_DIR}/scripts/installers/oc.sh
run ${BASE_DIR}/scripts/installers/leiningen.sh
run ${BASE_DIR}/scripts/installers/miniconda.sh
run ${BASE_DIR}/scripts/installers/mono.sh
run ${BASE_DIR}/scripts/installers/kotlin.sh
run ${BASE_DIR}/scripts/installers/mysql.sh
run ${BASE_DIR}/scripts/installers/mssql-cmd-tools.sh
run ${BASE_DIR}/scripts/installers/sqlpackage.sh
run ${BASE_DIR}/scripts/installers/nginx.sh
run ${BASE_DIR}/scripts/installers/nvm.sh
run ${BASE_DIR}/scripts/installers/nodejs.sh
run ${BASE_DIR}/scripts/installers/bazel.sh
run ${BASE_DIR}/scripts/installers/oras-cli.sh
run ${BASE_DIR}/scripts/installers/phantomjs.sh
run ${BASE_DIR}/scripts/installers/php.sh
run ${BASE_DIR}/scripts/installers/postgresql.sh
run ${BASE_DIR}/scripts/installers/pulumi.sh
run ${BASE_DIR}/scripts/installers/ruby.sh
run ${BASE_DIR}/scripts/installers/r.sh
run ${BASE_DIR}/scripts/installers/rust.sh
run ${BASE_DIR}/scripts/installers/julia.sh
run ${BASE_DIR}/scripts/installers/sbt.sh
run ${BASE_DIR}/scripts/installers/selenium.sh
run ${BASE_DIR}/scripts/installers/terraform.sh
run ${BASE_DIR}/scripts/installers/packer.sh
run ${BASE_DIR}/scripts/installers/vcpkg.sh
run ${BASE_DIR}/scripts/installers/dpkg-config.sh
run ${BASE_DIR}/scripts/installers/mongodb.sh
run ${BASE_DIR}/scripts/installers/android.sh
run ${BASE_DIR}/scripts/installers/yq.sh
run ${BASE_DIR}/scripts/installers/pypy.sh
run ${BASE_DIR}/scripts/installers/python.sh
run ${BASE_DIR}/scripts/installers/graalvm.sh

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
