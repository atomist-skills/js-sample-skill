# Set up runtime container
FROM atomist/skill:alpine_3.16-node_16@sha256:3c28a049c076aead769480ec214d6e2a46f0f8b7fd2f7f66da0e71e47cbaf5d2

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
