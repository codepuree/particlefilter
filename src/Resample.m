function [New_Pose] = Resample(n,weights,Poses,Streu)
% Rand = [s,angle];
w2 = (weights*(n));
[w2s, idx]=sort(w2, 'descend');
New_Pose = zeros(n,3);
num_of_Pose = 0;
index = 1;
gewicht = w2s-0.5;
WEIGHT=ceil(gewicht);
<<<<<<< HEAD

=======
% help = 10000;
% test_weight = floor(w2s+0.5);
% test_weight = (ceil(test_weight))/help;
% counter = 0;
% while (sum(WEIGHT) < n)
%    w2s = w2s +0.00001; 
%    WEIGHT = floor(w2s+0.5);
%    counter = counter+1;
% end
>>>>>>> b937192b366b17f90c4bd126653b168c31b3759d
if (n < 700)
    disp(['N: ',num2str(n)]);
    disp(['Summe der Gewichte: ',num2str(sum(WEIGHT))]);
end


while num_of_Pose < n
    number = WEIGHT(index);
    
    if number ~= 0
        particel = Poses(idx(index),:);
        num_of_Pose = num_of_Pose + 1;
        New_Pose(num_of_Pose,:) = particle;
        
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

