classdef PhoneSynth03 < audioPlugin
    %myWidth Stereo expension by center and side channels
    %   Detailed explanation goes here
    
    properties
        Width = 1
        amplitude = .5;
        baseFreq = 440;
        pMobile;
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('Width', 'Mapping',{'pow',4,0,16}),...
            audioPluginParameter('amplitude', 'Mapping',{'lin', 0 1}),...
            audioPluginParameter('baseFreq', 'Mapping',{'lin', 0 300}))
    end
    
    properties (Access = private)
        freq
        phase
        delta
        
        fs
        amp
    end
    
    methods
        
        function obj = PhoneSynth03()

            connector on nikolaj
            obj.fs = getSampleRate(obj);
            obj.pMobile = mobiledev;
            
            obj.pMobile.OrientationSensorEnabled = 1;
            obj.pMobile.Logging = 1;
            obj.pMobile.SampleRate = 4;
            
            obj.freq = 440;
            obj.delta = 0;
            obj.phase = 0;
            
            obj.amp = 0;  
        end
        
        function out = process (plugin, in)
            y = zeros(size(in));

            % Make sure that "angle" always has a value between -180 and
            % 180
            if isempty(plugin.pMobile.Orientation)
                angle = 0; 
            else
                angle = plugin.pMobile.Orientation(1);
            end
            
            initialFreq = plugin.baseFreq + (1.5 * angle);
            midiVal = 69 + 12*log2( initialFreq / 440 );
            
            plugin.freq = 440 * (2^( (floor(midiVal) - 69) / 12 )); 
            plugin.delta = plugin.freq * 2 * pi / plugin.fs;
            
            for i = 1:length(y)
                y(i,:) = sin(plugin.phase);
                plugin.phase = plugin.phase + plugin.delta;

                if plugin.phase > 2 * pi
                    plugin.phase = plugin.phase - 2*pi;
                end  
            end
            
            out = y * plugin.amplitude;
        end
    end
    
end
