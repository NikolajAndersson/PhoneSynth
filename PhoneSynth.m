classdef PhoneSynth < audioPlugin
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
        
        function obj = PhoneSynth()
            connector on nikolaj
            
            obj.fs = getSampleRate(obj);
            obj.pMobile = mobiledev;
            obj.pMobile.Logging = 1;
            obj.pMobile.AngularVelocitySensorEnabled = 1;
            obj.freq = 220;
            obj.delta = 0;
            obj.phase = 0;
            obj.modFreq = 220;
            obj.modDelta = 0;
            obj.modPhase = 0;
            obj.amp = 0;
            
        end
        
        function out = process (plugin, in)
            
            [m,n] = size(in);
            y = zeros(size(in));
            plugin.pMobile.Acceleration(1)
            plugin.freq = plugin.pMobile.Acceleration(1) * plugin.baseFreq;
            plugin.delta = plugin.freq * 2 * pi / plugin.fs;
            
            plugin.modFreq = plugin.pMobile.Acceleration(2) * plugin.baseFreq;
            plugin.modDelta = plugin.modFreq * 2 * pi / plugin.fs;
            
            for i = 1:m
                y(i,:) = sin(plugin.phase * sin(plugin.modPhase));
                
                plugin.phase = plugin.phase + plugin.delta;
                if plugin.phase > 2 * pi
                    plugin.phase = plugin.phase - 2*pi;
                end
                
                plugin.modPhase = plugin.modPhase + plugin.modDelta;
                if plugin.modPhase > 2 * pi
                    plugin.modPhase = plugin.modPhase - 2*pi;
                end
            end
            %%[plugin.amp,t] = angvellog(plugin.pMobile);
            mid = 0.5*(y(:,1) + y(:,2));
            sid = 0.5*(y(:,1) - y(:,2));
            sid = plugin.pMobile.Acceleration(3) * sid;
            
            out = [mid+sid mid-sid] * (plugin.amplitude *  abs(plugin.pMobile.AngularVelocity(3)/10));
            
            %out = y*plugin.amplitude;
        end
    end
    
end