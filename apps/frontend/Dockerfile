FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install
COPY . .
RUN npm ci --no-audit --no-fund --loglevel verbose

COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Optional: include nginx.conf if you deploy with service names inside cluster
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
