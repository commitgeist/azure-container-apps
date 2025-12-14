FROM node:lts-alpine
RUN apk add --no-cache python3 g++ make
WORKDIR /app
COPY . .
RUN yarn install --production


EXPOSE 3000
EXPOSE 80


CMD ["node", "/app/src/index.js"]