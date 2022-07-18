# Set up runtime container
FROM atomist/skill:alpine_3.16-node_16@sha256:d1a95d8f2652efe90eddf05b7786fdd7d8374582e61fe249fca8bf4b1810030e

WORKDIR "/skill"

LABEL com.docker.skill.api.version="container/v2"
COPY skill.yaml /

COPY package.json package-lock.json ./

RUN apk add --no-cache \
 npm=8.10.0-r0 \
 && npm ci --no-optional \
 && npm cache clean --force \
 && apk del npm
    
COPY . ./

ENTRYPOINT ["node", "--no-deprecation", "--no-warnings", "--expose_gc", "--optimize_for_size", "--always_compact", "--max_old_space_size=512", "/skill/main.js"]
CMD ["run"]
