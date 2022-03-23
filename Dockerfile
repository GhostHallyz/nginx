FROM centos:7

MAINTAINER hallyz 3208701506@qq.com

WORKDIR /root

RUN yum install -y epel-release && yum -y --enablerepo=epel install geoip geoip-devel && yum groupinstall -y "Development Tools" && yum install -y vim zlib-devel initscripts

RUN mkdir -p /root/rpmbuild/ && cd /root/rpmbuild && mkdir BUILD BUILDROOT RPMS SOURCES SPECS SRPMS
