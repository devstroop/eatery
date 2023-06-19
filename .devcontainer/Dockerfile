FROM ghcr.io/cirruslabs/flutter:3.10.5

# Install nano
RUN apt-get update && apt-get install -y nano

# Install Android SDK and emulator
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -O commandlinetools.zip \
    && unzip -q commandlinetools.zip -d /sdk \
    && rm commandlinetools.zip
ENV ANDROID_SDK_ROOT=/sdk
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-30" "emulator" \
    && avdmanager create avd -n emulator -k "system-images;android-30;google_apis;x86_64" --device "pixel"

# Expose port for Android emulator
EXPOSE 5555
