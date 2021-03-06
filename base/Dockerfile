FROM phusion/baseimage:0.9.22

ENV RUBY_MAJOR "2.4"
ENV RUBY_VERSION "2.4.2"
ENV RUBYGEMS_VERSION "2.6.11"
ENV BUNDLER_VERSION "1.14.6"
ENV NODE_VERSION "6.10.1"
ENV BOWER_VERSION "1.8.0"

ENV APT_PACKAGES " \
  wget git gcc g++ make patch binutils libc6-dev libjemalloc-dev \
  libffi-dev libssl-dev libyaml-dev zlib1g-dev libgmp-dev libxml2-dev \
  libxslt1-dev libpq-dev libreadline-dev libsqlite3-dev libmysqlclient-dev \
  tzdata yarn "

ENV APT_REMOVE_PACKAGES "anacron cron openssh-server postfix"

COPY apt.conf /etc/apt/apt.conf.d/local
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
COPY yarn.list /etc/apt/sources.list.d
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y --no-install-recommends $APT_PACKAGES


# libs for imagemagick
# jpg
RUN cd /tmp  && \
    wget http://www.ijg.org/files/jpegsrc.v8c.tar.gz && \
    tar xvfz jpegsrc.v8c.tar.gz && \
    cd jpeg-* && \
    ./configure --enable-shared --prefix=$CONFIGURE_PREFIX && \
    make && \
    make install


RUN apt-get -y update && \
        apt-get -y upgrade

RUN apt-get install -y ocl-icd-libopencl1 opencl-headers  clinfo ocl-icd-opencl-dev \
    libpng16-16 libpng-dev  libturbojpeg  libjpeg-dev \
    librsvg2-bin \
    libjpeg-dev \
      libtool \
      libperl-dev \
      pkg-config autoconf






# imagemagick
WORKDIR /tmp

RUN wget https://imagemagick.org/download/ImageMagick-7.0.8-28.tar.gz && \
    tar xvzf ImageMagick-7.0.8-28.tar.gz && \
    cd ImageMagick-7.0.8-28 && \
    ./configure --with-autotrace=no  --with-gslib=yes  --with-fontpath=  \
                  --enable-delegate-build=yes  --enable-shared  --enable-static   --with-modules=yes \
                  --without-perl --without-magick-plus-plus --disable-openmp \
                  --with-bzlib=yes \
                  --with-jpeg=yes \
                  --with-png=yes \
                  --with-tiff=yes \
                  --with-xml=yes \
                  --with-rsvg=yes   && \
    make && \
    make install && \
    ldconfig /usr/local/lib



#
RUN apt-get remove --purge -y $APT_REMOVE_PACKAGES
RUN apt-get autoremove --purge -y


WORKDIR /tmp
RUN curl -o ruby.tgz \
    "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR}/ruby-${RUBY_VERSION}.tar.gz" && \
  tar -xzf ruby.tgz && \
  cd ruby-${RUBY_VERSION} && \
  ./configure --enable-shared --with-jemalloc --disable-install-doc && \
  make -j4 && \
  make install

ENV GEM_SPEC_CACHE "/tmp/gemspec"
RUN echo 'gem: --no-document' > $HOME/.gemrc
RUN gem update --system ${RUBYGEMS_VERSION}
RUN gem install -v ${BUNDLER_VERSION} bundler

RUN curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz \
  |tar -xz -C /usr --strip-components=1
RUN npm install bower@${BOWER_VERSION} -g

RUN rm /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -r /etc/service/sshd /etc/service/cron

# copy scripts
COPY wait-for-syslog.sh /opt/
COPY db_migrate.sh /etc/my_init.d/90_db_migrate.sh
COPY sidekiq.sh /etc/service/sidekiq/run
COPY appserver.sh /etc/service/appserver/run
COPY clockwork.sh /etc/service/clockwork/run

COPY puma.rb /etc/
COPY sidekiq.yml /etc/
COPY clockwork.rb /etc/

COPY rails-assets.sh /opt/

# app
RUN useradd -m app
RUN mkdir /home/app/webapp && chown app:app -R /home/app


#RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt /var/lib/dpkg /usr/share/man /usr/share/doc
