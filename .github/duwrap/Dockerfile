FROM node:latest

ENV LUA_VERSION=5.3.5 \
    LUAROCKS_VERSION=3.3.1

# set build deps, these are removed once we're done build LUA!
ENV BUILD_DEPS \
        gcc \
        libc-dev \
        libreadline-dev \
        make \
        unzip \
        wget

# set persistent deps, these are kept
ENV PERSISTENT_DEPS \
        ca-certificates

# install lua, luarocks and luamin
RUN set -xe && \
        apt-get update -y && apt-get install -y --no-install-recommends --no-install-suggests \
            ${BUILD_DEPS} \
            ${PERSISTENT_DEPS} \
        && \
        # install Lua
        wget http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz && \
        tar zxf lua-${LUA_VERSION}.tar.gz && rm -f lua-${LUA_VERSION}.tar.gz && \
        cd lua-${LUA_VERSION} && \
        make -j $(getconf _NPROCESSORS_ONLN) linux && make install && \
        cd / && rm -rf lua-${LUA_VERSION} && \
        # install LuaRocks
        wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
        tar zxf luarocks-${LUAROCKS_VERSION}.tar.gz && rm -f luarocks-${LUAROCKS_VERSION}.tar.gz && \
        cd luarocks-${LUAROCKS_VERSION} && \
        ./configure && \
        make -j $(getconf _NPROCESSORS_ONLN) build && make install && \
        cd / && rm -rf luarocks-${LUAROCKS_VERSION} && \
        # install luamin
        npm install -g luamin && \
        # install luacheck
        luarocks install luacheck && \
        # purge build deps
        apt-get remove --purge -y ${BUILD_DEPS} && apt-get autoremove --purge -y && rm -r /var/lib/apt/lists/* && \
        # test binaries
        lua -v && luarocks --version && (luamin -v || luamin -c 'print()')

WORKDIR /du

ENTRYPOINT ["/bin/bash"]
CMD ["scripts/wrap.sh"]
