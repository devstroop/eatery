# Start from the base image
FROM ubuntu:20.04

# Set the working directory to /workspace
WORKDIR /workspace

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

# Download and install Android SDK
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O commandlinetools.zip \
    && unzip -q commandlinetools.zip -d cmdline-tools \
    && rm commandlinetools.zip

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME=/workspace/cmdline-tools
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accept Android SDK licenses
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# Install required Android SDK components
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# Install required Android packages
RUN /sdk/cmdline-tools/tools/bin/sdkmanager "platform-tools" "platforms;android-30" "emulator"

# Create Android emulator
RUN echo "no" | /sdk/cmdline-tools/tools/bin/avdmanager create avd -n emulator -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Install Flutter
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
RUN git clone --branch 3.10.5 https://github.com/flutter/flutter.git ${FLUTTER_HOME}
RUN flutter config --no-analytics && flutter precache

# Configure Flutter
RUN flutter config --enable-web

# Enable desktop support (optional)
RUN flutter config --enable-linux-desktop
RUN flutter config --enable-macos-desktop
RUN flutter config --enable-windows-desktop

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Expose port for Android emulator
EXPOSE 5555

# Switch back to non-root user
USER codespace

# Set working directory
WORKDIR /workspace
