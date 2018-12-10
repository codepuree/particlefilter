function [New_Pose, oldPoseIdx] = Resample(n,weights,Poses,Streu)
% Rand = [s,angle];
w2 = (weights*(n) / 10000);
[w2s, idx]=sort(w2, 'descend');
New_Pose = zeros(n,3);
num_of_Pose = 0;
index = 1;
gewicht = w2s-0.5;
WEIGHT=ceil(gewicht);

% if (n < 700)
    disp(['N: ',num2str(n)]);
    disp(['Summe der Gewichte: ',num2str(sum(WEIGHT)),'; Differenz: ' num2str(sum(w2)-sum(WEIGHT))]);
% end

oldPoseIdx = false(n, 1);

while num_of_Pose < n

    if (index > length(WEIGHT))
       index = 1;
       WEIGHT(:) = 1;
    end
     number = WEIGHT(index);
    
    if number ~= 0
        particle = Poses(idx(index),:);
        num_of_Pose = num_of_Pose + 1;
        New_Pose(num_of_Pose,:) = particle;
        oldPoseIdx(num_of_Pose) = true;
        
        for j = 1:number - 1

            ang = randn(1)*Streu(3)-Streu(3)/2;
            x = randn() / 5 * Streu(1);
            y = randn() / 5 * Streu(2);

            num_of_Pose = num_of_Pose + 1;
            New_Pose(num_of_Pose,1) = Poses(idx(index),1) + x;
            New_Pose(num_of_Pose,2) = Poses(idx(index),2) + y;
            New_Pose(num_of_Pose,3) = Poses(idx(index),3) + ang;
%             New_Pose(num_of_Pose+j,:) = Poses(idx(index),:) + pol2cart(rand(1), rand(1) * 0.5);

            if num_of_Pose >= n
                break;
            end
        end 
    else
        num_of_Pose =num_of_Pose + 1; 
        New_Pose(num_of_Pose,:) = Poses(idx(index),:);
    end
    
    index = index + 1;
end
end

