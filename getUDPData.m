classdef getUDPData < handle
    % Retrieve the data from your device
    
    properties
        
        
    end
    properties(Access = private)
        m
        posX
        posY
        posZ
        
        x = [];
        y = [];
        z = [];
    end
    properties(Constant)
        arrayLength = 10;
    end
    
    methods
        function obj = getUDPData()
            
            obj.posX = 1;
            obj.posY = 1;
            obj.posZ = 1;
            obj.x = zeros(obj.arrayLength,1);
            obj.y = zeros(obj.arrayLength,1);
            obj.z = zeros(obj.arrayLength,1);
        end
        
        function out = getRawX(obj)
            out = abs(obj.m.Acceleration(1));
        end
         function out = getRawY(obj)
            out = abs(obj.m.Acceleration(2));
         end
         function out = getRawZ(obj)
            out = abs(obj.m.Acceleration(3));
         end
         function out = getAccLog(obj)
            a = obj.m.accellog;
            out = a(end,1);
         end
        
        function out = getX(obj)
            obj.x(obj.posX) = obj.m.Acceleration(1);
            
            obj.posX = obj.posX + 1;
            if(obj.posX > obj.arrayLength)
                obj.posX = 1;
            end
            out = mean(abs(obj.x));
        end
        function out = getY(obj)
            obj.y(obj.posY) = obj.m.Acceleration(2);
            obj.posY = obj.posY + 1;
            if(obj.posY > obj.arrayLength)
                obj.posY = 1;
            end
            
            out = mean(obj.y);
        end
        function out = getZ(obj)
            obj.z(obj.posZ) = obj.m.Acceleration(3);
            
            obj.posZ = obj.posZ + 1;
            if(obj.posZ > obj.arrayLength)
                obj.posZ = 1;
            end
            out = mean(obj.z);
        end

    end
    
end

