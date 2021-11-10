
#!/bin/bash
#
#    The purpose of this script is to create a package from a github run id that contains
#     the katana-ubuntu-20.04 and conda packages for that build. The script also creates
#     an installation directory from that package.
#
#    package dir = package-${RUNID}
#    install dir = install-${RUNID}
#
#

RUNID=${1:-1227325842}
packdir=package-${RUNID}
installdir=install-${RUNID}

echo Running RUN ID: $RUNID

if [ -d $packdir ] ; then
    echo dir exists.. skipping gh download..
else
    mkdir -p $packdir/katana-ubuntu-20.04-Release
    cd $packdir/katana-ubuntu-20.04-Release

    gh run download  $RUNID -n katana-ubuntu-20.04-Release -R git@github.com:KatanaGraph/katana-enterprise.git

    # leave conda dir inside katana dir to mirror how katana deploy script expects
    # cd ..

    mkdir -p conda
    cd conda

    gh run download $RUNID -n katana-conda-Release -R git@github.com:KatanaGraph/katana-enterprise.git

    cd ../../..
fi

mkdir -p $installdir
cd $installdir

unzip ../$packdir/katana-ubuntu-20.04-Release/katana-deploy-cluster.zip

cd katana-deploy-cluster

mkdir -p artifacts/run/${RUNID}

pushd artifacts/run/${RUNID}
echo pwd=$PWD

mv ../../../../../$packdir/katana-ubuntu-20.04-Release .

rm -rf ../../../../../$packdir