FROM ubuntu
MAINTAINER Sam McTaggart

RUN apt-get -y install wget
RUN apt-get -y install git

RUN wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
RUN tar -xzvf chruby-0.3.8.tar.gz
RUN cd chruby-0.3.8/
RUN sudo make install
RUN echo "source /usr/local/share/chruby/chruby.sh" >> ~/.bashrc
RUN echo "source /usr/local/share/chruby/auto.sh" >> ~/.bashrc

RUN wget -O ruby-install-0.4.1.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.1.tar.gz
RUN tar -xzvf ruby-install-0.4.1.tar.gz
RUN ruby-install-0.4.1/
RUN sudo make install
RUN ruby-install ruby

RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

RUN source ~/.bashrc

RUN gem install bundler

RUN gem install rspec
