# Set up runtime container
FROM atomist/skill:alpine_3.15-node_16@sha256:46e34acfec0f3863f40b2ec08c73ad17306b9a084db47e510ce3748d6b6c7384

WORKDIR "/skill"

LABEL com.docker.skill.api.version="container/v2"
COPY skill.yaml /

COPY package.json package-lock.json ./

RUN apk add --no-cache \
 npm=8.1.3-r0 \
 && npm ci --no-optional \
 && npm cache clean --force \
 && apk del npm
    
COPY . ./

ENTRYPOINT ["node", "--no-deprecation", "--no-warnings", "--expose_gc", "--optimize_for_size", "--always_compact", "--max_old_space_size=512", "/skill/main.js"]
CMD ["run"]
