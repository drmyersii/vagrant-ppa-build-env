#!/usr/bin/env bash


# update our repositories
sudo apt-get update -qq

# make an array of our build tools for easier editing/viewing
build_tools=(

    # data transfer tools
    bzr
    dput
    git
    wget

    # system build tools
    autoconf
    automake
    autotools-dev
    build-essential
    debhelper
    devscripts
    dh-make
    fakeroot
    pbuilder
    xutils

    # resource linter
    lintian

    # ruby build tools
    ruby2.0
    gem2deb

)

# loop through packages and install them
for i in ${build_tools[@]}
do
    echo "Installing Package: ${i}"

    sudo apt-get install -qq ${i}
done


# store build directory since we'll need it in the future
build_dir="${HOME}/build"

# create the directory we're going to be working in
mkdir -p ${build_dir}
cd ${build_dir}


# store vagrant source directory
vagrant_source_dir="${build_dir}/vagrant-source"

# store vagrant version
vagrant_version=1.7.2

# download vagrant and switch to stable branch
git clone https://github.com/mitchellh/vagrant.git ${vagrant_source_dir}
cd ${vagrant_source_dir}
git checkout tags/v${vagrant_version} -b "build_branch"


# bundler version
bundler_version=1.7.15

# install ruby tools
sudo gem2.0 install bundler -v ${bundler_version}

# build the ruby gem from the vagrant source
gem2.0 build vagrant.gemspec


# store vagrant tarball directory
vagrant_tarball_dir="${build_dir}/vagrant-tarball"

# create the directory
mkdir -p ${vagrant_tarball_dir}


# copy the gem to the tarball directory
cp vagrant-${vagrant_version}.gem ${vagrant_tarball_dir}/
cd ${vagrant_tarball_dir}

# convert the gem to a tarball
gem2tgz vagrant-${vagrant_version}.gem
rm vagrant-${vagrant_version}.gem

# extract tarball and prepare package for build configuration
#bzr dh-make vagrant ${vagrant_version} vagrant-${vagrant_version}.tar.gz





# use sbuild or pbuilder to test package building before uploading to launchpad
