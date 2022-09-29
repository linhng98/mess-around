FROM node:18-alpine3.15 AS builder

WORKDIR docs

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

RUN npm run build


FROM nginx:1.23.1-alpine

COPY --from=builder /docs/build /usr/share/nginx/html
