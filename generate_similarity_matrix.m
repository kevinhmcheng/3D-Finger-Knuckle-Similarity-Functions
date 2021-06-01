%generate_similarity_matrix
%input: mean_density, length=16 means 16 possible cases for 4-bits feature
%output: score_map, length=256 means 256 possible matching cases for a
%pair of 4-bits feature templates
Nbits = 4;

occurance_rand = ones(Nbits^2,Nbits^2);
for i = 1:Nbits^2
    for j = 1:Nbits^2
        occurance_rand(i,j) = mean_density(i)*mean_density(j);
    end
end
occurance_rand = reshape(occurance_rand,[1, Nbits^2*Nbits^2])';
%
occurance_ideal = zeros(Nbits^2,Nbits^2);
for i = 1:Nbits^2
    for j = 1:Nbits^2
        if(i~=j)
            occurance_ideal(i,j) = (mean_density(i)*mean_density(j)/(1-mean_density(i)) + mean_density(j)*mean_density(i)/(1-mean_density(j)))/2;
        end
    end
end
occurance_ideal = reshape(occurance_ideal,[1, Nbits^4])';
occurance_ideal([1:Nbits^2+1:Nbits^4]) = mean_density;

vector1 = 1:Nbits^2+1:Nbits^4;
vector2 = setdiff(1:Nbits^4,vector1);

diff = abs(occurance_ideal-occurance_rand);
diff_m = mean(diff([vector1]));
diff_n = mean(diff([vector2]));
sig  = diff_m/diff_n;

score_map = (1./occurance_ideal/(Nbits^4-Nbits^2));
score_map(vector1) = -(Nbits^4-Nbits^2)/Nbits^2*sig*score_map(vector1);