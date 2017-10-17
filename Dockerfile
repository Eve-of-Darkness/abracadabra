FROM ubuntu:14.04
MAINTAINER Ben Falk <benjamin.falk@yahoo.com>

# Elixir requires UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update and install base requirements
RUN apt-get update \
    && apt-get install -y curl wget git make build-essential postgresql-client inotify-tools

# download and install Erlang package
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y elixir erlang \
    && rm erlang-solutions_1.0_all.deb

# install hex and rebar
RUN mix local.hex --force \
    && mix hex.info \
    && mix local.rebar --force

CMD ["bash"]
