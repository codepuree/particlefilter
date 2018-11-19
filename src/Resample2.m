function [New_pose] = Resample2(n, weights, particle, noise)
%   n = Ziel anzahl
% weights = gewichtsvektor normalisiert
% particle
% noise = [x,y,angle]
number_of_Poses = 0;
index = 1;


weight_skal = weights*n;
[sw,swIdx] = sort(weight_skal, 'descend');
New_Pose = zeros(n,3);
G = round(sw); % TODO: genauer anschauen

while number_of_Poses < n
    haufigkeit = G(index);
    number_of_Poses = number_of_Poses + 1;
    New_Pose(number_of_Poses) = particle(swIdx(index),:);
    
    if haufigkeit > 1
        for i = 1 : haufigkeit -1
            number_of_Poses = number_of_Poses + 1;
            
            if number_of_poses <= n
                % NOISE
                New_Pose(number_of_Poses) = particle(swIdx(index),:);
            end
        end
    end
        
    index = index + 1;
end


end