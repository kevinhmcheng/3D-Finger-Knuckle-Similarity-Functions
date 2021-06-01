function [final_score] = compute_score_density(bitPlanesA,bitPlanesB,score_map)

%Rotating Planes A, Shifting Planes B
[rows, cols, p] = size(bitPlanesA);
shiftLength_i = ceil(rows*0.25); %ceil(rows*0.25)
shiftLength_j = ceil(cols*0.25); %ceil(cols*0.25)
score = ones(2*shiftLength_i+1,2*shiftLength_j+1,21);%,21

for degree = -10:1:10
    bitPlanesA_R = imrotate(bitPlanesA,degree,'crop');

    for shifti = -shiftLength_i:shiftLength_i
        for shiftj = -shiftLength_j:shiftLength_j
            new_bitPlanesA = bitPlanesA_R(1+shiftLength_i:rows-shiftLength_i,1+shiftLength_j:cols-shiftLength_j,:);%constant center part
            new_bitPlanesB = bitPlanesB(1+shiftLength_i+shifti:rows-shiftLength_i+shifti,1+shiftLength_j+shiftj:cols-shiftLength_j+shiftj,:);

            Planes = score_map(new_bitPlanesA(:,:,1)*128+new_bitPlanesA(:,:,2)*64+new_bitPlanesA(:,:,3)*32+new_bitPlanesA(:,:,4)*16+new_bitPlanesB(:,:,1)*8+new_bitPlanesB(:,:,2)*4+new_bitPlanesB(:,:,3)*2+new_bitPlanesB(:,:,4)+1);
            score(shifti+shiftLength_i+1,shiftj+shiftLength_j+1,degree+11) = mean(Planes(:));

        end
    end
end
final_score = min(score(:));

end