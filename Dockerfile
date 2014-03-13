# docker image for running CC test suite

FROM ubuntu

RUN apt-get -y install wget
RUN apt-get -y install git

# install Ruby 2.1.0
RUN apt-get -y install build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
ENV PATH /.rbenv/bin:/.rbenv/shims:$PATH
RUN echo PATH=$PATH
RUN rbenv init -
RUN rbenv install 2.1.0 && rbenv global 2.1.0

# never install a ruby gem docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

# Install bundler and the "bundle" shim
RUN gem install bundler && rbenv rehash

# Checkout the cloud_controller_ng code
RUN git clone -b master git://github.com/cloudfoundry/cloud_controller_ng.git /cloud_controller_ng

# mysql gem requires these
RUN apt-get -y install libmysqld-dev libmysqlclient-dev mysql-client
# pg gem requires this
RUN apt-get -y install libpq-dev
# sqlite gem requires this
RUN apt-get -y install libsqlite3-dev

# Optimization: Pre-run bundle install.
# It may be that some gems are installed that never get cleaned up,
# but this will make the subsequent CMD runs faster
RUN cd /cloud_controller_ng && bundle install

# Command to run at "docker run ..."
CMD if [ -z $BRANCH ]; then BRANCH=master; fi; \
    cd /cloud_controller_ng \
    && git checkout $BRANCH \
    && git pull \
    && git submodule init && git submodule update \
    && bundle install \
    && bundle exec rspec spec
