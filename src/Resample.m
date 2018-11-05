function [New_Pose] = Resample(n,weights,Poses,Streu)
% Rand = [s,angle];
w2 = (weights*(n));
[w2s, idx]=sort(w2, 'descend');
New_Pose = zeros(n,3);
num_of_Pose = 0;
index = 1;
WEIGHT=floor(w2s+0.5);
% help = 10000;
% test_weight = floor(w2s+0.5);
% test_weight = (ceil(test_weight))/help;
counter = 0;
% while (sum(WEIGHT) < n)
%    w2s = w2s +0.00001; 
%    WEIGHT = floor(w2s+0.5);
%    counter = counter+1;
% end


while num_of_Pose < n
    number = WEIGHT(index);
    
    if number ~= 0
        New_Pose(num_of_Pose+1,:) = Poses(idx(index),:);
        for j = 2:number
            s = rand(1)* Streu(1)-Streu(1)/2;
            ang = rand(1)*Streu(2)-Streu(2)/2;
            [x,y]= pol2cart(ang + Poses(idx(index),3),s);
            New_Pose(num_of_Pose+j,1) = Poses(idx(index),1) + x;
            New_Pose(num_of_Pose+j,2) = Poses(idx(index),2) + y;
            New_Pose(num_of_Pose+j,3) = Poses(idx(index),3) + ang;
%             New_Pose(num_of_Pose+j,:) = Poses(idx(index),:) + pol2cart(rand(1), rand(1) * 0.5);
        end
        num_of_Pose =num_of_Pose + number; 
    else
        num_of_Pose =num_of_Pose + 1; 
        New_Pose(num_of_Pose,:) = Poses(idx(index),:);
    end
    index = index+1;
end
end

