classdef PhoneSynth02 < audioPlugin
    %myWidth Stereo expension by center and side channels
    %   Detailed explanation goes here
    
    properties
        Width = 1
        amplitude = .5
        baseFreq = 100;
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('Width', 'Mapping',{'pow',4,0,16}),...
            audioPluginParameter('amplitude', 'Mapping',{'lin', 0 1}),...
            audioPluginParameter('baseFreq', 'Mapping',{'lin', 0 300}))
    end
    
    properties (Access = private)
        pMobile
        freq
        phase
        delta
        modFreq
        modPhase
        modDelta
        fs
        amp
    end
    
    methods
        
        function obj = PhoneSynth02()
            obj.pMobile = getMobileData;
            
            obj.fs = getSampleRate(obj);
            
            obj.freq = 220;
            obj.delta = 0;
            obj.phase = 0;
            obj.modFreq = 220;
            obj.modDelta = 0;
            obj.modPhase = 0;
            obj.amp = 0;
            
        end
        
        function out = process (plugin, in)
            accX = plugin.pMobile.getX;
            accY = plugin.pMobile.getY;
            accZ = plugin.pMobile.getZ;
            
            [m,n] = size(in);
            y = zeros(size(in));
            
            plugin.freq = accX * plugin.baseFreq;
            plugin.freq
            plugin.delta = plugin.freq * 2 * pi / plugin.fs;
            
            plugin.modFreq = accY * plugin.baseFreq;
            plugin.modDelta = plugin.modFreq * 2 * pi / plugin.fs;
            
            for i = 1:m
                y(i,:) = sin(plugin.phase); %* sin(plugin.modPhase));
                
                plugin.phase = plugin.phase + plugin.delta;
                if plugin.phase > 2 * pi
                    plugin.phase = plugin.phase - 2*pi;
                end
                
                plugin.modPhase = plugin.modPhase + plugin.modDelta;
                if plugin.modPhase > 2 * pi
                    plugin.modPhase = plugin.modPhase - 2*pi;
                end
            end
           
            out = y*plugin.amplitude;
        end
    end
    
end