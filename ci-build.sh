#!/bin/bash

package=nginx
ngx_version=1.20.2
bsc_version=001
version=${ngx_version}.${bsc_version}
target=$package-$version
target_debug=$package-debuginfo-$version

release=$BUILD_ID

echo -n $version > .VERSION

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$1"x != "x" ]; then
    branch=$1
fi
feat=$(echo $branch | cut -d '-' -f 2)
if [ "$feat" != "release" ]; then
    release=${release}.${feat}
fi

echo "Building version: ${target}-${release}"

ln -sf $(pwd) ~/rpmbuild/SOURCES/${target}
tar --exclude-vcs --exclude ${target}/packages/ --dereference -C ~/rpmbuild/SOURCES -czf ~/rpmbuild/SOURCES/${target}.tar.gz $target
rm -rf ~/rpmbuild/SOURCES/${target}

sed -e "s,@version@,${version},g" -e "s,@release@,${release},g" ${package}.spec.in > ${package}.spec
rpmbuild -bb --clean ${package}.spec

mkdir -p packages
mv ~/rpmbuild/RPMS/x86_64/${target}-${release}*.x86_64.rpm packages/
mv ~/rpmbuild/RPMS/x86_64/${target_debug}-${release}*.x86_64.rpm packages/
ls packages/${target}-${release}* packages/${target_debug}-${release}* > .PACKAGES
