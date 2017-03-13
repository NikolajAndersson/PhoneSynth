
clear hostedPlugin deviceWriter y;

hostedPlugin = PhoneSynth03();

deviceWriter = audioDeviceWriter('SampleRate',44100);
setSampleRate(hostedPlugin,44100);

disp('Running main loop. Press Ctrl-C to stop....');
while true
    y = hostedPlugin.process(ones(1024, 2));
    deviceWriter(y);
end

release(deviceWriter);