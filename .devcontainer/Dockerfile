# Start from a stable Flutter image
FROM ghcr.io/cirruslabs/flutter:3.41.0

# Set the timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# Install tools: melos for monorepo, zig for native libeaterystore
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Zig (for libeaterystore native library)
RUN wget -q https://ziglang.org/download/0.14.0/zig-linux-x86_64-0.14.0.tar.xz -O /tmp/zig.tar.xz \
    && tar -xf /tmp/zig.tar.xz -C /usr/local \
    && mv /usr/local/zig-linux-x86_64-0.14.0 /usr/local/zig \
    && rm /tmp/zig.tar.xz
ENV PATH="${PATH}:/usr/local/zig"

# Activate melos globally
RUN dart pub global activate melos

# Enable Flutter platforms
RUN flutter config --enable-web
RUN flutter config --enable-linux-desktop

# Expose port for sync server
EXPOSE 9876

USER codespace
WORKDIR /workspace
