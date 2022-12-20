FROM busybox AS build-env

RUN mkdir /empty


FROM scratch

ENV DRAKY_TOOLS_CORE_BIN_PATH "/draky-tools.core.bin"
ENV DRAKY_TOOLS_CORE_INIT_PATH "/draky-tools.core.init.d"

ENV DRAKY_TOOLS_BIN_PATH "/draky-tools.bin"
ENV DRAKY_TOOLS_INIT_PATH "/draky-tools.init.d"

ENV DRAKY_TOOLS_RESOURCES_PATH "/draky-tools.resources"

ENV DRAKY_TOOLS_ENTRYPOINT "/draky-tools.entrypoint.sh"

ENV DRAKY_DEBUG 0

COPY core.init.d ${DRAKY_TOOLS_CORE_INIT_PATH}
COPY core.bin ${DRAKY_TOOLS_CORE_BIN_PATH}
COPY entrypoint.sh ${DRAKY_TOOLS_ENTRYPOINT}

# Create required empty directories.
COPY --from=build-env /empty ${DRAKY_TOOLS_INIT_PATH}
COPY --from=build-env /empty ${DRAKY_TOOLS_BIN_PATH}
COPY --from=build-env /empty ${DRAKY_TOOLS_RESOURCES_PATH}
