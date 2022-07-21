# Set up runtime container
FROM atomist/skill:alpine_3.16-node_16@sha256:45b4a0b5c48576a7269f8b2861ebc05cec1881cfb48abbb21aa8215ccf6bd3c6

LABEL com.docker.skill.api.version="container/v2"
COPY skill.yaml /
COPY datalog /datalog

WORKDIR "/skill"

COPY package.json package-lock.json ./

RUN apk add --no-cache \
 npm=8.10.0-r0 \
 && npm ci --no-optional \
 && npm cache clean --force \
 && apk del npm
    
COPY . ./

ENTRYPOINT ["node", "--no-deprecation", "--no-warnings", "--expose_gc", "--optimize_for_size", "--always_compact", "--max_old_space_size=512", "/skill/main.js"]
CMD ["run"]
