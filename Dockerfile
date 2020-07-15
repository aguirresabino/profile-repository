FROM node:lts-alpine As build
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . .
RUN yarn build

FROM node:lts-alpine as production
ARG NODE_ENV=production
ARG PORT=3000
ENV NODE_ENV=${NODE_ENV}
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn install --production && yarn global add pm2
COPY --from=build /usr/src/app/dist ./dist
EXPOSE ${PORT}
CMD ["pm2-runtime", "start", "dist/main.js"]