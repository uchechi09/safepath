# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.38.6 AS build

# Tell git Flutter SDK is safe
RUN git config --global --add safe.directory /sdks/flutter

WORKDIR /app
COPY . .

# Build as root (no user switching)
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]