FROM mcr.microsoft.com/vscode/devcontainers/universal:1-linux

# Set user to root
USER root

# Install nano
RUN apt-get update && apt-get install -y nano

# Install Java 11
RUN apt-get install -y openjdk-11-jdk

# Install Android SDK and emulator
ENV ANDROID_SDK_ROOT=/sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -O commandlinetools.zip \
    && unzip -q commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && rm commandlinetools.zip \
    && yes | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager --licenses \
    && ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/sdkmanager "platform-tools" "platforms;android-30" "emulator" \
    && echo "no" | ${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin/avdmanager create avd -n emulator -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Install Flutter
ENV FLUTTER_HOME=/usr/local/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"
RUN git clone --branch 3.10.5 https://github.com/flutter/flutter.git ${FLUTTER_HOME}
RUN flutter config --no-analytics && flutter precache

# Set Android SDK paths for Flutter
ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
RUN yes | sdkmanager --update
RUN yes | sdkmanager --install "platforms;android-30" "build-tools;30.0.3"

# Accept Android licenses
RUN yes | sdkmanager --licenses

# Configure Flutter
RUN flutter config --no-analytics
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
