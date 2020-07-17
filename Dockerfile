ARG IMAGE_ARCH=arm32v7
FROM torizon/$IMAGE_ARCH-debian-wayland-base:latest
RUN apt update && apt install -y --no-install-recommends \
    libfontconfig1 \
    libsdl2-dev
WORKDIR /
COPY ./app /app
WORKDIR /app
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV DISPLAY=:0