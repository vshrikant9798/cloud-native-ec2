FROM node:20-alpine
WORKDIR /app
COPY ./app/package.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["node", "server.js"]
