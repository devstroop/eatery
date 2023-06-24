# Start from the base image
FROM ghcr.io/cirruslabs/flutter:stable

# Set the working directory to /workspace
WORKDIR /workspace

# Set the timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# Install necessary dependencies for Android SDK
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
 && rm -rf /var/lib/apt/lists/*

# Create the base directory for Android SDK
RUN mkdir -p /opt/android-sdk

# Set environment variables
# ENV ANDROID_HOME=/opt/android-sdk
# ENV PATH=${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/tools/bin

# Switch to root user
USER root

# Download and extract Android SDK tools
# RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O commandlinetools.zip \
    # && unzip -q commandlinetools.zip -d ${ANDROID_HOME}/cmdline-tools \
    # && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    # && rm commandlinetools.zip

# Accept Android SDK licenses
# RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses

# Install required Android SDK components
# RUN ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "system-images;android-30;google_apis;x86_64"

# Create Android emulator
# RUN echo "no" | ${ANDROID_HOME}/cmdline-tools/latest/bin/avdmanager create avd -n emulator -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Configure Flutter
RUN flutter config --enable-web

# Enable desktop support (optional)
RUN flutter config --enable-linux-desktop
RUN flutter config --enable-macos-desktop
RUN flutter config --enable-windows-desktop

# Expose port for Android emulator
EXPOSE 5555

# Switch back to non-root user
USER codespace

# Set working directory
WORKDIR /workspace
