FROM fedora:23

# non-default docker proxy vars
ARG ALL_PROXY
ARG socks_proxy
ARG SOCKS_PROXY

RUN dnf --assumeyes update && \
	dnf --assumeyes install wget gawk make tar bzip2 gzip python unzip perl \
	patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath \
	ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue socat \
	findutils which SDL-devel xterm file cpio perl-bignum libselinux-python xz \
        python3 python3-curses \
        syslinux


ENV JENKINS_HOME /var/lib/jenkins

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -o -g ${gid} ${group} \
	&& useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# VOLUME ${JENKINS_HOME}

USER jenkins
WORKDIR ${JENKINS_HOME}
